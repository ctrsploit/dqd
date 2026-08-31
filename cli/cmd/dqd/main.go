// Command dqd is the standalone dqd CLI: it lists, runs, connects to
// and tears down dqd environments without requiring a repository
// checkout (the config snapshot is embedded at build time).
package main

import (
	"os"

	"github.com/ctrsploit/dqd/cli/internal/embedded"
	"github.com/ctrsploit/dqd/cli/pkg/cli"
	"github.com/ctrsploit/dqd/cli/pkg/remote"
)

// version is set at build time via -ldflags "-X main.version=...".
var version = "dev"

// identity brands this binary as the public dqd CLI.
var identity = cli.Identity{
	Name:           "dqd",
	Short:          "Operate dqd (debugging with qemu in docker) environments",
	Long:           "dqd runs reproducible container runtime debugging environments.\n" +
		"Environments are identified by their repository path (e.g. ubuntu/24.04)\n" +
		"and execute their own docker-compose.yml verbatim.",
	RawBaseDefault:   remote.DefaultRawBase,
	StateDirName:     "dqd",
	RegistryFallback: "ghcr.io/ctrsploit",
	Index:            embedded.Index,
	Tree:             embedded.Tree,
}

func main() {
	cli.SetVersion(version)
	os.Exit(cli.Execute(identity))
}
