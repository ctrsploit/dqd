// Package resolve maps a user-supplied environment argument to the
// directory whose docker-compose.yml must run, through the
// three-channel chain agreed in the design:
//
//  1. a local directory containing compose/.env (repo / developer mode)
//  2. the remote config cache (user opted into remote)
//  3. the embedded snapshot, materialized on demand
//  4. a remote fetch for environments missing from the snapshot
package resolve

import (
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/ctrsploit/dqd/cli/internal/catalog"
	"github.com/ctrsploit/dqd/cli/internal/dqdpaths"
)

// Source names the channel a resolution came from.
type Source string

const (
	SourceLocal       Source = "local"        // directory on this machine
	SourceRemoteCache Source = "remote-cache" // fetched-from-remote cache
	SourceEmbedded    Source = "embedded"     // snapshot baked into the binary
	SourceRemote      Source = "remote"       // freshly fetched this run
)

// Result is a resolved environment.
type Result struct {
	Env    *catalog.Env
	Dir    string // directory containing docker-compose.yml
	Source Source
}

// RemoteDecider lets the CLI layer inject the update-check behavior
// (fetch remote index, compare hashes, ask the user) without the
// resolver depending on networking or terminals.
type RemoteDecider interface {
	// Decide is consulted before the embedded snapshot is used for an
	// env the binary knows. It returns a directory of remotely fetched
	// files to use instead, or "" to keep the embedded snapshot. The
	// returned env (may be nil) carries authoritative metadata (e.g.
	// SSH credentials) that the fetched files alone cannot provide.
	Decide(e *catalog.Env) (dir string, meta *catalog.Env)

	// MissingEnv is consulted when nothing local, cached or embedded
	// matches. It may fetch and return a directory, or "".
	MissingEnv(p string) (dir string, meta *catalog.Env)
}

// Options configure a Resolver.
type Options struct {
	Index *catalog.Index
	Tree  *catalog.Tree
	// Remote is optional; when nil, channels 2 and 4 degrade to
	// "not available" (pure offline self-contained mode).
	Remote RemoteDecider
}

// Resolver resolves environment arguments.
type Resolver struct {
	opts       Options
	treeCache  string
	remoteRoot string
}

// New builds a resolver; cache directories are created lazily.
func New(opts Options) (*Resolver, error) {
	treeCache, err := dqdpaths.TreeCacheDir()
	if err != nil {
		return nil, err
	}
	remoteRoot, err := dqdpaths.RemoteCacheDir()
	if err != nil {
		return nil, err
	}
	return &Resolver{opts: opts, treeCache: treeCache, remoteRoot: remoteRoot}, nil
}

// Index exposes the embedded/local index to commands (list, ps joins).
func (r *Resolver) Index() *catalog.Index { return r.opts.Index }

// Resolve maps arg to a runnable environment directory.
func (r *Resolver) Resolve(arg string) (*Result, error) {
	// Channel 1: local directory (absolute or relative paths allowed —
	// this is how repo checkouts and custom env dirs work).
	if dir, ok := localEnvDir(arg); ok {
		env, err := catalog.Inspect(dir, normalizeID(arg))
		if err != nil {
			return nil, err
		}
		return &Result{Env: env, Dir: dir, Source: SourceLocal}, nil
	}

	id := normalizeID(arg)
	if id == "" || id == "." || strings.HasPrefix(id, "../") || id == ".." {
		return nil, fmt.Errorf("invalid environment %q", arg)
	}

	// Channel 2: user-opted remote cache.
	if dir := filepath.Join(r.remoteRoot, filepath.FromSlash(id)); hasCompose(dir) {
		env, err := catalog.Inspect(dir, id)
		if err != nil {
			return nil, err
		}
		restoreCreds(env, r.opts.Index.Env(id))
		return &Result{Env: env, Dir: dir, Source: SourceRemoteCache}, nil
	}

	// Channel 3: embedded snapshot (with an optional update decision).
	if r.opts.Index != nil {
		if entry := r.opts.Index.Env(id); entry != nil {
			if r.opts.Remote != nil {
				if dir, meta := r.opts.Remote.Decide(entry); dir != "" && hasCompose(dir) {
					env, err := catalog.Inspect(dir, id)
					if err != nil {
						return nil, err
					}
					restoreCreds(env, meta)
					return &Result{Env: env, Dir: dir, Source: SourceRemoteCache}, nil
				}
			}
			return r.materialize(entry)
		}
	}

	// Channel 4: not embedded — try fetching from the remote.
	if r.opts.Remote != nil {
		if dir, meta := r.opts.Remote.MissingEnv(id); dir != "" && hasCompose(dir) {
			env, err := catalog.Inspect(dir, id)
			if err != nil {
				return nil, err
			}
			restoreCreds(env, meta)
			return &Result{Env: env, Dir: dir, Source: SourceRemote}, nil
		}
	}

	return nil, notFoundError(r.opts.Index, arg)
}

