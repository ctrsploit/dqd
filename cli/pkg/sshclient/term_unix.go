//go:build linux || darwin || freebsd

package sshclient

import (
	"os"
	"os/signal"
	"syscall"

	"golang.org/x/term"
)

type winsize struct{ rows, cols int }

// terminalSize returns the size of stdout's terminal.
func terminalSize() (winsize, bool) {
	w, h, err := term.GetSize(int(os.Stdout.Fd()))
	if err != nil {
		return winsize{}, false
	}
	return winsize{rows: h, cols: w}, true
}

// makeRaw puts f into raw mode; callers must restore with the
// returned state.
func makeRaw(f *os.File) (*term.State, error) {
	return term.MakeRaw(int(f.Fd()))
}

// restore returns f to its previous mode.
func restore(f *os.File, state *term.State) {
	_ = term.Restore(int(f.Fd()), state)
}

// watchResize calls onChange with the new size on every SIGWINCH
// until the process exits. Errors are ignored (non-tty).
func watchResize(onChange func(rows, cols int)) {
	if !term.IsTerminal(int(os.Stdout.Fd())) {
		return
	}
	ch := make(chan os.Signal, 1)
	signal.Notify(ch, syscall.SIGWINCH)
	go func() {
		for range ch {
			if ws, ok := terminalSize(); ok {
				onChange(ws.rows, ws.cols)
			}
		}
	}()
}
