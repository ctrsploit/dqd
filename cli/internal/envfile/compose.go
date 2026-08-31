package envfile

import (
	"fmt"
	"os"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

// Service is the subset of a compose service definition the CLI
// needs. The dqd corpus only ever uses image/ports/environment/
// command/tty/stdin_open/extends/healthcheck/depends_on.
type Service struct {
	Image          string
	Ports          []string // raw short-syntax entries, e.g. "24040:22"
	Environment    []string // "KEY=VALUE" entries
	Command        string   // scalar form; list form is joined with spaces
	ExtendsFiles   []string // files referenced via extends
	HasHealthcheck bool
}

// Compose is a parsed docker-compose document.
type Compose struct {
	Services map[string]*Service
}

type rawCompose struct {
	Services map[string]rawService `yaml:"services"`
}

type rawService struct {
	Image       yaml.Node    `yaml:"image"`
	Ports       []string     `yaml:"ports"`
	Environment envValue     `yaml:"environment"`
	Command     commandValue `yaml:"command"`
	Extends     extendsValue `yaml:"extends"`
	Healthcheck yaml.Node    `yaml:"healthcheck"`
}

// envValue accepts both the list ("- KEY=VALUE") and mapping forms
// of compose environment. The corpus only uses the list form.
type envValue []string

func (v *envValue) UnmarshalYAML(node *yaml.Node) error {
	switch node.Kind {
	case yaml.SequenceNode:
		var list []string
		if err := node.Decode(&list); err != nil {
			return err
		}
		*v = list
	case yaml.MappingNode:
		var m map[string]string
		if err := node.Decode(&m); err != nil {
			return err
		}
		keys := make([]string, 0, len(m))
		for k := range m {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			*v = append(*v, k+"="+m[k])
		}
	case 0:
		return nil
	default:
		return fmt.Errorf("unsupported environment node kind %v", node.Kind)
	}
	return nil
}

// commandValue accepts scalar and list command forms.
type commandValue string

func (c *commandValue) UnmarshalYAML(node *yaml.Node) error {
	switch node.Kind {
	case yaml.ScalarNode:
		*c = commandValue(node.Value)
	case yaml.SequenceNode:
		var list []string
		if err := node.Decode(&list); err != nil {
			return err
		}
		*c = commandValue(strings.Join(list, " "))
	case 0:
		return nil
	default:
		return fmt.Errorf("unsupported command node kind %v", node.Kind)
	}
	return nil
}

// extendsValue accepts both the mapping form ({file: ..., service: ...})
// and the newer list form.
type extendsValue []string

func (e *extendsValue) UnmarshalYAML(node *yaml.Node) error {
	switch node.Kind {
	case yaml.MappingNode:
		var m struct {
			File    string `yaml:"file"`
			Service string `yaml:"service"`
		}
		if err := node.Decode(&m); err != nil {
			return err
		}
		if m.File != "" {
			*e = []string{m.File}
		}
	case yaml.SequenceNode:
		var list []struct {
			File string `yaml:"file"`
		}
		if err := node.Decode(&list); err != nil {
			return err
		}
		for _, item := range list {
			if item.File != "" {
				*e = append(*e, item.File)
			}
		}
	case 0:
		return nil
	default:
		return fmt.Errorf("unsupported extends node kind %v", node.Kind)
	}
	return nil
}

// ParseCompose parses a docker-compose.yml document.
func ParseCompose(data []byte) (*Compose, error) {
	var raw rawCompose
	if err := yaml.Unmarshal(data, &raw); err != nil {
		return nil, fmt.Errorf("parse compose: %w", err)
	}
	c := &Compose{Services: map[string]*Service{}}
	for name, rs := range raw.Services {
		s := &Service{
			Image:          rs.Image.Value,
			Ports:          rs.Ports,
			Environment:    rs.Environment,
			Command:        string(rs.Command),
			ExtendsFiles:   rs.Extends,
			HasHealthcheck: rs.Healthcheck.Kind != 0 && !rs.Healthcheck.IsZero(),
		}
		c.Services[name] = s
	}
	return c, nil
}

// LoadCompose reads and parses the compose file at path.
func LoadCompose(path string) (*Compose, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return ParseCompose(data)
}

// Names returns the service names in sorted order.
func (c *Compose) Names() []string {
	names := make([]string, 0, len(c.Services))
	for name := range c.Services {
		names = append(names, name)
	}
	sort.Strings(names)
	return names
}

// HostPortOf returns the host port of the "host:container" mapping
// for the given container port, or "" when absent. With multiple
// mappings the first wins, matching the sed|head -n1 behavior of
// ssh_port_from_compose in script/ci_nested_lib.sh.
func (s *Service) HostPortOf(containerPort string) string {
	suffix := ":" + containerPort
	for _, p := range s.Ports {
		// entries are raw short syntax like "24040:22"; tolerate a
		// stray long form "24040:22/udp" by splitting on "/" first
		if i := strings.Index(p, "/"); i >= 0 {
			p = p[:i]
		}
		if strings.HasSuffix(p, suffix) {
			return strings.TrimSuffix(p, suffix)
		}
	}
	return ""
}
