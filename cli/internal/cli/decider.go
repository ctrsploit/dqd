package cli

import (
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/term"

	"github.com/ctrsploit/dqd/cli/internal/catalog"
	"github.com/ctrsploit/dqd/cli/internal/dqdpaths"
	"github.com/ctrsploit/dqd/cli/internal/prefs"
	"github.com/ctrsploit/dqd/cli/internal/remote"
)

// updateDecider implements resolve.RemoteDecider: it fetches the
// remote catalog (once per run, best effort), compares per-env
// compose hashes and — when they differ — either asks the user
// (TTY only) or applies the persisted policy.
type updateDecider struct {
	app         *App
	remoteIndex *catalog.Index
	fetched     bool
}

// Decide is called before the embedded snapshot is used.
func (d *updateDecider) Decide(e *catalog.Env) (string, *catalog.Env) {
	rix := d.index()
	if rix == nil {
		return "", nil
	}
	re := rix.Env(e.Path)
	if re == nil || re.ComposeHash == e.ComposeHash {
		return "", nil
	}

	switch d.app.Prefs.Update {
	case prefs.UpdateRemote:
		return d.fetch(re)
	case prefs.UpdateEmbedded:
		d.noticeStale(rix, e.Path)
		return "", nil
	}

	// prompt policy: never block non-interactive runs
	if !term.IsTerminal(int(os.Stdin.Fd())) {
		d.noticeStale(rix, e.Path)
		return "", nil
	}
	var embeddedCommit string
	if ix := embeddedIndex(); ix != nil {
		embeddedCommit = ix.Commit
	}
	d.app.printf("remote config differs for %s (embedded %s, remote %s)\n",
		e.Path, shortCommit(embeddedCommit), shortCommit(rix.Commit))
	d.app.printf("[r] use remote this time  [e] keep embedded  [R] always remote  [E] always embedded: ")
	answer := readAnswer(d.app.Stdin)
	d.app.printf("\n")
	switch answer {
	case "r":
		return d.fetch(re)
	case "R":
		d.savePolicy(prefs.UpdateRemote)
		return d.fetch(re)
	case "E":
		d.savePolicy(prefs.UpdateEmbedded)
		return "", nil
	default: // "e" or anything unrecognized: safest is embedded
		return "", nil
	}
}

// MissingEnv is called when nothing local/cached/embedded matches.
func (d *updateDecider) MissingEnv(p string) (string, *catalog.Env) {
	if d.app.Prefs.Update == prefs.UpdateOff || d.app.Prefs.Update == prefs.UpdateEmbedded {
		return "", nil
	}
	rix := d.index()
	if rix == nil {
		return "", nil
	}
	re := rix.Env(p)
	if re == nil {
		return "", nil
	}
	d.app.eprintf("dqd: %s is not in the embedded snapshot; fetching from remote\n", p)
	return d.fetch(re)
}

// index lazily fetches the remote catalog once; nil on any failure
// (offline, policy off) — the embedded snapshot is the fallback.
func (d *updateDecider) index() *catalog.Index {
	if d.fetched {
		return d.remoteIndex
	}
	d.fetched = true
	if d.app.Prefs.Update == prefs.UpdateOff {
		return nil
	}
	ix, err := remote.FetchIndex(d.app.Remote)
	if err != nil {
		return nil
	}
	d.remoteIndex = ix
	return ix
}

// fetch downloads the env's files into the remote cache and returns
// the directory plus the remote index entry ("" on failure, with a
// notice).
func (d *updateDecider) fetch(re *catalog.Env) (string, *catalog.Env) {
	root, err := dqdpaths.RemoteCacheDir()
	if err != nil {
		return "", nil
	}
	if err := remote.FetchEnv(d.app.Remote, re, root); err != nil {
		d.app.eprintf("dqd: fetching remote config for %s failed (%v); using embedded\n", re.Path, err)
		return "", nil
	}
	return filepath.Join(root, filepath.FromSlash(re.Path)), re
}

func (d *updateDecider) noticeStale(rix *catalog.Index, path string) {
	d.app.eprintf("dqd: remote config for %s differs from this binary's snapshot (remote %s); run `dqd update` to switch\n",
		path, shortCommit(rix.Commit))
}

func (d *updateDecider) savePolicy(p string) {
	d.app.Prefs.Update = p
	if err := d.app.Prefs.Save(); err != nil {
		d.app.eprintf("dqd: saving preference failed: %v\n", err)
	}
}

// readAnswer reads a one-line answer from the terminal.
func readAnswer(stdin *os.File) string {
	var buf [8]byte
	n, err := stdin.Read(buf[:])
	if err != nil || n == 0 {
		return ""
	}
	return strings.TrimSpace(string(buf[:n]))
}

func shortCommit(c string) string {
	if len(c) > 8 {
		return c[:8]
	}
	if c == "" {
		return "unknown"
	}
	return c
}
