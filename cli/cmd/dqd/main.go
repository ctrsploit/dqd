// Command dqd is the standalone dqd CLI: it lists, runs, connects to
// and tears down dqd environments without requiring a repository
// checkout (the config snapshot is embedded at build time).
package main

import (
	"os"

	"github.com/ctrsploit/dqd/cli/internal/cli"
)

// version is set at build time via -ldflags "-X main.version=...".
var version = "dev"

func main() {
	cli.SetVersion(version)
	os.Exit(cli.Execute())
}
