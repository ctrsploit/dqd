package cli

import "testing"

func TestSplitRemote(t *testing.T) {
	cases := []struct {
		name            string
		token           string
		wantEnv         string
		wantRemotePath  string
		wantOk          bool
	}{
		{"absolute remote", "ubuntu/24.04:/root/file", "ubuntu/24.04", "/root/file", true},
		{"relative remote", "ubuntu/24.04:file", "ubuntu/24.04", "file", true},
		{"empty remote path", "ubuntu/24.04:", "ubuntu/24.04", "", true},
		{"local path no colon", "./file", "", "", false},
		{"local path with colon in name", "./weird:name", "./weird", "name", true},
		{"windows drive local", "C:/foo", "C", "/foo", true},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			env, remotePath, ok := splitRemote(tc.token)
			if env != tc.wantEnv || remotePath != tc.wantRemotePath || ok != tc.wantOk {
				t.Fatalf("got (%q,%q,%v), want (%q,%q,%v)", env, remotePath, ok, tc.wantEnv, tc.wantRemotePath, tc.wantOk)
			}
		})
	}
}
