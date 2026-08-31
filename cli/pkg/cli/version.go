package cli

import (
	"fmt"
	"runtime/debug"

	"github.com/spf13/cobra"
)

func (a *App) versionCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Print the CLI version and embedded snapshot info",
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			v := version
			if v == "dev" {
				// `go install` builds carry the module version here
				if info, ok := debug.ReadBuildInfo(); ok && info.Main.Version != "" && info.Main.Version != "(devel)" {
					v = info.Main.Version
				}
			}
			a.printf("dqd %s\n", v)
			if ix := embeddedIndex(); ix != nil {
				snapshot := "none (placeholder build; run `make cli` for a self-contained binary)"
				if len(ix.Envs) > 0 {
					snapshot = fmt.Sprintf("%d environments, commit %s", len(ix.Envs), shortCommit(ix.Commit))
				}
				a.printf("embedded snapshot: %s\n", snapshot)
			}
		},
	}
}
