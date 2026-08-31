// Package embedded exposes the self-contained config snapshot baked
// into the binary: the catalog index and a tar of every environment's
// compose files plus the dqd SSH key pair. The snapshot under live/ is
// generated (`dqd-gen embed`) and committed, so any build — including
// `go install` — is self-contained.
package embedded

import (
	"github.com/ctrsploit/dqd/cli/pkg/catalog"
)

// Index is the embedded catalog.
//
//nolint:gochecknoglobals // populated by the build-variant files below.
var Index *catalog.Index

// Tree is the embedded config tar.
//
//nolint:gochecknoglobals // populated by the build-variant files below.
var Tree *catalog.Tree

// Available reports whether a real (non-placeholder) snapshot is baked
// into this binary.
func Available() bool {
	return len(Index.Envs) > 0
}
