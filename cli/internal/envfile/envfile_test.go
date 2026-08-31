package envfile

import "testing"

func TestParseEnv(t *testing.T) {
	data := []byte(`VERSION=v0.4.0
IMAGE=ubuntu-24.04
COMPOSE_PROJECT_NAME=ubuntu-24-04

# comment line
SIZE=10G
BUILD_EXTRA_ARGS="--no-cache --add-host mirror:10.0.2.16"
SKIP_SSH_CONFIG=true
EMPTY=
`)
	e, err := ParseEnv(data)
	if err != nil {
		t.Fatal(err)
	}
	for key, want := range map[string]string{
		"VERSION":              "v0.4.0",
		"IMAGE":                "ubuntu-24.04",
		"COMPOSE_PROJECT_NAME": "ubuntu-24-04",
		"SIZE":                 "10G",
		"BUILD_EXTRA_ARGS":     "--no-cache --add-host mirror:10.0.2.16",
		"SKIP_SSH_CONFIG":      "true",
		"EMPTY":                "",
		"MISSING":              "",
	} {
		if got := e.Get(key); got != want {
			t.Errorf("Get(%q) = %q, want %q", key, got, want)
		}
	}
	if !e.Bool("SKIP_SSH_CONFIG") {
		t.Error("Bool(SKIP_SSH_CONFIG) = false, want true")
	}
	if e.Bool("VERSION") {
		t.Error("Bool(VERSION) = true, want false")
	}
}

func TestParseEnvRejectsGarbage(t *testing.T) {
	if _, err := ParseEnv([]byte("NOT-KEY-VALUE\n")); err == nil {
		t.Fatal("expected error for line without =")
	}
}

func TestParseComposeStandardEnv(t *testing.T) {
	data := []byte(`services:
  vm:
    image: ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0
    ports:
        - "24040:22"
    tty: true
    stdin_open: true
`)
	c, err := ParseCompose(data)
	if err != nil {
		t.Fatal(err)
	}
	if got := c.Names(); len(got) != 1 || got[0] != "vm" {
		t.Fatalf("Names() = %v, want [vm]", got)
	}
	vm := c.Services["vm"]
	if vm.Image != "ghcr.io/ctrsploit/ubuntu-24.04:v0.4.0" {
		t.Errorf("Image = %q", vm.Image)
	}
	if got := vm.HostPortOf("22"); got != "24040" {
		t.Errorf("HostPortOf(22) = %q, want 24040", got)
	}
	if got := vm.HostPortOf("6443"); got != "" {
		t.Errorf("HostPortOf(6443) = %q, want empty", got)
	}
}

func TestParseComposeMultiPortAndEnv(t *testing.T) {
	data := []byte(`services:
  vm:
    image: ghcr.io/ctrsploit/docker-v19.03.13-debug:v0.1.0
    environment:
      - "QEMU_HOSTFWD=hostfwd=tcp::19312-:22,hostfwd=tcp::19313-:2343"
      - "QEMU_NET=10.0.2.0/24"
    command: /start.sh -cpu host
    ports:
        - "19312:22"
        - "19313:2343"
        - "19314:2347/udp"
`)
	c, err := ParseCompose(data)
	if err != nil {
		t.Fatal(err)
	}
	vm := c.Services["vm"]
	if got := vm.HostPortOf("22"); got != "19312" {
		t.Errorf("HostPortOf(22) = %q, want 19312", got)
	}
	if got := vm.HostPortOf("2343"); got != "19313" {
		t.Errorf("HostPortOf(2343) = %q, want 19313", got)
	}
	if got := vm.HostPortOf("2347"); got != "19314" {
		t.Errorf("HostPortOf(2347) = %q, want 19314 (proto suffix tolerated)", got)
	}
	if len(vm.Environment) != 2 || vm.Environment[0] != "QEMU_HOSTFWD=hostfwd=tcp::19312-:22,hostfwd=tcp::19313-:2343" {
		t.Errorf("Environment = %v", vm.Environment)
	}
	if vm.Command != "/start.sh -cpu host" {
		t.Errorf("Command = %q", vm.Command)
	}
}

func TestParseComposeClusterAggregator(t *testing.T) {
	data := []byte(`services:
  master:
    extends:
      file: master/docker-compose.yml
      service: master
    healthcheck:
      test: ["CMD", "pgrep", "qemu-system-x86_64"]
      interval: 5s
  worker:
    extends:
      file: worker/docker-compose.yml
      service: worker
    depends_on:
      master:
        condition: service_healthy
`)
	c, err := ParseCompose(data)
	if err != nil {
		t.Fatal(err)
	}
	if got := c.Names(); len(got) != 2 || got[0] != "master" || got[1] != "worker" {
		t.Fatalf("Names() = %v, want [master worker]", got)
	}
	m := c.Services["master"]
	if len(m.ExtendsFiles) != 1 || m.ExtendsFiles[0] != "master/docker-compose.yml" {
		t.Errorf("ExtendsFiles = %v", m.ExtendsFiles)
	}
	if !m.HasHealthcheck {
		t.Error("master HasHealthcheck = false, want true")
	}
	if c.Services["worker"].HasHealthcheck {
		t.Error("worker HasHealthcheck = true, want false")
	}
}

func TestParseComposeEnvironmentMapForm(t *testing.T) {
	data := []byte(`services:
  vm:
    image: i:latest
    environment:
      QEMU_NET: 10.0.2.0/24
      QEMU_DHCPSTART: 10.0.2.16
`)
	c, err := ParseCompose(data)
	if err != nil {
		t.Fatal(err)
	}
	env := c.Services["vm"].Environment
	if len(env) != 2 || env[0] != "QEMU_DHCPSTART=10.0.2.16" || env[1] != "QEMU_NET=10.0.2.0/24" {
		t.Errorf("Environment = %v, want sorted KEY=VALUE entries", env)
	}
}
