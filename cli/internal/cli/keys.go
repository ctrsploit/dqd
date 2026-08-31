package cli

import (
	"os"
	"path/filepath"

	"github.com/ctrsploit/dqd/cli/internal/dqdpaths"
)

// KeyPEM returns the dqd private key, materializing it from the
// embedded snapshot on first use (0600 under ~/.config/dqd/keys).
// This is the same key pair the repository ships in ssh_config/ and
// that every VM image authorizes; it enables passwordless root login
// without sshpass.
func (a *App) KeyPEM() []byte {
	dir, err := dqdpaths.KeysDir()
	if err != nil {
		return nil
	}
	keyPath := filepath.Join(dir, "dqd")
	if data, err := os.ReadFile(keyPath); err == nil {
		return data
	}
	if a.Tree == nil {
		return nil
	}
	data, ok := a.Tree.Key("dqd")
	if !ok {
		return nil
	}
	if err := os.MkdirAll(dir, 0o700); err != nil {
		return nil
	}
	if err := os.WriteFile(keyPath, data, 0o600); err != nil {
		return nil
	}
	return data
}
