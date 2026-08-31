// Command dqd-gen generates the dqd catalog artifacts from a
// repository checkout:
//
//	dqd-gen catalog   write catalog.json (committed at the repo root;
//	                  the remote source for CLI update checks)
//	dqd-gen embed     write cli/embed/{index.json,tree.tar} (the
//	                  self-contained config snapshot baked into the
//	                  binary at build time; not committed)
//	dqd-gen check     verify the committed catalog.json matches the
//	                  checkout (CI freshness gate)
package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"reflect"

	"github.com/ctrsploit/dqd/cli/internal/catalog"
)

const usage = `usage: dqd-gen <command> [flags]

commands:
  catalog   write catalog.json from the repo tree
  embed     write cli/embed/{index.json,tree.tar} for go:embed
  check     fail when committed catalog.json is stale
`

func main() {
	if len(os.Args) < 2 {
		fmt.Fprint(os.Stderr, usage)
		os.Exit(2)
	}
	var err error
	switch os.Args[1] {
	case "catalog":
		err = runCatalog(os.Args[2:])
	case "embed":
		err = runEmbed(os.Args[2:])
	case "check":
		err = runCheck(os.Args[2:])
	default:
		fmt.Fprint(os.Stderr, usage)
		os.Exit(2)
	}
	if err != nil {
		fmt.Fprintf(os.Stderr, "dqd-gen: %v\n", err)
		os.Exit(1)
	}
}

func gitCommit(repo string) string {
	out, err := exec.Command("git", "-C", repo, "rev-parse", "HEAD").Output()
	if err != nil {
		return ""
	}
	return string(out[:len(out)-1]) // trim \n
}

func runCatalog(args []string) error {
	var repo, outPath string
	fs := flag.NewFlagSet("", flag.ExitOnError)
	fs.StringVar(&repo, "repo", ".", "dqd repository checkout root")
	fs.StringVar(&outPath, "out", "", "output path (default <repo>/catalog.json)")
	_ = fs.Parse(args)
	if outPath == "" {
		outPath = filepath.Join(repo, "catalog.json")
	}
	ix, err := catalog.Generate(repo)
	if err != nil {
		return err
	}
	data, err := catalog.MarshalIndex(ix)
	if err != nil {
		return err
	}
	if err := os.WriteFile(outPath, data, 0o644); err != nil {
		return err
	}
	fmt.Printf("wrote %s (%d envs)\n", outPath, len(ix.Envs))
	return nil
}

func runEmbed(args []string) error {
	var repo, outDir string
	fs := flag.NewFlagSet("", flag.ExitOnError)
	fs.StringVar(&repo, "repo", ".", "dqd repository checkout root")
	fs.StringVar(&outDir, "out", "cli/embed", "output directory for index.json and tree.tar")
	_ = fs.Parse(args)

	ix, err := catalog.Generate(repo)
	if err != nil {
		return err
	}
	ix.Commit = gitCommit(repo)
	if err := os.MkdirAll(outDir, 0o755); err != nil {
		return err
	}
	data, err := catalog.MarshalIndex(ix)
	if err != nil {
		return err
	}
	if err := os.WriteFile(filepath.Join(outDir, catalog.EmbedIndexName), data, 0o644); err != nil {
		return err
	}
	f, err := os.Create(filepath.Join(outDir, catalog.EmbedTreeName))
	if err != nil {
		return err
	}
	defer f.Close()
	if err := catalog.WriteTreeJSON(f, ix, repo); err != nil {
		return err
	}
	fmt.Printf("wrote %s/{%s,%s} (snapshot commit %s, %d envs)\n",
		outDir, catalog.EmbedIndexName, catalog.EmbedTreeName, ix.Commit, len(ix.Envs))
	return nil
}

func runCheck(args []string) error {
	var repo, catalogPath string
	fs := flag.NewFlagSet("", flag.ExitOnError)
	fs.StringVar(&repo, "repo", ".", "dqd repository checkout root")
	fs.StringVar(&catalogPath, "catalog", "", "committed catalog path (default <repo>/catalog.json)")
	_ = fs.Parse(args)
	if catalogPath == "" {
		catalogPath = filepath.Join(repo, "catalog.json")
	}

	current, err := catalog.Generate(repo)
	if err != nil {
		return err
	}
	data, err := os.ReadFile(catalogPath)
	if err != nil {
		return fmt.Errorf("catalog.json missing (run `dqd-gen catalog` and commit it): %w", err)
	}
	committed, err := catalog.ParseIndex(data)
	if err != nil {
		return fmt.Errorf("committed %s: %w", catalogPath, err)
	}
	// The commit field is informational only; ignore it.
	current.Commit, committed.Commit = "", ""

	if !reflect.DeepEqual(current.Envs, committed.Envs) {
		cur, _ := json.MarshalIndent(current.Envs, "", "  ")
		com, _ := json.MarshalIndent(committed.Envs, "", "  ")
		diff := firstDiff(cur, com)
		return fmt.Errorf("catalog.json is stale (first differing region:\n%s\n); run `make generate-catalog` and commit the result", diff)
	}
	fmt.Printf("OK: catalog.json matches the checkout (%d envs)\n", len(current.Envs))

	// The embedded snapshot must also match: index envs (commit field
	// aside) and a byte-identical tree.tar (deterministic by design).
	embedDir := filepath.Join(repo, "cli", "internal", "embedded", "live")
	if _, statErr := os.Stat(embedDir); os.IsNotExist(statErr) {
		// Foreign checkout reusing this toolchain (Makefile TOOLCHAIN_DIR):
		// it has no CLI and therefore no embedded snapshot to verify.
		// catalog.json above is its only committed artifact.
		fmt.Printf("OK: no embedded snapshot under %s (no cli/); skipped\n", repo)
		return nil
	}
	snapData, err := os.ReadFile(filepath.Join(embedDir, catalog.EmbedIndexName))
	if err != nil {
		return fmt.Errorf("embedded index.json missing (run `dqd-gen embed` and commit cli/internal/embedded/live): %w", err)
	}
	snap, err := catalog.ParseIndex(snapData)
	if err != nil {
		return fmt.Errorf("committed embedded index: %w", err)
	}
	snap.Commit = ""
	if !reflect.DeepEqual(current.Envs, snap.Envs) {
		return fmt.Errorf("embedded index.json is stale; run `make generate-catalog` and commit the result")
	}
	var tarBuf bytes.Buffer
	if err := catalog.WriteTreeJSON(&tarBuf, current, repo); err != nil {
		return err
	}
	committedTar, err := os.ReadFile(filepath.Join(embedDir, catalog.EmbedTreeName))
	if err != nil {
		return fmt.Errorf("embedded %s missing: %w", catalog.EmbedTreeName, err)
	}
	if !bytes.Equal(tarBuf.Bytes(), committedTar) {
		return fmt.Errorf("embedded %s is stale; run `make generate-catalog` and commit the result", catalog.EmbedTreeName)
	}
	fmt.Println("OK: embedded snapshot matches the checkout")
	return nil
}

// firstDiff returns a short window around the first differing byte
// of two JSON renderings, for human-readable staleness reports.
func firstDiff(a, b []byte) string {
	n := len(a)
	if len(b) < n {
		n = len(b)
	}
	i := 0
	for i < n && a[i] == b[i] {
		i++
	}
	start := i - 200
	if start < 0 {
		start = 0
	}
	endA, endB := i+200, i+200
	if endA > len(a) {
		endA = len(a)
	}
	if endB > len(b) {
		endB = len(b)
	}
	return fmt.Sprintf("  current: ...%s...\n  committed: ...%s...", a[start:endA], b[start:endB])
}
