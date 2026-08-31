package cli

import (
	"fmt"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/internal/catalog"
	"github.com/ctrsploit/dqd/cli/internal/remote"
)

// listCmd lists environments. Default is a per-component summary
// (463 entries as a full dump is too dense to scan); a prefix
// argument or --all expands to the full grouped path list.
func (a *App) listCmd() *cobra.Command {
	var useRemote, all bool
	cmd := &cobra.Command{
		Use:               "list [prefix]",
		Short:             "List environments: component summary by default, full paths with a prefix or --all",
		Args:              cobra.MaximumNArgs(1),
		ValidArgsFunction: envCompletion,
		RunE: func(cmd *cobra.Command, args []string) error {
			prefix := ""
			if len(args) == 1 {
				prefix = args[0]
			}
			ix := embeddedIndex()
			if useRemote {
				var err error
				ix, err = remote.FetchIndex(a.Remote)
				if err != nil {
					return fmt.Errorf("--remote: %w", err)
				}
			}
			if ix == nil {
				return fmt.Errorf("no embedded snapshot in this build (run `make cli`)")
			}
			if prefix == "" && !all {
				printSummary(a, ix)
				return nil
			}
			printEnvs(a, ix, prefix)
			return nil
		},
	}
	cmd.Flags().BoolVar(&useRemote, "remote", false, "list from the remote repository catalog instead of the embedded snapshot")
	cmd.Flags().BoolVar(&all, "all", false, "print every environment instead of the component summary")
	return cmd
}

// printSummary renders the per-component overview shown by default.
func printSummary(a *App, ix *catalog.Index) {
	counts := map[string]int{}
	var order []string
	for _, e := range ix.Envs {
		g := topSegment(e.Path)
		if _, ok := counts[g]; !ok {
			order = append(order, g)
		}
		counts[g]++
	}
	a.printf("%-24s %5s\n", "COMPONENT", "ENVS")
	for _, g := range order {
		a.printf("%-24s %5d\n", g, counts[g])
	}
	a.printf("\n%d environments in %d components\n", len(ix.Envs), len(order))
	a.printf("expand: dqd list <component>   dump all: dqd list --all\n")
}

// printEnvs renders the grouped path list.
func printEnvs(a *App, ix *catalog.Index, prefix string) {
	currentGroup := ""
	for _, e := range ix.Envs {
		if prefix != "" && e.Path != prefix && !hasDirPrefix(e.Path, prefix) {
			continue
		}
		group := topSegment(e.Path)
		if group != currentGroup {
			a.printf("\n[%s]\n", group)
			currentGroup = group
		}
		// build-only entries (no compose file, e.g. k8s base images)
		// cannot be `up`ped — mark them so runnable envs stand out
		suffix := ""
		if !e.HasCompose {
			suffix = " (build-only)"
		}
		a.printf("%s%s\n", e.Path, suffix)
	}
}

func topSegment(p string) string {
	for i := 0; i < len(p); i++ {
		if p[i] == '/' {
			return p[:i]
		}
	}
	return p
}

// hasDirPrefix reports whether p equals prefix or lies under it
// (the bash CLI's case "$env_dir" in "$prefix"|"$prefix"/* filter).
func hasDirPrefix(p, prefix string) bool {
	return len(p) > len(prefix)+1 && p[:len(prefix)] == prefix && p[len(prefix)] == '/'
}
