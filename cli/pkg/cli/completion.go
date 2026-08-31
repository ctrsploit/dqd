package cli

import (
	"strings"

	"github.com/spf13/cobra"
)

// envCompletion completes <env> arguments from the embedded catalog
// (offline, instant). Wired into every command that takes an
// environment path; later positional arguments (e.g. the remote
// command of `dqd ssh <env> -- cmd`) disable file completion too.
func envCompletion(cmd *cobra.Command, args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
	if len(args) != 0 {
		return nil, cobra.ShellCompDirectiveNoFileComp
	}
	ix := embeddedIndex()
	if ix == nil {
		return nil, cobra.ShellCompDirectiveNoFileComp
	}
	var candidates []string
	for _, e := range ix.Envs {
		if strings.HasPrefix(e.Path, toComplete) {
			candidates = append(candidates, e.Path)
		}
	}
	return candidates, cobra.ShellCompDirectiveNoFileComp
}

// kvmFlagCompletion completes the --kvm flag values.
func kvmFlagCompletion(cmd *cobra.Command, args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
	return []string{"true", "false"}, cobra.ShellCompDirectiveNoFileComp
}
