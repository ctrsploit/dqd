// Package catalog builds and reads the dqd environment index.
//
// The index is the single machine-readable summary of every
// environment directory in a dqd repository checkout: it feeds
// `dqd list/info`, the embedded config snapshot, and the remote
// update check (catalog.json at the repository root).
package catalog

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"

	"github.com/ctrsploit/dqd/cli/pkg/envfile"
)

// Env describes one environment directory (<ENV> with a .env file).
type Env struct {
	// Path is the environment directory relative to the repo root,
	// e.g. "ubuntu/24.04". It doubles as the standalone env ID.
	Path string `json:"path"`

	HasCompose    bool     `json:"has_compose"`
	Image         string   `json:"image,omitempty"`     // full ref from compose image:
	EnvImage      string   `json:"env_image,omitempty"` // .env IMAGE (list parity with bin/dqd)
	EnvVersion    string   `json:"env_version,omitempty"`
	Ports         []string `json:"ports,omitempty"` // raw "host:container" entries
	SSHPort       string   `json:"ssh_port,omitempty"`
	SSHUser       string   `json:"ssh_user,omitempty"`
	SSHPassword   string   `json:"ssh_password,omitempty"`
	Project       string   `json:"project"` // compose project name
	HasKVM        bool     `json:"has_kvm,omitempty"`
	KVMCommand    string   `json:"kvm_command,omitempty"` // kvm overlay command override
	Services      []string `json:"services,omitempty"`
	Cluster       string   `json:"cluster,omitempty"` // parent cluster dir, for master/worker members
	Includes      []string `json:"includes,omitempty"`
	SkipSSHConfig bool     `json:"skip_ssh_config,omitempty"`
	ComposeHash   string   `json:"compose_hash,omitempty"`
}

// Index is the catalog document (catalog.json / embedded index.json).
type Index struct {
	Commit string `json:"commit,omitempty"`
	Envs   []Env  `json:"envs"`
}

// Env returns the entry for path, or nil.
func (ix *Index) Env(path string) *Env {
	for i := range ix.Envs {
		if ix.Envs[i].Path == path {
			return &ix.Envs[i]
		}
	}
	return nil
}

// ProjectToEnv maps compose project names to env entries.
func (ix *Index) ProjectToEnv() map[string]*Env {
	m := map[string]*Env{}
	for i := range ix.Envs {
		if ix.Envs[i].Project != "" {
			m[ix.Envs[i].Project] = &ix.Envs[i]
		}
	}
	return m
}

const (
	envFileName = ".env"
	composeName = "docker-compose.yml"
	kvmName     = "docker-compose.kvm.yml"
	sshScript   = "ssh"
	keysDirName = "ssh_config"
	defaultUser = "root"
	defaultPass = "root"
)

// skipDirs are repository subtrees that never contain environments.
var skipDirs = map[string]bool{
	".git": true, ".github": true, ".docker-buildx": true, ".idea": true,
	".claude": true, ".agents": true, ".codex": true, ".opencode": true,
	"modules": true, "node_modules": true, "cli": true, "script": true,
	"ssh_config": true,
}

var sshScriptRe = regexp.MustCompile(`sshpass -p (\S+) ssh .* -p \d+ (\S+)@127\.0\.0\.1`)

// Generate scans a dqd repository checkout and builds the index.
func Generate(repoRoot string) (*Index, error) {
	rootAbs, err := filepath.Abs(repoRoot)
	if err != nil {
		return nil, err
	}
	var envDirs []string
	err = filepath.WalkDir(rootAbs, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.IsDir() {
			// match the bash tooling's `find -type f -name .env`:
			// regular files only — symlinked .env alias dirs
			// (kubernetes/*/default) are skipped
			if d.Name() == envFileName && d.Type().IsRegular() {
				rel, rerr := filepath.Rel(rootAbs, filepath.Dir(path))
				if rerr != nil {
					return rerr
				}
				envDirs = append(envDirs, rel)
			}
			return nil
		}
		if path != rootAbs && skipDirs[d.Name()] {
			return fs.SkipDir
		}
		return nil
	})
	if err != nil {
		return nil, fmt.Errorf("walk %s: %w", rootAbs, err)
	}
	// Sort by the "<dir>/.env" path the way the bash pipeline sorts
	// find output, so catalog order matches bin/dqd list exactly
	// ('-' < '/' puts "v28.0.4-foo" before "v28.0.4").
	sort.Slice(envDirs, func(i, j int) bool {
		return envDirs[i]+"/.env" < envDirs[j]+"/.env"
	})

	ix := &Index{Envs: make([]Env, 0, len(envDirs))}
	for _, rel := range envDirs {
		env, err := Inspect(filepath.Join(rootAbs, rel), rel)
		if err != nil {
			return nil, err
		}
		ix.Envs = append(ix.Envs, *env)
	}

	// Mark cluster members: when an env extends files from other env
	// dirs (the kubernetes cluster aggregators), those members belong
	// to the aggregator's cluster.
	byPath := map[string]int{}
	for i, e := range ix.Envs {
		byPath[e.Path] = i
	}
	for _, e := range ix.Envs {
		for _, inc := range e.Includes {
			if j, ok := byPath[inc]; ok {
				ix.Envs[j].Cluster = e.Path
			}
		}
	}
	return ix, nil
}

