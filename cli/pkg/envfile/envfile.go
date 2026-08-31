// Package envfile parses dqd environment definition files:
// the dotenv-style <ENV>/.env and the docker-compose.yml files
// that together describe one environment.
//
// The parsers intentionally mirror the semantics of the shell
// snippets they replace (sed-based extraction in bin/dqd and
// script/ci_nested_lib.sh), so the Go CLI behaves identically
// on the existing corpus of 466 environments.
package envfile

import (
	"fmt"
	"os"
	"strings"
)

// EnvFile holds the KEY=VALUE pairs of a dqd .env file.
type EnvFile struct {
	values map[string]string
}

// ParseEnv parses dotenv content. It accepts blank lines, full-line
// comments (#) and optional surrounding double quotes on values
// (e.g. BUILD_EXTRA_ARGS="--no-cache ..."), matching what the
// bash tooling extracts via sed + tr -d '"'.
func ParseEnv(data []byte) (*EnvFile, error) {
	e := &EnvFile{values: map[string]string{}}
	for i, line := range strings.Split(string(data), "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		eq := strings.Index(line, "=")
		if eq <= 0 {
			return nil, fmt.Errorf(".env line %d: not KEY=VALUE: %q", i+1, line)
		}
		key := strings.TrimSpace(line[:eq])
		value := strings.TrimSpace(line[eq+1:])
		if len(value) >= 2 && value[0] == '"' && value[len(value)-1] == '"' {
			value = value[1 : len(value)-1]
		}
		e.values[key] = value
	}
	return e, nil
}

// LoadEnv reads and parses the .env file at path.
func LoadEnv(path string) (*EnvFile, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return ParseEnv(data)
}

// Get returns the value of key, or "" when unset.
func (e *EnvFile) Get(key string) string {
	if e == nil {
		return ""
	}
	return e.values[key]
}

// Bool reports whether key is set to a truthy value
// (true/1/yes/on, case-insensitive) — the same set
// generate_ssh_config.sh accepts for SKIP_SSH_CONFIG.
func (e *EnvFile) Bool(key string) bool {
	switch strings.ToLower(e.Get(key)) {
	case "true", "1", "yes", "on":
		return true
	}
	return false
}
