// Package cli wires the dqd commands together.
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
	"github.com/ctrsploit/dqd/cli/internal/embedded"
	"github.com/ctrsploit/dqd/cli/pkg/prefs"
	"github.com/ctrsploit/dqd/cli/pkg/remote"
	"github.com/ctrsploit/dqd/cli/pkg/resolve"
)

// version is injected at build time (main sets it via SetVersion,
// sourced from -ldflags "-X main.version=...").
var version = "dev"

// SetVersion sets the CLI version string (called from main).
func SetVersion(v string) { version = v }

// App carries the shared state of one CLI invocation.
type App struct {
	Stdout   io.Writer
	Stderr   io.Writer
	Stdin    *os.File
	Resolver *resolve.Resolver
	Remote   remote.Config
	Prefs    prefs.Prefs
	Tree     *catalog.Tree
}

// NewApp assembles the app from the embedded snapshot, environment
// variables and persisted preferences.
func NewApp() (*App, error) {
	app := &App{
		Stdout: os.Stdout,
		Stderr: os.Stderr,
		Stdin:  os.Stdin,
		Remote: remote.ConfigFromEnv(),
		Prefs:  prefs.Load(),
		Tree:   embeddedTree(),
	}
	resolver, err := resolve.New(resolve.Options{
		Index:  embeddedIndex(),
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
func Execute() int {
	noUpdate := false
	root := &cobra.Command{
		Use:   "dqd",
		Short: "Operate dqd (debugging with qemu in docker) environments",
		Long: "dqd runs reproducible container runtime debugging environments.\n" +
			"Environments are identified by their repository path (e.g. ubuntu/24.04)\n" +
			"and execute their own docker-compose.yml verbatim.",
		SilenceUsage:  true,
		SilenceErrors: true,
	}
	root.PersistentFlags().BoolVar(&noUpdate, "no-update", false,
		"never contact the remote repository this run")

	app, err := NewApp()
	if err != nil {
		fmt.Fprintf(os.Stderr, "dqd: %v\n", err)
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
		app.psCmd(),
		app.downCmd(),
		app.updateCmd(),
		app.versionCmd(),
	} {
		root.AddCommand(sub)
	}

	if err := root.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "dqd: %v\n", err)
		return 1
	}
	return 0
}

// embeddedIndex and embeddedTree are indirections over the embedded
// package so tests can swap in fixtures.
var (
	embeddedIndexFn = func() *catalog.Index { return embedded.Index }
	embeddedTreeFn  = func() *catalog.Tree { return embedded.Tree }
)

func embeddedIndex() *catalog.Index { return embeddedIndexFn() }
func embeddedTree() *catalog.Tree   { return embeddedTreeFn() }