// Inspect builds the index entry for a single environment directory.
// rel is the directory path relative to the repository root (used for
// Path, Includes and ComposeHash); it may be "" semantics-free for
// out-of-repo dirs, where only local-file fields are meaningful.
func Inspect(dir, rel string) (*Env, error) {
	e := &Env{
		Path:        filepath.ToSlash(rel),
		SSHUser:     defaultUser,
		SSHPassword: defaultPass,
	}

	envPath := filepath.Join(dir, envFileName)
	if envData, err := os.ReadFile(envPath); err == nil {
		ef, err := envfile.ParseEnv(envData)
		if err != nil {
			return nil, fmt.Errorf("%s: %w", envPath, err)
		}
		e.EnvImage = ef.Get("IMAGE")
		e.EnvVersion = ef.Get("VERSION")
		e.SkipSSHConfig = ef.Bool("SKIP_SSH_CONFIG")
		if p := ef.Get("COMPOSE_PROJECT_NAME"); p != "" {
			e.Project = p
		}
	}

	composePath := filepath.Join(dir, composeName)
	composeData, err := os.ReadFile(composePath)
	if err == nil {
		e.HasCompose = true
		c, perr := envfile.ParseCompose(composeData)
		if perr != nil {
			return nil, fmt.Errorf("%s: %w", composePath, perr)
		}
		e.Services = c.Names()
		for _, name := range e.Services {
			s := c.Services[name]
			if e.Image == "" && s.Image != "" {
				e.Image = s.Image
			}
			e.Ports = append(e.Ports, s.Ports...)
			if p := s.HostPortOf("22"); p != "" && e.SSHPort == "" {
				e.SSHPort = p
			}
			for _, f := range s.ExtendsFiles {
				inc := filepath.ToSlash(filepath.Clean(filepath.Join(rel, filepath.Dir(f))))
				e.Includes = appendUnique(e.Includes, inc)
			}
		}
	} else if !os.IsNotExist(err) {
		return nil, err
	}

	if e.Project == "" {
		e.Project = DeriveProject(filepath.Base(dir))
	}

	if kvmData, err := os.ReadFile(filepath.Join(dir, kvmName)); err == nil {
		e.HasKVM = true
		if c, perr := envfile.ParseCompose(kvmData); perr == nil {
			for _, name := range c.Names() {
				if cmd := c.Services[name].Command; cmd != "" {
					e.KVMCommand = cmd
				}
			}
		}
	}

	if sshData, err := os.ReadFile(filepath.Join(dir, sshScript)); err == nil {
		if m := sshScriptRe.FindSubmatch(sshData); m != nil {
			e.SSHPassword = string(m[1])
			e.SSHUser = string(m[2])
		}
	}

	// hash .env + compose + kvm contents in a fixed order
	hash := sha256.New()
	for _, name := range []string{envFileName, composeName, kvmName} {
		data, err := os.ReadFile(filepath.Join(dir, name))
		if err != nil {
			continue // missing files contribute nothing
		}
		fmt.Fprintf(hash, "%s\x00", name)
		hash.Write(data)
		hash.Write([]byte{0})
	}
	e.ComposeHash = "sha256:" + hex.EncodeToString(hash.Sum(nil))
	return e, nil
}

// DeriveProject mirrors docker compose's default project naming:
// the directory basename, lowercased, keeping only [a-z0-9_-].
func DeriveProject(base string) string {
	var b strings.Builder
	for _, r := range strings.ToLower(base) {
		switch {
		case r >= 'a' && r <= 'z', r >= '0' && r <= '9', r == '_', r == '-':
			b.WriteRune(r)
		}
	}
	if b.Len() == 0 {
		return "default"
	}
	return b.String()
}

func appendUnique(list []string, v string) []string {
	for _, x := range list {
		if x == v {
			return list
		}
	}
	return append(list, v)
}
