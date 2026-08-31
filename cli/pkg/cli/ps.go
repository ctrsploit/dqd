package cli

import (
	"fmt"
	"io"
	"text/tabwriter"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/pkg/docker"
)

// psCmd shows running environments. Unlike bin/dqd — which spawned
// one `docker compose ps` per environment — it queries the daemon
// once and joins containers to the catalog by compose project label.
func (a *App) psCmd() *cobra.Command {
	var all bool
	cmd := &cobra.Command{
		Use:   "ps [prefix]",
		Short: "Show running dqd environments",
		Args:  cobra.MaximumNArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			prefix := ""
			if len(args) == 1 {
				prefix = args[0]
			}
			containers, err := docker.PS(ctx(), all)
			if err != nil {
				return err
			}
			ix := a.Identity.Index
			if ix == nil {
				return fmt.Errorf("no embedded snapshot in this build (run `make cli`)")
			}

			anyMatched := false
			shown := map[string]bool{}
			for _, e := range ix.Envs {
				if prefix != "" && e.Path != prefix && !hasDirPrefix(e.Path, prefix) {
					continue
				}
				anyMatched = true
				envContainers := containersForProject(containers, e.Project)
				if len(envContainers) == 0 {
					continue
				}
				shown[e.Project] = true
				a.printEnvSection(e.Path, envContainers)
			}
			if !anyMatched {
				return fmt.Errorf("no matching environments for prefix %q", prefix)
			}
			if len(shown) == 0 {
				a.printf("No running dqd environments.\n")
			}
			return nil
		},
	}
	cmd.Flags().BoolVar(&all, "all", false, "include stopped containers")
	return cmd
}

func containersForProject(containers []docker.Container, project string) []docker.Container {
	var out []docker.Container
	for _, c := range containers {
		if c.Project == project {
			out = append(out, c)
		}
	}
	return out
}

func (a *App) printEnvSection(path string, containers []docker.Container) {
	a.printf("\n[%s]\n", path)
	var w io.Writer = a.Stdout
	tw := tabwriter.NewWriter(w, 0, 4, 2, ' ', 0)
	for _, c := range containers {
		fmt.Fprintf(tw, "%s\t%s\t%s\t%s\n", c.Name, c.Image, c.Status, c.Ports)
	}
	_ = tw.Flush()
}
