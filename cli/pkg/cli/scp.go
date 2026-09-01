package cli

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/pkg/catalog"
	"github.com/ctrsploit/dqd/cli/pkg/docker"
	"github.com/ctrsploit/dqd/cli/pkg/sshclient"
)

// scpSide reports which of the two paths refers to the environment.
// Remote paths carry a leading ':' (docker-cp style); exactly one side
// must be remote, otherwise the copy direction is ambiguous.
func scpSide(binName, src, dst string) (srcRemote, dstRemote bool, err error) {
	srcRemote = strings.HasPrefix(src, ":")
	dstRemote = strings.HasPrefix(dst, ":")
	if srcRemote == dstRemote {
		return false, false, fmt.Errorf("exactly one of <src> <dst> must be a remote path with a ':' prefix (e.g. %s scp <env> ./file :/root/file)", binName)
	}
	return srcRemote, dstRemote, nil
}

// scpCmd copies files between the host and a running environment over
// the same native SSH connection `ssh` uses (SFTP subsystem).
func (a *App) scpCmd() *cobra.Command {
	var recursive bool
	cmd := &cobra.Command{
		Use:   "scp <env> <src> <dst>",
		Short: "Copy files to/from a running environment (remote path starts with ':')",
		Long: "Copy files between the host and a running environment over the same\n" +
			"native SSH connection `ssh` uses. Mark the environment side with a\n" +
			"leading ':' — exactly one of <src> <dst> is remote:\n" +
			"\n" +
			"  dqd scp ubuntu/24.04 ./file.txt :/root/file.txt      (upload)\n" +
			"  dqd scp ubuntu/24.04 :/root/file.txt ./file.txt      (download)\n" +
			"  dqd scp -r ubuntu/24.04 ./dir :/root/dir             (directories)\n" +
			"\n" +
			"A relative remote path (no slash, e.g. :file) resolves against the\n" +
			"login user's home directory on the VM. Modes are preserved.",
		Args:              cobra.ExactArgs(3),
		ValidArgsFunction: a.envCompletion,
		RunE: func(cmd *cobra.Command, args []string) error {
			_, dstRemote, err := scpSide(a.Identity.Name, args[1], args[2])
			if err != nil {
				return err
			}
			res, err := a.Resolver.Resolve(args[0])
			if err != nil {
				return err
			}
			e := res.Env

			port, err := a.liveSSHPort(args[0], e)
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
				return fmt.Errorf("%w (user %s, port %s; try `%s ready %s` if the VM is still booting)",
					err, e.SSHUser, port, a.Identity.Name, args[0])
			}
			defer client.Close()

			sftpClient, err := sshclient.SFTP(client)
			if err != nil {
				return fmt.Errorf("sftp subsystem unavailable on %s: %w", args[0], err)
			}
			defer sftpClient.Close()

			if dstRemote {
				return sshclient.Upload(sftpClient, args[1], sshclient.TrimRemotePrefix(args[2]), recursive)
			}
			return sshclient.Download(sftpClient, sshclient.TrimRemotePrefix(args[1]), args[2], recursive)
		},
	}
	cmd.Flags().BoolVarP(&recursive, "recursive", "r", false, "copy directories recursively")
	return cmd
}

// liveSSHPort finds the published SSH port of a running environment,
// with the same "not running" guidance the ssh command prints.
func (a *App) liveSSHPort(envArg string, e *catalog.Env) (string, error) {
	byProject, err := docker.RunningByProject(ctx())
	if err != nil {
		return "", err
	}
	containers := byProject[e.Project]
	pick := docker.PickServiceContainer(containers)
	if pick == nil {
		return "", fmt.Errorf("%s is not running (project %q); start it with `%s up %s`",
			envArg, e.Project, a.Identity.Name, envArg)
	}
	return docker.HostPort(ctx(), pick.Name, "22")
}
