package cli

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"

	"github.com/ctrsploit/dqd/cli/pkg/catalog"
	"github.com/ctrsploit/dqd/cli/pkg/docker"
	"github.com/ctrsploit/dqd/cli/pkg/sshclient"
)

// splitRemote splits a scp-style <env>:<path> token. ok is true when
// token carries an environment spec (contains a ':'), matching scp's
// host:path convention — the environment id is everything before the
// first ':' and the remote path is everything after it. A token without
// a ':' is a local path.
func splitRemote(token string) (env, remotePath string, ok bool) {
	i := strings.IndexByte(token, ':')
	if i < 0 {
		return "", "", false
	}
	return token[:i], token[i+1:], true
}

// scpCmd copies files between the host and a running environment over
// the same native SSH connection `ssh` uses (SFTP subsystem). The
// interface mirrors scp: exactly one of <src> <dst> is written as
// <env>:<path>.
func (a *App) scpCmd() *cobra.Command {
	var recursive bool
	cmd := &cobra.Command{
		Use:   "scp <src> <dst>",
		Short: "Copy files to/from a running environment (remote side written as <env>:<path>)",
		Long: "Copy files between the host and a running environment over the same\n" +
			"native SSH connection `ssh` uses. Mark the environment side as\n" +
			"<env>:<path> — exactly one of <src> <dst> is remote, matching scp:\n" +
			"\n" +
			"  dqd scp ./file.txt ubuntu/24.04:/root/file.txt      (upload)\n" +
			"  dqd scp ubuntu/24.04:/root/file.txt ./file.txt      (download)\n" +
			"  dqd scp -r ./dir ubuntu/24.04:/root/dir             (directories)\n" +
			"\n" +
			"A relative remote path (no slash, e.g. ubuntu/24.04:file) resolves\n" +
			"against the login user's home directory on the VM. An empty remote\n" +
			"path (ubuntu/24.04:) is the home directory. Modes are preserved.",
		Args: cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			srcEnv, srcPath, srcRemote := splitRemote(args[0])
			dstEnv, dstPath, dstRemote := splitRemote(args[1])
			if srcRemote == dstRemote {
				return fmt.Errorf("exactly one of <src> <dst> must be remote, written as <env>:<path> (e.g. %s scp ./file ubuntu/24.04:/root/file)", a.Identity.Name)
			}

			var envArg, remotePath, localPath string
			var upload bool
			if dstRemote {
				envArg, remotePath, localPath, upload = dstEnv, dstPath, args[0], true
			} else {
				envArg, remotePath, localPath, upload = srcEnv, srcPath, args[1], false
			}
			if remotePath == "" {
				remotePath = "." // <env>: with no path → home directory
			}

			res, err := a.Resolver.Resolve(envArg)
			if err != nil {
				return err
			}
			e := res.Env

			port, err := a.liveSSHPort(envArg, e)
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
					err, e.SSHUser, port, a.Identity.Name, envArg)
			}
			defer client.Close()

			sftpClient, err := sshclient.SFTP(client)
			if err != nil {
				return fmt.Errorf("sftp subsystem unavailable on %s: %w", envArg, err)
			}
			defer sftpClient.Close()

			if upload {
				return sshclient.Upload(sftpClient, localPath, remotePath, recursive)
			}
			return sshclient.Download(sftpClient, remotePath, localPath, recursive)
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
