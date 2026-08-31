package resolve

import (
	"bytes"
	"os"
	"path/filepath"
	"testing"

	"github.com/ctrsploit/dqd/cli/internal/catalog"
	"github.com/ctrsploit/dqd/cli/internal/dqdpaths"
)

const testCompose = `services:
  vm:
    image: ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0
    ports:
        - "24040:22"
    tty: true
    stdin_open: true
`

// buildFixture writes a mini dqd repo (one env + one cluster) and
// returns its root plus an in-memory index/tree snapshot of it.
func buildFixture(t *testing.T) (root string, ix *catalog.Index, tree *catalog.Tree) {
	t.Helper()
	root = t.TempDir()
	files := map[string]string{
		"ubuntu/24.04/.env":                   "VERSION=v0.4.0\nIMAGE=ubuntu-24.04\nCOMPOSE_PROJECT_NAME=ubuntu-24-04\n",
		"ubuntu/24.04/docker-compose.yml":     testCompose,
		"ubuntu/24.04/docker-compose.kvm.yml": "services:\n  vm:\n    devices:\n      - \"/dev/kvm:/dev/kvm\"\n",
		"cluster/.env":                        "COMPOSE_PROJECT_NAME=cluster\nSKIP_SSH_CONFIG=true\n",
		"cluster/docker-compose.yml":          "services:\n  master:\n    extends:\n      file: master/docker-compose.yml\n      service: master\n  worker:\n    extends:\n      file: worker/docker-compose.yml\n      service: worker\n",
		"cluster/master/.env":                 "VERSION=v1\nIMAGE=master\n",
		"cluster/master/docker-compose.yml":   "services:\n  master:\n    image: ghcr.io/ctrsploit/master:v1\n    ports:\n        - \"13404:22\"\n",
		"cluster/worker/.env":                 "VERSION=v1\nIMAGE=worker\n",
		"cluster/worker/docker-compose.yml":   "services:\n  worker:\n    image: ghcr.io/ctrsploit/worker:v1\n    ports:\n        - \"13406:22\"\n",
	}
	for name, content := range files {
		path := filepath.Join(root, name)
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	ix, err := catalog.Generate(root)
	if err != nil {
		t.Fatal(err)
	}
	var buf bytes.Buffer
	if err := catalog.WriteTreeJSON(&buf, ix, root); err != nil {
		t.Fatal(err)
	}
	tree, err = catalog.ReadTree(buf.Bytes())
	if err != nil {
		t.Fatal(err)
	}
	return root, ix, tree
}

func newTestResolver(t *testing.T, ix *catalog.Index, tree *catalog.Tree) *Resolver {
	t.Helper()
	t.Setenv("DQD_CACHE", t.TempDir())
	t.Setenv("DQD_CONFIG", t.TempDir())
	r, err := New(Options{Index: ix, Tree: tree})
	if err != nil {
		t.Fatal(err)
	}
	return r
}

func TestResolveLocalDir(t *testing.T) {
	root, ix, tree := buildFixture(t)
	r := newTestResolver(t, ix, tree)

	// relative to cwd inside the fixture
	oldwd, _ := os.Getwd()
	defer os.Chdir(oldwd)
	if err := os.Chdir(root); err != nil {
		t.Fatal(err)
	}
	res, err := r.Resolve("ubuntu/24.04")
	if err != nil {
		t.Fatal(err)
	}
	if res.Source != SourceLocal {
		t.Errorf("Source = %s, want local", res.Source)
	}
	if res.Env.SSHPort != "24040" || res.Env.Project != "ubuntu-24-04" {
		t.Errorf("env fields wrong: %+v", res.Env)
	}

	// absolute path works too
	res, err = r.Resolve(filepath.Join(root, "ubuntu/24.04"))
	if err != nil || res.Source != SourceLocal {
		t.Errorf("absolute resolve: %v %+v", err, res)
	}
}

func TestResolveEmbeddedMaterialize(t *testing.T) {
	root, ix, tree := buildFixture(t)
	_ = root
	r := newTestResolver(t, ix, tree)

	// not a local dir from this cwd -> embedded channel
	res, err := r.Resolve("ubuntu/24.04")
	if err != nil {
		t.Fatal(err)
	}
	if res.Source != SourceEmbedded {
		t.Fatalf("Source = %s, want embedded", res.Source)
	}
	if res.Env.SSHPort != "24040" {
		t.Errorf("SSHPort = %q", res.Env.SSHPort)
	}
	if !res.Env.HasKVM {
		t.Error("HasKVM = false, want true (kvm overlay materialized)")
	}
	data, err := os.ReadFile(filepath.Join(res.Dir, "docker-compose.yml"))
	if err != nil || string(data) != testCompose {
		t.Errorf("materialized compose mismatch: %v", err)
	}
}

func TestResolveClusterIncludes(t *testing.T) {
	_, ix, tree := buildFixture(t)
	r := newTestResolver(t, ix, tree)

	res, err := r.Resolve("cluster")
	if err != nil {
		t.Fatal(err)
	}
	// extends file must resolve: master/worker compose files extracted
	for _, sub := range []string{"master", "worker"} {
		if _, err := os.Stat(filepath.Join(res.Dir, sub, "docker-compose.yml")); err != nil {
			t.Errorf("include %s not materialized: %v", sub, err)
		}
	}
	// members carry cluster metadata
	m := ix.Env("cluster/master")
	if m == nil || m.Cluster != "cluster" {
		t.Errorf("cluster master entry wrong: %+v", m)
	}
}

func TestResolveRemoteCacheChannelAndCreds(t *testing.T) {
	_, ix, tree := buildFixture(t)
	r := newTestResolver(t, ix, tree)

	// simulate a fetched remote cache for ubuntu/24.04 with a ctf-style
	// ssh script absent -> creds must come from the index entry
	remoteRoot, _ := dqdpaths.RemoteCacheDir()
	dir := filepath.Join(remoteRoot, "ubuntu/24.04")
	if err := os.MkdirAll(dir, 0o755); err != nil {
		t.Fatal(err)
	}
	alt := "services:\n  vm:\n    image: ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0\n    ports:\n        - \"24099:22\"\n"
	if err := os.WriteFile(filepath.Join(dir, "docker-compose.yml"), []byte(alt), 0o644); err != nil {
		t.Fatal(err)
	}
	// index claims ctf credentials for this env
	ix.Env("ubuntu/24.04").SSHUser = "ctf"
	ix.Env("ubuntu/24.04").SSHPassword = "ctf"

	res, err := r.Resolve("ubuntu/24.04")
	if err != nil {
		t.Fatal(err)
	}
	if res.Source != SourceRemoteCache {
		t.Fatalf("Source = %s, want remote-cache", res.Source)
	}
	if res.Env.SSHPort != "24099" {
		t.Errorf("SSHPort = %q, want the remote cache port 24099", res.Env.SSHPort)
	}
	if res.Env.SSHUser != "ctf" || res.Env.SSHPassword != "ctf" {
		t.Errorf("creds = %s/%s, want ctf/ctf from index", res.Env.SSHUser, res.Env.SSHPassword)
	}
}

func TestResolveUnknown(t *testing.T) {
	_, ix, tree := buildFixture(t)
	r := newTestResolver(t, ix, tree)
	if _, err := r.Resolve("nope/missing"); err == nil {
		t.Fatal("expected error for unknown env")
	}
	if _, err := r.Resolve("../escape"); err == nil {
		t.Fatal("expected error for path escape")
	}
}

func TestResolveRemoteDeciderOverride(t *testing.T) {
	_, ix, tree := buildFixture(t)
	r := newTestResolver(t, ix, tree)

	// decider returns a dir with compose files for a known env
	override := t.TempDir()
	if err := os.WriteFile(filepath.Join(override, "docker-compose.yml"), []byte(testCompose), 0o644); err != nil {
		t.Fatal(err)
	}
	meta := catalog.Env{Path: "ubuntu/24.04", SSHUser: "ctf", SSHPassword: "ctf"}
	r.opts.Remote = fakeDecider{dir: override, meta: &meta, path: "ubuntu/24.04"}

	res, err := r.Resolve("ubuntu/24.04")
	if err != nil {
		t.Fatal(err)
	}
	if res.Source != SourceRemoteCache {
		t.Fatalf("Source = %s, want remote-cache via decider", res.Source)
	}
	if res.Env.SSHUser != "ctf" {
		t.Errorf("SSHUser = %s, want ctf from decider meta", res.Env.SSHUser)
	}

	// missing env fetched through MissingEnv
	missing := t.TempDir()
	if err := os.WriteFile(filepath.Join(missing, "docker-compose.yml"), []byte(testCompose), 0o644); err != nil {
		t.Fatal(err)
	}
	r.opts.Remote = fakeDecider{dir: missing, meta: nil, path: "new/env"}
	res, err = r.Resolve("new/env")
	if err != nil || res.Source != SourceRemote {
		t.Errorf("missing-env resolve: %v %+v", err, res)
	}
}

type fakeDecider struct {
	dir, path string
	meta      *catalog.Env
}

func (f fakeDecider) Decide(e *catalog.Env) (string, *catalog.Env) {
	if e.Path == f.path {
		return f.dir, f.meta
	}
	return "", nil
}

func (f fakeDecider) MissingEnv(p string) (string, *catalog.Env) {
	if p == f.path {
		return f.dir, f.meta
	}
	return "", nil
}