// materialize extracts the env (plus its includes, so cluster
// aggregator `extends:` paths keep resolving) from the embedded tar.
func (r *Resolver) materialize(entry *catalog.Env) (*Result, error) {
	if r.opts.Tree == nil {
		return nil, fmt.Errorf("environment %s: no embedded config snapshot in this build", entry.Path)
	}
	if !entry.HasCompose {
		return nil, fmt.Errorf("environment %s has no docker-compose.yml (build-only)", entry.Path)
	}
	prefixes := append([]string{entry.Path}, entry.Includes...)
	if err := r.opts.Tree.Extract(r.treeCache, prefixes, false); err != nil {
		return nil, fmt.Errorf("materialize %s: %w", entry.Path, err)
	}
	dir := filepath.Join(r.treeCache, filepath.FromSlash(entry.Path))
	if !hasCompose(dir) {
		return nil, fmt.Errorf("environment %s: embedded snapshot incomplete (no compose file)", entry.Path)
	}
	env, err := catalog.Inspect(dir, entry.Path)
	if err != nil {
		return nil, err
	}
	// The materialized tree carries compose/.env but not the per-env
	// `ssh` script, so Inspect would fall back to root/root; the index
	// entry (built from the full checkout) keeps the real credentials.
	restoreCreds(env, entry)
	return &Result{Env: env, Dir: dir, Source: SourceEmbedded}, nil
}

// restoreCreds copies SSH credentials (and cluster metadata) from an
// index entry onto a freshly inspected env when the inspected files
// could not provide them.
func restoreCreds(env, meta *catalog.Env) {
	if meta == nil {
		return
	}
	if meta.SSHUser != "" {
		env.SSHUser = meta.SSHUser
	}
	if meta.SSHPassword != "" {
		env.SSHPassword = meta.SSHPassword
	}
	if meta.Cluster != "" {
		env.Cluster = meta.Cluster
	}
}

// localEnvDir reports whether arg is a directory that looks like an
// environment (has .env or docker-compose.yml), mirroring the
// bash CLI's require_env_dir/require_runtime_env split.
func localEnvDir(arg string) (string, bool) {
	if arg == "" {
		return "", false
	}
	info, err := os.Stat(arg)
	if err != nil || !info.IsDir() {
		return "", false
	}
	if hasCompose(arg) {
		return arg, true
	}
	if _, err := os.Stat(filepath.Join(arg, ".env")); err == nil {
		return arg, true
	}
	return "", false
}

func hasCompose(dir string) bool {
	_, err := os.Stat(filepath.Join(dir, "docker-compose.yml"))
	return err == nil
}

// normalizeID canonicalizes an environment ID to a clean slash path.
func normalizeID(arg string) string {
	return path.Clean(strings.TrimSuffix(filepath.ToSlash(arg), "/"))
}

// notFoundError suggests close matches, like a package manager would.
func notFoundError(ix *catalog.Index, arg string) error {
	if ix == nil || len(ix.Envs) == 0 {
		return fmt.Errorf("unknown environment %q and no config snapshot is embedded in this build (build with `make cli`)", arg)
	}
	var candidates []string
	prefix := normalizeID(arg)
	for _, e := range ix.Envs {
		if strings.HasPrefix(e.Path, prefix) {
			candidates = append(candidates, e.Path)
			continue
		}
		if levenshtein(e.Path, prefix) <= 2 {
			candidates = append(candidates, e.Path)
		}
	}
	if len(candidates) > 8 {
		candidates = candidates[:8]
	}
	if len(candidates) == 0 {
		return fmt.Errorf("unknown environment %q (try `dqd list`)", arg)
	}
	return fmt.Errorf("unknown environment %q; did you mean one of:\n  %s", arg, strings.Join(candidates, "\n  "))
}

func levenshtein(a, b string) int {
	prev := make([]int, len(b)+1)
	cur := make([]int, len(b)+1)
	for j := range prev {
		prev[j] = j
	}
	for i := 1; i <= len(a); i++ {
		cur[0] = i
		for j := 1; j <= len(b); j++ {
			cost := 1
			if a[i-1] == b[j-1] {
				cost = 0
			}
			cur[j] = min3(cur[j-1]+1, prev[j]+1, prev[j-1]+cost)
		}
		prev, cur = cur, prev
	}
	return prev[len(b)]
}

func min3(a, b, c int) int {
	if b < a {
		a = b
	}
	if c < a {
		a = c
	}
	return a
}
