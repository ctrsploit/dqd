// Package sshclient connects to dqd environments over SSH without
// external tools: no sshpass, no system ssh requirement.
//
// Auth order mirrors the repository's own conventions: the dqd key
// (ssh_config/dqd, baked into the binary) first — it is authorized in
// every VM image — then the per-environment password from the catalog
// (root/root for most environments, ctf/ctf for the CTF ones).
package sshclient

import (
	"fmt"
	"io"
	"net"
	"os"
	"time"

	"golang.org/x/crypto/ssh"
)

// Config for one connection.
type Config struct {
	Host     string // default 127.0.0.1
	Port     string
	User     string
	Password string
	KeyPEM   []byte // optional private key (dqd key materialized by the caller)
}

// Endpoint renders host:port.
func (c Config) Endpoint() string {
	host := c.Host
	if host == "" {
		host = "127.0.0.1"
	}
	return net.JoinHostPort(host, c.Port)
}

func (c Config) authMethods() []ssh.AuthMethod {
	var methods []ssh.AuthMethod
	if len(c.KeyPEM) > 0 {
		if signer, err := ssh.ParsePrivateKey(c.KeyPEM); err == nil {
			methods = append(methods, ssh.PublicKeys(signer))
		}
	}
	if c.Password != "" {
		methods = append(methods, ssh.Password(c.Password))
		// some images only expose PAM-backed keyboard-interactive
		methods = append(methods, ssh.KeyboardInteractive(
			func(name, instruction string, questions []string, echos []bool) ([]string, error) {
				answers := make([]string, len(questions))
				for i := range answers {
					answers[i] = c.Password
				}
				return answers, nil
			}))
	}
	return methods
}

// Dial establishes an SSH connection, trying each auth method.
func Dial(cfg Config) (*ssh.Client, error) {
	clientConfig := &ssh.ClientConfig{
		User:            cfg.User,
		Auth:            cfg.authMethods(),
		HostKeyCallback: ssh.InsecureIgnoreHostKey(), // parity with StrictHostKeyChecking=no
		Timeout:         10 * time.Second,
	}
	client, err := ssh.Dial("tcp", cfg.Endpoint(), clientConfig)
	if err != nil {
		return nil, fmt.Errorf("ssh %s: %w", cfg.Endpoint(), err)
	}
	return client, nil
}

// Probe checks SSH reachability with a real handshake (auth included),
// mirroring ci_nested_lib.sh's wait_for_ssh loop.
func Probe(cfg Config) error {
	client, err := Dial(cfg)
	if err != nil {
		return err
	}
	return client.Close()
}

// Run executes cmd and streams stdout/stderr; the exit status of the
// remote command is returned as the error.
func Run(client *ssh.Client, cmd string, stdout, stderr io.Writer) error {
	session, err := client.NewSession()
	if err != nil {
		return err
	}
	defer session.Close()
	session.Stdout = stdout
	session.Stderr = stderr
	if err := session.Run(cmd); err != nil {
		if exitErr, ok := err.(*ssh.ExitError); ok {
			return fmt.Errorf("remote exit status %d", exitErr.ExitStatus())
		}
		return err
	}
	return nil
}

// Shell opens an interactive login shell on a pty, wiring the local
// terminal. Best effort window resizing via SIGWINCH.
func Shell(cfg Config, client *ssh.Client) error {
	session, err := client.NewSession()
	if err != nil {
		return err
	}
	defer session.Close()

	stdin := os.Stdin
	stdout := os.Stdout

	rows, cols := 24, 80
	if termSize, ok := terminalSize(); ok {
		rows, cols = termSize.rows, termSize.cols
	}
	if err := session.RequestPty("xterm-256color", rows, cols, ssh.TerminalModes{}); err != nil {
		return fmt.Errorf("request pty: %w", err)
	}
	session.Stdin = stdin
	session.Stdout = stdout
	session.Stderr = os.Stderr

	if state, err := makeRaw(stdin); err == nil {
		defer restore(stdin, state)
		watchResize(func(r, c int) {
			_ = session.WindowChange(r, c)
		})
	}

	if err := session.Shell(); err != nil {
		return fmt.Errorf("start shell: %w", err)
	}
	return session.Wait()
}
