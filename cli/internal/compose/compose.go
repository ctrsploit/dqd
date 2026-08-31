// Package compose runs environments through the docker compose CLI.
//
// Faithfulness rule: the CLI never reconstructs what a compose file
// says — it always executes the environment's own docker-compose.yml
// (plus the kvm overlay when applicable) verbatim. All mutations to
// the daemon go through here.
package compose

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const (
	composeName = "docker-compose.yml"
	kvmName     = "docker-compose.kvm.yml"
)

// Files describes the compose files of a resolved environment dir.
type Files struct {
	Dir string // directory containing the compose files
	KVM bool   // include the docker-compose.kvm.yml overlay
}

// Args builds the docker compose argument prefix for these files.
func (f Files) Args() []string {
	args := []string{"compose", "-f", filepath.Join(f.Dir, composeName)}
	if f.KVM {
		args = append(args, "-f", filepath.Join(f.Dir, kvmName))
	}
	return args
}

// HasKVMOverlay reports whether the dir ships a kvm overlay file.
func HasKVMOverlay(dir string) bool {
	_, err := os.Stat(filepath.Join(dir, kvmName))
	return err == nil
}

// Up runs `docker compose up -d`, streaming output to stdout/stderr.
func Up(ctx context.Context, f Files) error {
	return run(ctx, f, "up", "-d")
}

// Down runs `docker compose down`.
func Down(ctx context.Context, f Files) error {
	return run(ctx, f, "down")
}

// Logs runs `docker compose logs` with the extra args (e.g. -f).
func Logs(ctx context.Context, f Files, extra ...string) error {
	return run(ctx, f, append([]string{"logs"}, extra...)...)
}

func run(ctx context.Context, f Files, args ...string) error {
	full := append(f.Args(), args...)
	cmd := exec.CommandContext(ctx, "docker", full...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("docker %s: %w", strings.Join(full, " "), err)
	}
	return nil
}
