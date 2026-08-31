package catalog

import (
	"bytes"
	"os"
	"path/filepath"
	"testing"
)

// writeTree creates a fixture dqd repository layout under t.TempDir().
func writeTree(t *testing.T, files map[string]string) string {
	t.Helper()
	root := t.TempDir()
	for name, content := range files {
		path := filepath.Join(root, name)
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	return root
}

const standardEnv = `VERSION=v0.4.0
IMAGE=ubuntu-24.04
COMPOSE_PROJECT_NAME=ubuntu-24-04
`

const standardCompose = `services:
  vm:
    image: ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0
    ports:
        - "24040:22"
    tty: true
    stdin_open: true
`

func TestGenerateStandardEnv(t *testing.T) {
	root := writeTree(t, map[string]string{
		"ubuntu/24.04/.env":                   standardEnv,
		"ubuntu/24.04/docker-compose.yml":     standardCompose,
		"ubuntu/24.04/docker-compose.kvm.yml": "services:\n  vm:\n    devices:\n      - \"/dev/kvm:/dev/kvm\"\n",
		"ubuntu/24.04/ssh":                    "#!/bin/bash\nsshpass -p root ssh -o StrictHostKeyChecking=no -p 24040 root@127.0.0.1\n",
		"README.md":                           "# not an env\n",
	})
	ix, err := Generate(root)
	if err != nil {
		t.Fatal(err)
	}
	if len(ix.Envs) != 1 {
		t.Fatalf("envs = %d, want 1", len(ix.Envs))
	}
	e := ix.Envs[0]
	checks := []struct {
		name, got, want string
	}{
		{"Path", e.Path, "ubuntu/24.04"},
		{"Image", e.Image, "ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0"},
		{"EnvImage", e.EnvImage, "ubuntu-24.04"},
		{"SSHPort", e.SSHPort, "24040"},
		{"SSHUser", e.SSHUser, "root"},
		{"Project", e.Project, "ubuntu-24-04"},
	}
	for _, c := range checks {
		if c.got != c.want {
			t.Errorf("%s = %q, want %q", c.name, c.got, c.want)
		}
	}
	if !e.HasCompose || !e.HasKVM || len(e.Services) != 1 || e.Services[0] != "vm" {
		t.Errorf("flags wrong: %+v", e)
	}
	if e.ComposeHash == "" {
		t.Error("ComposeHash empty")
	}
}

func TestGenerateSkipsNonEnvDirs(t *testing.T) {
	root := writeTree(t, map[string]string{
		".git/config":                "x",
		".github/workflows/make.yml": "x",
		"script/ci_run.sh":           "x",
		"cli/go.mod":                 "x",
		"ssh_config/dqd":             "x",
	})
	ix, err := Generate(root)
	if err != nil {
		t.Fatal(err)
	}
	if len(ix.Envs) != 0 {
		t.Fatalf("envs = %d, want 0", len(ix.Envs))
	}
}

func TestGenerateClusterAndDeriveProject(t *testing.T) {
	root := writeTree(t, map[string]string{
		// aggregator: extends into master/worker
		"kubernetes/v1.34.0/cluster/.env":                      "COMPOSE_PROJECT_NAME=k8s-cluster\nSKIP_SSH_CONFIG=true\n",
		"kubernetes/v1.34.0/cluster/docker-compose.yml":        "services:\n  master:\n    extends:\n      file: master/docker-compose.yml\n      service: master\n  worker:\n    extends:\n      file: worker/docker-compose.yml\n      service: worker\n",
		"kubernetes/v1.34.0/cluster/master/.env":               "VERSION=v0.1.2\nIMAGE=kubernetes-v1.34.0-master\n",
		"kubernetes/v1.34.0/cluster/master/docker-compose.yml": "services:\n  master:\n    image: ghcr.io/ctrsploit/kubernetes-v1.34.0-master:v0.1.2\n    ports:\n        - \"13404:22\"\n        - \"13405:6443\"\n",
		"kubernetes/v1.34.0/cluster/worker/.env":               "VERSION=v0.1.2\nIMAGE=kubernetes-v1.34.0-worker\n",
		"kubernetes/v1.34.0/cluster/worker/docker-compose.yml": "services:\n  worker:\n    image: ghcr.io/ctrsploit/kubernetes-v1.34.0-worker:v0.1.2\n    ports:\n        - \"13406:22\"\n",
		// ctf-style ssh credentials
		"ctf/env/.env":               "VERSION=v0.1.0\nIMAGE=ctf-env\n",
		"ctf/env/docker-compose.yml": "services:\n  vm:\n    image: ghcr.io/ctrsploit/ctf-env:v0.1.0\n    ports:\n        - \"40001:22\"\n",
		"ctf/env/ssh":                "#!/bin/bash\nsshpass -p ctf ssh -o StrictHostKeyChecking=no -p 40001 ctf@127.0.0.1\n",
		// env without COMPOSE_PROJECT_NAME: project derived from basename
		"plain/dir/.env":               "VERSION=v1\nIMAGE=plain\n",
		"plain/dir/docker-compose.yml": "services:\n  vm:\n    image: ghcr.io/ctrsploit/plain:v1\n    ports:\n        - \"10001:22\"\n",
	})
	ix, err := Generate(root)
	if err != nil {
		t.Fatal(err)
	}
	byPath := map[string]Env{}
	for _, e := range ix.Envs {
		byPath[e.Path] = e
	}

	agg := byPath["kubernetes/v1.34.0/cluster"]
	if len(agg.Includes) != 2 {
		t.Fatalf("aggregator Includes = %v, want master+worker dirs", agg.Includes)
	}
	master := byPath["kubernetes/v1.34.0/cluster/master"]
	if master.Cluster != "kubernetes/v1.34.0/cluster" {
		t.Errorf("master.Cluster = %q", master.Cluster)
	}
	if got, ok := byPath["plain/dir"]; !ok || got.Project != "dir" {
		t.Errorf("derived project = %q (%v), want dir", got.Project, ok)
	}
	ctf := byPath["ctf/env"]
	if ctf.SSHUser != "ctf" || ctf.SSHPassword != "ctf" {
		t.Errorf("ctf creds = %q/%q", ctf.SSHUser, ctf.SSHPassword)
	}
}

func TestTarRoundTripAndExtract(t *testing.T) {
	root := writeTree(t, map[string]string{
		"ubuntu/24.04/.env":               standardEnv,
		"ubuntu/24.04/docker-compose.yml": standardCompose,
		"ssh_config/dqd":                  "PRIVATE KEY MATERIAL",
		"ssh_config/dqd.pub":              "public",
	})
	ix, err := Generate(root)
	if err != nil {
		t.Fatal(err)
	}
	var buf bytes.Buffer
	if err := WriteTreeJSON(&buf, ix, root); err != nil {
		t.Fatal(err)
	}
	// deterministic: same input -> same bytes
	var buf2 bytes.Buffer
	if err := WriteTreeJSON(&buf2, ix, root); err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(buf.Bytes(), buf2.Bytes()) {
		t.Error("WriteTreeJSON not deterministic")
	}

	tree, err := ReadTree(buf.Bytes())
	if err != nil {
		t.Fatal(err)
	}
	for _, name := range []string{
		"ubuntu/24.04/docker-compose.yml",
		"ubuntu/24.04/.env",
		KeysPrefix + "dqd",
		KeysPrefix + "dqd.pub",
	} {
		if _, ok := tree.Files[name]; !ok {
			t.Errorf("snapshot missing %s; have %v", name, tree.Files)
		}
	}

	dest := t.TempDir()
	if err := tree.Extract(dest, []string{"ubuntu/24.04"}, false); err != nil {
		t.Fatal(err)
	}
	data, err := os.ReadFile(filepath.Join(dest, "ubuntu/24.04/docker-compose.yml"))
	if err != nil || string(data) != standardCompose {
		t.Errorf("extracted compose mismatch: %v %q", err, data)
	}
	if _, err := os.Stat(filepath.Join(dest, KeysPrefix)); !os.IsNotExist(err) {
		t.Error("keys extracted despite withKeys=false")
	}

	// text format: the committed artifact stays diffable
	if !bytes.Contains(buf.Bytes(), []byte(`"ubuntu/24.04/docker-compose.yml"`)) {
		t.Error("snapshot is not a readable JSON object")
	}
}

func TestIndexJSONRoundTrip(t *testing.T) {
	ix := &Index{Commit: "abc", Envs: []Env{{Path: "a/b", Project: "ab", SSHUser: "root"}}}
	data, err := MarshalIndex(ix)
	if err != nil {
		t.Fatal(err)
	}
	back, err := ParseIndex(data)
	if err != nil {
		t.Fatal(err)
	}
	if back.Commit != "abc" || len(back.Envs) != 1 || back.Envs[0].Path != "a/b" {
		t.Errorf("round trip mismatch: %+v", back)
	}
	if data[0] != '{' {
		t.Error("not JSON object")
	}
}
