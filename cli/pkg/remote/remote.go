// Package remote fetches configuration from the dqd repository over
// HTTPS: the catalog index for update checks, and per-environment
// compose files when the user opts into the remote channel.
package remote

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/ctrsploit/dqd/cli/pkg/catalog"
)

// Defaults; overridable for mirrors/proxies and tests.
const (
	DefaultRawBase = "https://raw.githubusercontent.com/ctrsploit/dqd"
	DefaultRef     = "main"
)

// Config for remote access.
type Config struct {
	Base   string // DQD_RAW_BASE override
	Ref    string // DQD_REF override (default "main")
	Token  string // optional GITHUB_TOKEN for private repos
	Client *http.Client
}

// ConfigFromEnv builds a Config from environment variables; defaultBase
// (from the assembling binary's cli.Identity) applies when DQD_RAW_BASE
// is unset, so downstream CLIs can default to their own repository.
func ConfigFromEnv(defaultBase string) Config {
	cfg := Config{Base: os.Getenv("DQD_RAW_BASE"), Ref: os.Getenv("DQD_REF"), Token: os.Getenv("GITHUB_TOKEN")}
	if cfg.Base == "" {
		cfg.Base = defaultBase
	}
	if cfg.Ref == "" {
		cfg.Ref = DefaultRef
	}
	return cfg
}

func (c Config) client() *http.Client {
	if c.Client != nil {
		return c.Client
	}
	return &http.Client{Timeout: 5 * time.Second}
}

func (c Config) url(path string) string {
	return strings.TrimRight(c.Base, "/") + "/" + strings.TrimPrefix(path, "/")
}

func (c Config) get(path string) ([]byte, int, error) {
	req, err := http.NewRequest(http.MethodGet, c.url(path), nil)
	if err != nil {
		return nil, 0, err
	}
	if c.Token != "" {
		req.Header.Set("Authorization", "Bearer "+c.Token)
	}
	resp, err := c.client().Do(req)
	if err != nil {
		return nil, 0, err
	}
	defer resp.Body.Close()
	data, err := io.ReadAll(io.LimitReader(resp.Body, 16<<20))
	return data, resp.StatusCode, err
}

// FetchIndex downloads catalog.json at the configured ref.
func FetchIndex(cfg Config) (*catalog.Index, error) {
	data, status, err := cfg.get(cfg.Ref + "/catalog.json")
	if err != nil {
		return nil, fmt.Errorf("fetch remote catalog: %w", err)
	}
	if status != http.StatusOK {
		return nil, fmt.Errorf("fetch remote catalog: HTTP %d", status)
	}
	return catalog.ParseIndex(data)
}

// Diff summarizes how the remote index differs from a local one.
type Diff struct {
	Changed []string // same path, different compose hash
	Added   []string // remote-only paths
	Removed []string // local-only paths
}

// Of computes the env-level diff between two indexes.
func Of(local, remoteIdx *catalog.Index) Diff {
	var d Diff
	localHashes := map[string]string{}
	for _, e := range local.Envs {
		localHashes[e.Path] = e.ComposeHash
	}
	remoteHashes := map[string]string{}
	for _, e := range remoteIdx.Envs {
		remoteHashes[e.Path] = e.ComposeHash
		if h, ok := localHashes[e.Path]; ok {
			if h != e.ComposeHash {
				d.Changed = append(d.Changed, e.Path)
			}
		} else {
			d.Added = append(d.Added, e.Path)
		}
	}
	for path := range localHashes {
		if _, ok := remoteHashes[path]; !ok {
			d.Removed = append(d.Removed, path)
		}
	}
	return d
}

// IsEmpty reports no differences.
func (d Diff) IsEmpty() bool {
	return len(d.Changed) == 0 && len(d.Added) == 0 && len(d.Removed) == 0
}

// FetchEnv downloads one environment's config files (and those of its
// includes, recursively) into dest, preserving the repository-relative
// layout so `extends:` file references keep resolving.
func FetchEnv(cfg Config, e *catalog.Env, dest string) error {
	seen := map[string]bool{}
	var walk func(envPath string) error
	walk = func(envPath string) error {
		if seen[envPath] {
			return nil
		}
		seen[envPath] = true
		for _, name := range []string{"docker-compose.yml", "docker-compose.kvm.yml", ".env"} {
			data, status, err := cfg.get(cfg.Ref + "/" + envPath + "/" + name)
			if err != nil {
				return fmt.Errorf("fetch %s/%s: %w", envPath, name, err)
			}
			if status == http.StatusNotFound {
				continue
			}
			if status != http.StatusOK {
				return fmt.Errorf("fetch %s/%s: HTTP %d", envPath, name, status)
			}
			out := filepath.Join(dest, filepath.FromSlash(envPath), name)
			if err := os.MkdirAll(filepath.Dir(out), 0o755); err != nil {
				return err
			}
			if err := os.WriteFile(out, data, 0o644); err != nil {
				return err
			}
		}
		// follow includes recorded in the index (cluster aggregators)
		if envPath == e.Path {
			for _, inc := range e.Includes {
				if err := walk(inc); err != nil {
					return err
				}
			}
		}
		return nil
	}
	return walk(e.Path)
}
