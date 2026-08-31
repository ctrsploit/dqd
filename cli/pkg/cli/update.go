package cli

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/pkg/catalog"
	"github.com/ctrsploit/dqd/cli/pkg/dqdpaths"
	"github.com/ctrsploit/dqd/cli/pkg/remote"
)

// updateCmd refreshes the remote-side knowledge: it fetches the
// remote catalog, reports the diff against the embedded snapshot and
// (without --check) re-fetches configs of environments already using
// the remote channel.
func (a *App) updateCmd() *cobra.Command {
	var checkOnly bool
	cmd := &cobra.Command{
		Use:   "update",
		Short: "Fetch the remote catalog and refresh remote-cached environments",
		Args:  cobra.NoArgs,
		RunE: func(cmd *cobra.Command, args []string) error {
			rix, err := remote.FetchIndex(a.Remote)
			if err != nil {
				return err
			}
			local := embeddedIndex()
			if local == nil {
				local = &catalog.Index{}
			}
			diff := remote.Of(local, rix)
			a.printf("remote %s vs embedded %s: %d changed, %d added, %d removed\n",
				shortCommit(rix.Commit), shortCommit(local.Commit),
				len(diff.Changed), len(diff.Added), len(diff.Removed))
			for _, group := range []struct {
				label string
				paths []string
			}{
				{"changed", diff.Changed},
				{"added", diff.Added},
				{"removed", diff.Removed},
			} {
				for i, p := range group.paths {
					if i == 10 {
						a.printf("  ... and %d more %s\n", len(group.paths)-i, group.label)
						break
					}
					a.printf("  %s: %s\n", group.label, p)
				}
			}

			if checkOnly {
				if !diff.IsEmpty() {
					return fmt.Errorf("remote differs from the embedded snapshot")
				}
				return nil
			}

			// persist the fetched catalog for later runs / inspection
			if cacheDir, err := dqdpaths.CacheDir(); err == nil {
				if data, err := catalog.MarshalIndex(rix); err == nil {
					_ = os.MkdirAll(cacheDir, 0o755)
					_ = os.WriteFile(filepath.Join(cacheDir, "catalog-remote.json"), data, 0o644)
				}
			}

			// re-fetch environments whose configs already come from remote
			remoteRoot, err := dqdpaths.RemoteCacheDir()
			if err != nil {
				return err
			}
			refreshed := 0
			for _, e := range rix.Envs {
				dir := filepath.Join(remoteRoot, filepath.FromSlash(e.Path))
				if _, err := os.Stat(filepath.Join(dir, "docker-compose.yml")); err != nil {
					continue
				}
				if err := remote.FetchEnv(a.Remote, &e, remoteRoot); err != nil {
					a.eprintf("dqd: refresh %s failed: %v\n", e.Path, err)
					continue
				}
				refreshed++
			}
			a.printf("refreshed %d remote-cached environment(s)\n", refreshed)
			return nil
		},
	}
	cmd.Flags().BoolVar(&checkOnly, "check", false, "only report the diff; exit 1 when it is non-empty")
	return cmd
}
