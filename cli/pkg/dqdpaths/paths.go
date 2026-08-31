// Package dqdpaths resolves the CLI's cache and config directories.
//
// Both honor environment overrides (DQD_CACHE / DQD_CONFIG) so tests
// can point them at temp directories.
package dqdpaths

import (
	"os"
	"path/filepath"
)

// StateDirName is the ~/.cache and ~/.config subdirectory for this
// build (default "dqd"). The assembling binary sets it once at startup
// via cli.Identity so downstream CLIs get isolated state directories.
var StateDirName = "dqd"

// CacheDir returns ~/.cache/<StateDirName> (or $DQD_CACHE).
func CacheDir() (string, error) {
	if dir := os.Getenv("DQD_CACHE"); dir != "" {
		return dir, nil
	}
	base, err := os.UserCacheDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(base, StateDirName), nil
}

// ConfigDir returns ~/.config/dqd (or $DQD_CONFIG).
func ConfigDir() (string, error) {
	if dir := os.Getenv("DQD_CONFIG"); dir != "" {
		return dir, nil
	}
	base, err := os.UserConfigDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(base, StateDirName), nil
}

// TreeCacheDir is where the embedded snapshot is materialized.
func TreeCacheDir() (string, error) {
	dir, err := CacheDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(dir, "tree"), nil
}

// RemoteCacheDir is where user-opted remote configs are stored.
func RemoteCacheDir() (string, error) {
	dir, err := CacheDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(dir, "remote"), nil
}

// KeysDir is where the embedded dqd SSH key pair is materialized.
func KeysDir() (string, error) {
	dir, err := ConfigDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(dir, "keys"), nil
}
