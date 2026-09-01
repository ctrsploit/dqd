// Package cli wires the environment engine commands together. The
// engine is brand-agnostic: the assembling binary supplies an Identity
// (name, remote default, state dirs, registry fallback and the embedded
// config snapshot) so downstream CLIs can reuse the command tree.
package cli

import (
	"context"
	"fmt"
	"io"
	"os"
	"os/signal"
	"syscall"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/pkg/catalog"
	"github.com/ctrsploit/dqd/cli/pkg/dqdpaths"
	"github.com/ctrsploit/dqd/cli/pkg/prefs"
	"github.com/ctrsploit/dqd/cli/pkg/remote"
	"github.com/ctrsploit/dqd/cli/pkg/resolve"
)

// version is injected at build time (main sets it via SetVersion,
// sourced from -ldflags "-X main.version=...").
var version = "dev"

// SetVersion sets the CLI version string (called from main).
func SetVersion(v string) { version = v }

// Identity brands one build of the engine. The dqd binary fills it with
// dqd's defaults; downstream CLIs (e.g. a private dqd-pro) supply their
// own name, remote source, state directories and embedded snapshot.
type Identity struct {
	Name             string         // binary name in help/error prefixes, e.g. "dqd"
	Short            string         // cobra Short description
	Long             string         // cobra Long description
	RawBaseDefault   string         // DQD_RAW_BASE fallback (remote source)
	StateDirName     string         // ~/.cache and ~/.config subdirectory
	RegistryFallback string         // image prefix used when compose is absent
	Index            *catalog.Index // embedded catalog snapshot (content)
	Tree             *catalog.Tree  // embedded config snapshot (content)
}

// App carries the shared state of one CLI invocation.
type App struct {
	Identity Identity
	Stdout   io.Writer
	Stderr   io.Writer
	Stdin    *os.File
	Resolver *resolve.Resolver
	Remote   remote.Config
	Prefs    prefs.Prefs
	Tree     *catalog.Tree
}

// NewApp assembles the app from the identity's embedded snapshot,
// environment variables and persisted preferences.
func NewApp(id Identity) (*App, error) {
	dqdpaths.StateDirName = id.StateDirName
	app := &App{
		Identity: id,
		Stdout:   os.Stdout,
		Stderr:   os.Stderr,
		Stdin:    os.Stdin,
		Remote:   remote.ConfigFromEnv(id.RawBaseDefault),
		Prefs:    prefs.Load(),
		Tree:     id.Tree,
	}
	resolver, err := resolve.New(resolve.Options{
		Index:  id.Index,
		Tree:   app.Tree,
		Remote: &updateDecider{app: app},
	})
	if err != nil {
		return nil, err
	}
	app.Resolver = resolver
	return app, nil
}

// ctx returns a context canceled on SIGINT/SIGTERM.
func ctx() context.Context {
	c, _ := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	return c
}

func (a *App) printf(format string, args ...any) {
	fmt.Fprintf(a.Stdout, format, args...)
}

func (a *App) eprintf(format string, args ...any) {
	fmt.Fprintf(a.Stderr, format, args...)
}

// Execute runs the CLI; it returns the process exit code.
func Execute(id Identity) int {
	noUpdate := false
	root := &cobra.Command{
		Use:           id.Name,
		Short:         id.Short,
		Long:          id.Long,
		SilenceUsage:  true,
		SilenceErrors: true,
	}
	root.PersistentFlags().BoolVar(&noUpdate, "no-update", false,
		"never contact the remote repository this run")

	app, err := NewApp(id)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s: %v\n", id.Name, err)
		return 1
	}
	// flags are only parsed during Execute; apply --no-update from a
	// PersistentPreRun hook so every subcommand sees it in time
	root.PersistentPreRunE = func(cmd *cobra.Command, args []string) error {
		if noUpdate {
			app.Prefs.Update = prefs.UpdateOff
		}
		return nil
	}

	// Show commands in lifecycle order (discover → inspect → run →
	// connect → observe → destroy), not cobra's alphabetical default:
	// the help output doubles as onboarding documentation.
	cobra.EnableCommandSorting = false
	for _, sub := range []*cobra.Command{
		app.listCmd(),
		app.infoCmd(),
		app.upCmd(),
		app.readyCmd(),
		app.sshCmd(),
		app.scpCmd(),
		app.psCmd(),
		app.downCmd(),
		app.updateCmd(),
		app.versionCmd(),
	} {
		root.AddCommand(sub)
	}

	if err := root.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "%s: %v\n", id.Name, err)
		return 1
	}
	return 0
}
