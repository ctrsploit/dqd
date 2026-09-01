package cli

import "testing"

func TestScpSide(t *testing.T) {
	cases := []struct {
		name             string
		src, dst         string
		wantSrc, wantDst bool
		wantErr          bool
	}{
		{"upload", "./file", ":/root/file", false, true, false},
		{"download", ":/root/file", "./file", true, false, false},
		{"relative remote", "file.txt", ":file.txt", false, true, false},
		{"both remote errors", ":/a", ":/b", false, false, true},
		{"both local errors", "./a", "./b", false, false, true},
		{"colon mid-path is local", "./weird:name", ":/root/x", false, true, false},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			srcRemote, dstRemote, err := scpSide("dqd", tc.src, tc.dst)
			if tc.wantErr {
				if err == nil {
					t.Fatalf("expected error for %q %q", tc.src, tc.dst)
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if srcRemote != tc.wantSrc || dstRemote != tc.wantDst {
				t.Fatalf("got (%v,%v), want (%v,%v)", srcRemote, dstRemote, tc.wantSrc, tc.wantDst)
			}
		})
	}
}
