package cli

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/internal/docker"
	"github.com/ctrsploit/dqd/cli/internal/sshclient"
)

// sshCmd connects to a running environment via its actual published
// port. Extra arguments become a remote command (non-interactive).
func (a *App) sshCmd() *cobra.Command {
	return &cobra.Command{
		Use:               "ssh <env> [command...]",
		Short:             "SSH into a running environment (or run a remote command)",
		Args:              cobra.MinimumNArgs(1),
		ValidArgsFunction: envCompletion,
		RunE: func(cmd *cobra.Command, args []string) error {
			res, err := a.Resolver.Resolve(args[0])
			if err != nil {
				return err
			}
			e := res.Env

			byProject, err := docker.RunningByProject(ctx())
			if err != nil {
				return err
			}
			containers := byProject[e.Project]
			pick := docker.PickServiceContainer(containers)
			if pick == nil {
				return fmt.Errorf("%s is not running (project %q); start it with `dqd up %s`",
					args[0], e.Project, args[0])
			}
			port, err := docker.HostPort(ctx(), pick.Name, "22")
			if err != nil {
				return err
			}

			cfg := sshclient.Config{
				Port:     port,
				User:     e.SSHUser,
				Password: e.SSHPassword,
				KeyPEM:   a.KeyPEM(),
			}
			client, err := sshclient.Dial(cfg)
			if err != nil {
				return fmt.Errorf("%w (user %s, port %s; try `dqd ready %s` if the VM is still booting)",
					err, e.SSHUser, port, args[0])
			}
			defer client.Close()

			if len(args) > 1 {
				return sshclient.Run(client, strings.Join(args[1:], " "), a.Stdout, a.Stderr)
			}
			return sshclient.Shell(cfg, client)
		},
	}
}

// readyCmd waits for an environment's SSH endpoint to answer,
// mirroring ci_nested_lib.sh's wait_for_ssh cadence (3s interval,
// 300s default timeout).
func (a *App) readyCmd() *cobra.Command {
	var timeout, interval time.Duration
	cmd := &cobra.Command{
		Use:               "ready <env>",
		Short:             "Wait until an environment's SSH endpoint answers",
		Args:              cobra.ExactArgs(1),
		ValidArgsFunction: envCompletion,
		RunE: func(cmd *cobra.Command, args []string) error {
			res, err := a.Resolver.Resolve(args[0])
			if err != nil {
				return err
			}
			e := res.Env

			// prefer the live port binding; fall back to the catalog port
			port := e.SSHPort
			if byProject, err := docker.RunningByProject(ctx()); err == nil {
				if pick := docker.PickServiceContainer(byProject[e.Project]); pick != nil {
					if live, err := docker.HostPort(ctx(), pick.Name, "22"); err == nil {
						port = live
					}
				}
			}
			if port == "" {
				return fmt.Errorf("no SSH port known for %s", args[0])
			}
			cfg := sshclient.Config{
				Port:     port,
				User:     e.SSHUser,
				Password: e.SSHPassword,
				KeyPEM:   a.KeyPEM(),
			}

			a.eprintf("# waiting for SSH on 127.0.0.1:%s (timeout %s)\n", port, timeout)
			err = waitReady(ctx(), cfg, timeout, interval, func(elapsed int) {
				a.eprintf("# still waiting (%ds)...\n", elapsed)
			})
			if err != nil {
				return err
			}
			a.printf("%s is ready on 127.0.0.1:%s\n", args[0], port)
			return nil
		},
	}
	cmd.Flags().DurationVar(&timeout, "timeout", 300*time.Second, "give up after this duration (e.g. 120s, 5m)")
	cmd.Flags().DurationVar(&interval, "interval", 3*time.Second, "probe interval")
	return cmd
}

// waitReady probes SSH until it answers or the deadline passes.
func waitReady(c context.Context, cfg sshclient.Config, timeout, interval time.Duration, progress func(elapsedSec int)) error {
	deadline := time.Now().Add(timeout)
	start := time.Now()
	for {
		err := sshclient.Probe(cfg)
		if err == nil {
			return nil
		}
		if time.Now().After(deadline) {
			return fmt.Errorf("SSH on %s not ready within %s: %w", cfg.Endpoint(), timeout, err)
		}
		if c.Err() != nil {
			return c.Err()
		}
		progress(int(time.Since(start).Seconds()))
		select {
		case <-c.Done():
			return c.Err()
		case <-time.After(interval):
		}
	}
}
