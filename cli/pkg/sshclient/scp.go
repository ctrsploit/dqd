// scp-style file transfer over the same native SSH connection the ssh
// command uses: no external scp/sftp binaries, same auth order (dqd key
// first, per-env password fallback).
package sshclient

import (
	"fmt"
	"io"
	"io/fs"
	"os"
	"path"
	"path/filepath"

	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

// SFTP opens an SFTP subsystem session on an established connection.
// Every dqd VM image ships openssh-server with the sftp subsystem
// enabled, so this is the same path a system `scp` would take.
func SFTP(client *ssh.Client) (*sftp.Client, error) {
	return sftp.NewClient(client)
}

// Upload copies localPath to remotePath. Directories require recursive
// (scp -r parity). File modes are preserved; empty directories are
// copied. A remotePath that already exists as a directory receives the
// source's base name, matching scp's `scp file host:/dir/` behavior.
func Upload(s *sftp.Client, localPath, remotePath string, recursive bool) error {
	st, err := os.Stat(localPath)
	if err != nil {
		return err
	}
	if fi, err := s.Stat(remotePath); err == nil && fi.IsDir() {
		remotePath = path.Join(remotePath, filepath.Base(localPath))
	}
	if st.IsDir() {
		if !recursive {
			return fmt.Errorf("%s is a directory (use -r)", localPath)
		}
		return uploadDir(s, localPath, remotePath)
	}
	return uploadFile(s, localPath, remotePath)
}

// Download copies remotePath to localPath, mirroring Upload's semantics
// (recursive for directories, modes preserved, existing local directory
// receives the source's base name).
func Download(s *sftp.Client, remotePath, localPath string, recursive bool) error {
	fi, err := s.Stat(remotePath)
	if err != nil {
		return err
	}
	if lst, err := os.Stat(localPath); err == nil && lst.IsDir() {
		localPath = filepath.Join(localPath, path.Base(remotePath))
	}
	if fi.IsDir() {
		if !recursive {
			return fmt.Errorf("%s is a directory (use -r)", remotePath)
		}
		return downloadDir(s, remotePath, localPath)
	}
	return downloadFile(s, remotePath, localPath)
}

func uploadFile(s *sftp.Client, localPath, remotePath string) error {
	st, err := os.Stat(localPath)
	if err != nil {
		return err
	}
	src, err := os.Open(localPath)
	if err != nil {
		return err
	}
	defer src.Close()
	dst, err := s.OpenFile(remotePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC)
	if err != nil {
		return err
	}
	defer dst.Close()
	if _, err := io.Copy(dst, src); err != nil {
		return err
	}
	// OpenFile applies no mode; assert the source's in case the file
	// already existed with different permissions.
	return dst.Chmod(st.Mode().Perm())
}

func uploadDir(s *sftp.Client, localPath, remotePath string) error {
	return filepath.WalkDir(localPath, func(p string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(localPath, p)
		if err != nil {
			return err
		}
		target := path.Join(remotePath, filepath.ToSlash(rel))
		info, err := d.Info()
		if err != nil {
			return err
		}
		if d.IsDir() {
			return mkdirRemote(s, target, info.Mode().Perm())
		}
		if !d.Type().IsRegular() { // symlink, device, ... — copy what's readable
			if _, err := os.Stat(p); err != nil {
				return nil // unreadable non-regular entry: skip, like scp
			}
		}
		return uploadFile(s, p, target)
	})
}

func downloadFile(s *sftp.Client, remotePath, localPath string) error {
	fi, err := s.Stat(remotePath)
	if err != nil {
		return err
	}
	src, err := s.Open(remotePath)
	if err != nil {
		return err
	}
	defer src.Close()
	dst, err := os.OpenFile(localPath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, fi.Mode().Perm())
	if err != nil {
		return err
	}
	defer dst.Close()
	_, err = io.Copy(dst, src)
	return err
}

func downloadDir(s *sftp.Client, remotePath, localPath string) error {
	walker := s.Walk(remotePath)
	for walker.Step() {
		if err := walker.Err(); err != nil {
			return err
		}
		rel, err := filepath.Rel(remotePath, walker.Path())
		if err != nil {
			return err
		}
		target := filepath.Join(localPath, filepath.FromSlash(rel))
		info := walker.Stat()
		if info.IsDir() {
			if err := os.MkdirAll(target, info.Mode().Perm()); err != nil {
				return err
			}
			// MkdirAll goes through the local umask; re-assert the
			// remote's directory mode for exact preservation.
			if err := os.Chmod(target, info.Mode().Perm()); err != nil {
				return err
			}
			continue
		}
		if !info.Mode().IsRegular() {
			continue // symlinks etc. are skipped on download
		}
		if err := downloadFile(s, walker.Path(), target); err != nil {
			return err
		}
	}
	return nil
}

// mkdirRemote creates dir and any missing parents with perm (an
// existing directory is not an error).
func mkdirRemote(s *sftp.Client, dir string, perm fs.FileMode) error {
	if _, err := s.Stat(dir); err == nil {
		return nil
	}
	parent := path.Dir(dir)
	if parent != dir {
		if err := mkdirRemote(s, parent, 0o755); err != nil {
			return err
		}
	}
	if err := s.Mkdir(dir); err != nil && !os.IsExist(err) {
		return err
	}
	// sftp Mkdir takes no mode; the server's umask decides. Re-assert the
	// intended permissions so scp-style mode preservation holds for
	// directories too.
	if err := s.Chmod(dir, perm); err != nil {
		return err
	}
	return nil
}
