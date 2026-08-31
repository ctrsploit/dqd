// Package docker wraps the docker CLI for read-only queries.
//
// The CLI shells out (rather than using the Docker SDK) deliberately:
// docker — and docker compose — are hard prerequisites for running
// dqd environments anyway, and the JSON formats consumed here are
// stable `--format '{{json .}}'` output.
package docker

import (
	"context"
	"encoding/json"
	"fmt"
	"os/exec"
	"strings"
)

// Label used by docker compose on every container it manages.
const ProjectLabel = "com.docker.compose.project"

// Container is one `docker ps` row.
type Container struct {
	ID      string
	Name    string
	Image   string
	State   string // running / exited / ...
	Status  string // human status incl. uptime
	Ports   string
	Project string // compose project label
}

type psRow struct {
	ID     string `json:"ID"`
	Names  string `json:"Names"`
	Image  string `json:"Image"`
	State  string `json:"State"`
	Status string `json:"Status"`
	Ports  string `json:"Ports"`
	Labels string `json:"Labels"`
}

// PS lists containers (running only, or all). It returns an error if
// the docker CLI is unavailable.
func PS(ctx context.Context, all bool) ([]Container, error) {
	args := []string{"ps", "--format", "{{json .}}"}
	if all {
		args = append(args, "-a")
	}
	out, err := exec.CommandContext(ctx, "docker", args...).Output()
	if err != nil {
		return nil, fmt.Errorf("docker ps: %w", err)
	}
	var containers []Container
	for _, line := range strings.Split(strings.TrimSpace(string(out)), "\n") {
		if line == "" {
			continue
		}
		var row psRow
		if err := json.Unmarshal([]byte(line), &row); err != nil {
			return nil, fmt.Errorf("docker ps: parse %q: %w", line, err)
		}
		c := Container{
			ID: row.ID, Name: firstName(row.Names), Image: row.Image,
			State: row.State, Status: row.Status, Ports: row.Ports,
		}
		for _, kv := range strings.Split(row.Labels, ",") {
			key, value, ok := strings.Cut(kv, "=")
			if ok && key == ProjectLabel {
				c.Project = value
			}
		}
		containers = append(containers, c)
	}
	return containers, nil
}

// RunningByProject returns running containers grouped by compose
// project name.
func RunningByProject(ctx context.Context) (map[string][]Container, error) {
	containers, err := PS(ctx, false)
	if err != nil {
		return nil, err
	}
	m := map[string][]Container{}
	for _, c := range containers {
		if c.Project != "" {
			m[c.Project] = append(m[c.Project], c)
		}
	}
	return m, nil
}

// HostPort returns the actual published host port for a container's
// containerPort, e.g. PortOf("dqd-vm-1", "22") -> "24040".
func HostPort(ctx context.Context, container, containerPort string) (string, error) {
	out, err := exec.CommandContext(ctx, "docker", "port", container, containerPort).Output()
	if err != nil {
		return "", fmt.Errorf("docker port %s %s: %w", container, containerPort, err)
	}
	line := strings.TrimSpace(string(out))
	if line == "" {
		return "", fmt.Errorf("container %s publishes no port %s", container, containerPort)
	}
	// lines look like "0.0.0.0:24040" or "[::]:24040"; the host port
	// is the part after the last colon on the first line
	first := strings.SplitN(line, "\n", 2)[0]
	i := strings.LastIndex(first, ":")
	if i < 0 {
		return "", fmt.Errorf("docker port %s %s: unexpected output %q", container, containerPort, first)
	}
	return first[i+1:], nil
}

// PickServiceContainer chooses the container a user means when they
// SSH into an environment: the `vm` service, else `master`, else the
// first sorted container name.
func PickServiceContainer(containers []Container) *Container {
	if len(containers) == 0 {
		return nil
	}
	for _, suffix := range []string{"-vm-1", "-master-1"} {
		for i := range containers {
			if strings.HasSuffix(containers[i].Name, suffix) {
				return &containers[i]
			}
		}
	}
	first := containers[0]
	return &first
}

func firstName(names string) string {
	return strings.SplitN(names, ",", 2)[0]
}
