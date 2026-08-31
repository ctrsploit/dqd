package catalog

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

// Embedded file names inside the snapshot directory.
const (
	EmbedIndexName = "index.json"
	EmbedTreeName  = "tree.json"
	// KeysPrefix is the reserved path prefix for the dqd SSH key pair,
	// copied from the repository's ssh_config/ directory.
	KeysPrefix = "_keys/"
)

// FilesForEnv lists the repository-relative config files of an env
// that participate in the embedded snapshot, in fixed order.
func FilesForEnv(e *Env) []string {
	if !e.HasCompose {
		return nil
	}
	files := []string{e.Path + "/" + composeName}
	if e.HasKVM {
		files = append(files, e.Path+"/"+kvmName)
	}
	files = append(files, e.Path+"/"+envFileName) // may not exist; skipped
	return files
}

// WriteTreeJSON writes the embedded snapshot as a deterministic JSON
// object mapping repository-relative paths to file contents. Text
// (not tar/zip) on purpose: the snapshot is committed, and text keeps
// it reviewable in diffs. Go's encoding/json sorts map keys, so the
// output is byte-stable for a given repository state.
func WriteTreeJSON(w io.Writer, ix *Index, repoRoot string) error {
	files := map[string]string{}
	read := func(name, repoRel string) error {
		if _, done := files[name]; done {
			return nil
		}
		data, err := os.ReadFile(filepath.Join(repoRoot, filepath.FromSlash(repoRel)))
		if err != nil {
			if os.IsNotExist(err) {
				return nil
			}
			return err
		}
		files[name] = string(data)
		return nil
	}
	for i := range ix.Envs {
		for _, name := range FilesForEnv(&ix.Envs[i]) {
			if err := read(name, name); err != nil {
				return err
			}
		}
	}
	for _, key := range []string{"dqd", "dqd.pub"} {
		// keys live under ssh_config/ in the repository
		if err := read(KeysPrefix+key, keysDirName+"/"+key); err != nil {
			return err
		}
	}
	enc := json.NewEncoder(w)
	enc.SetIndent("", "  ")
	return enc.Encode(files)
}

// Tree holds an in-memory embedded snapshot.
type Tree struct {
	Files map[string][]byte // repository-relative path -> content
}

// ReadTree parses the embedded snapshot document.
func ReadTree(data []byte) (*Tree, error) {
	var m map[string]string
	if err := json.Unmarshal(data, &m); err != nil {
		return nil, fmt.Errorf("parse %s: %w", EmbedTreeName, err)
	}
	t := &Tree{Files: make(map[string][]byte, len(m))}
	for name, content := range m {
		t.Files[name] = []byte(content)
	}
	return t, nil
}

// Extract writes every file under the given dir prefixes (and the
// reserved keys prefix when asked) into dest, preserving the
// repository-relative layout so compose `extends:` file references
// keep resolving.
func (t *Tree) Extract(dest string, prefixes []string, withKeys bool) error {
	for name, data := range t.Files {
		if !withKeys && strings.HasPrefix(name, KeysPrefix) {
			continue
		}
		matched := false
		for _, p := range prefixes {
			if p == "" || strings.HasPrefix(name, p+"/") {
				matched = true
				break
			}
		}
		if !matched {
			continue
		}
		out := filepath.Join(dest, filepath.FromSlash(name))
		if err := os.MkdirAll(filepath.Dir(out), 0o755); err != nil {
			return err
		}
		if err := os.WriteFile(out, data, 0o644); err != nil {
			return err
		}
	}
	return nil
}

// Key returns the embedded key file content ("dqd" or "dqd.pub").
func (t *Tree) Key(name string) ([]byte, bool) {
	data, ok := t.Files[KeysPrefix+name]
	return data, ok
}

// MarshalIndex renders an index as deterministic pretty JSON.
func MarshalIndex(ix *Index) ([]byte, error) {
	data, err := json.MarshalIndent(ix, "", "  ")
	if err != nil {
		return nil, err
	}
	return append(data, '\n'), nil
}

// ParseIndex reads an index document.
func ParseIndex(data []byte) (*Index, error) {
	var ix Index
	if err := json.Unmarshal(data, &ix); err != nil {
		return nil, fmt.Errorf("parse index: %w", err)
	}
	return &ix, nil
}
