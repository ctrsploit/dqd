package cli

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/internal/compose"
	"github.com/ctrsploit/dqd/cli/internal/resolve"
)

// upCmd runs an environment through its own compose files, adding the
// kvm overlay under the same tri-state semantics as bin/dqd:
// absent flag = auto (KVM device + overlay present), --kvm=true
// enforces both, --kvm=false forces plain emulation.
func (a *App) upCmd() *cobra.Command {
	var kvm string
	cmd := &cobra.Command{
		Use:               "up <env>",
		Short:             "Start an environment (docker compose up -d)",
		Args:              cobra.ExactArgs(1),
		ValidArgsFunction: envCompletion,
		RunE: func(cmd *cobra.Command, args []string) error {
			if kvm != "" && kvm != "true" && kvm != "false" {
				return fmt.Errorf("use --kvm=true or --kvm=false")
			}
			res, err := a.Resolver.Resolve(args[0])
			if err != nil {
				return err
			}
			if !res.Env.HasCompose {
				return fmt.Errorf("missing compose file: %s/docker-compose.yml", args[0])
			}
			files, err := kvmFiles(kvm, res)
			if err != nil {
				return err
			}
			a.eprintf("# source: %s (%s)\n", args[0], res.Source)
			if err := compose.Up(ctx(), files); err != nil {
				return err
			}
			a.printf("started %s (project %s)\n", args[0], res.Env.Project)
			if res.Env.SSHPort != "" {
				a.printf("connect: dqd ssh %s  (port %s)\n", args[0], res.Env.SSHPort)
			}
			return nil
		},
	}
	cmd.Flags().StringVar(&kvm, "kvm", "", "true|false; default auto-detects /dev/kvm + kvm overlay")
	_ = cmd.RegisterFlagCompletionFunc("kvm", kvmFlagCompletion)
	return cmd
}

// downCmd stops an environment.
func (a *App) downCmd() *cobra.Command {
	return &cobra.Command{
		Use:               "down <env>",
		Short:             "Stop and remove an environment (docker compose down)",
		Args:              cobra.ExactArgs(1),
		ValidArgsFunction: envCompletion,
		RunE: func(cmd *cobra.Command, args []string) error {
			res, err := a.Resolver.Resolve(args[0])
			if err != nil {
				return err
			}
			if !res.Env.HasCompose {
				return fmt.Errorf("missing compose file: %s/docker-compose.yml", args[0])
			}
			// parity with bin/dqd: down uses the base compose file only
			return compose.Down(ctx(), compose.Files{Dir: res.Dir})
		},
	}
}

// kvmFiles computes the compose file set with the kvm overlay flag.
func kvmFiles(kvm string, res *resolve.Result) (compose.Files, error) {
	hasOverlay := compose.HasKVMOverlay(res.Dir)
	hasKvmDev := deviceExists("/dev/kvm")

	files := compose.Files{Dir: res.Dir}
	switch kvm {
	case "true":
		if !hasKvmDev {
			return files, fmt.Errorf("--kvm requested but /dev/kvm does not exist")
		}
		if !hasOverlay {
			return files, fmt.Errorf("missing kvm compose file: <env>/docker-compose.kvm.yml")
		}
		files.KVM = true
	case "false":
		// forced off
	default: // auto
		files.KVM = hasKvmDev && hasOverlay
	}
	return files, nil
}

func deviceExists(p string) bool {
	_, err := os.Stat(p)
	return err == nil
}
