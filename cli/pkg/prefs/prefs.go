// Package prefs persists user preferences (~/.config/dqd/config.toml).
//
// Only the remote-update policy is stored today; the file uses a
// minimal `key = "value"` subset of TOML that is trivially readable
// and writable without a TOML dependency.
package prefs

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/ctrsploit/dqd/cli/pkg/dqdpaths"
)

// Update policies.
const (
	UpdatePrompt   = "prompt"   // ask when the remote catalog differs (default)
	UpdateRemote   = "remote"   // always prefer remote configs
	UpdateEmbedded = "embedded" // always prefer the embedded snapshot
	UpdateOff      = "off"      // never contact the remote
)

// Valid reports whether s is a known update policy.
func Valid(s string) bool {
	switch s {
	case UpdatePrompt, UpdateRemote, UpdateEmbedded, UpdateOff:
		return true
	}
	return false
}

// Prefs are the persisted user preferences.
type Prefs struct {
	Update string
}

// Load reads preferences, applying defaults for missing entries.
func Load() Prefs {
	p := Prefs{Update: UpdatePrompt}
	dir, err := configDir()
	if err != nil {
		return p
	}
	data, err := os.ReadFile(filepath.Join(dir, "config.toml"))
	if err != nil {
		return p
	}
	for _, line := range strings.Split(string(data), "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		key, value, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		key = strings.TrimSpace(key)
		value = strings.Trim(strings.TrimSpace(value), `"`)
		if key == "update" && Valid(value) {
			p.Update = value
		}
	}
	return p
}

// Save writes preferences.
func (p Prefs) Save() error {
	dir, err := configDir()
	if err != nil {
		return err
	}
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	var b strings.Builder
	b.WriteString("# dqd CLI preferences\n")
	b.WriteString("update = \"" + p.Update + "\"\n")
	return os.WriteFile(filepath.Join(dir, "config.toml"), []byte(b.String()), 0o644)
}

func configDir() (string, error) { return dqdpaths.ConfigDir() }
