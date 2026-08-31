package cli

import (
	"fmt"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/pkg/docker"
)

// infoCmd shows an environment's catalog entry plus live status.
func (a *App) infoCmd() *cobra.Command {
	return &cobra.Command{
		Use:               "info <env>",
		Short:             "Show image, project, ports and live status of an environment",
		Args:              cobra.ExactArgs(1),
		ValidArgsFunction: envCompletion,
		RunE: func(cmd *cobra.Command, args []string) error {
			res, err := a.Resolver.Resolve(args[0])
			if err != nil {
				return err
			}
			e := res.Env

			image := e.Image
			if image == "" && e.EnvImage != "" && e.EnvVersion != "" {
				image = fmt.Sprintf("ghcr.io/ctrsploit/%s:%s", e.EnvImage, e.EnvVersion)
			}
			if image == "" {
				image = "-"
			}
			a.printf("env: %s\n", e.Path)
			a.printf("source: %s\n", res.Source)
			a.printf("image: %s\n", e.EnvImage)
			if e.EnvImage != "" {
				a.printf("ssh alias: dqd-%s\n", e.EnvImage)
			}
			a.printf("version: %s\n", dash(e.EnvVersion))
			a.printf("project: %s\n", e.Project)
			a.printf("dqd image: %s\n", image)
			a.printf("ssh port: %s\n", dash(e.SSHPort))
			if len(e.Services) > 1 {
				a.printf("services: %v\n", e.Services)
			}
			if e.Cluster != "" {
				a.printf("cluster: %s\n", e.Cluster)
			}
			a.printf("kvm overlay: %v\n", e.HasKVM)

			// live status from the daemon
			byProject, err := docker.RunningByProject(ctx())
			if err == nil {
				if containers := byProject[e.Project]; len(containers) > 0 {
					pick := docker.PickServiceContainer(containers)
					status := pick.Status
					if port, err := docker.HostPort(ctx(), pick.Name, "22"); err == nil {
						status += fmt.Sprintf(" (ssh on 127.0.0.1:%s)", port)
					}
					a.printf("status: running, %s\n", status)
					return nil
				}
			}
			a.printf("status: not running\n")
			return nil
		},
	}
}

func dash(s string) string {
	if s == "" {
		return "-"
	}
	return s
}
