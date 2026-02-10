package main

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

func must[T any](v T, err error) T {
	if err != nil {
		panic(err)
	}
	return v
}

func newSet(items ...string) map[string]struct{} {
	res := make(map[string]struct{})
	for _, item := range items {
		res[item] = struct{}{}
	}
	return res
}

var blocklist = newSet("node_modules", ".venv", ".env", ".worktree")

func main() {
	home := os.DirFS(must(os.UserHomeDir()))
	fs.WalkDir(
		home,
		"src",
		func(path string, d fs.DirEntry, err error) error {
			if !d.IsDir() {
				return nil
			}

			if _, ok := blocklist[d.Name()]; ok {
				return fs.SkipDir
			}

			if _, err := fs.Stat(
				home, filepath.Join(path, ".git"),
			); os.IsNotExist(err) {
				return nil
			}

			fmt.Println(strings.TrimPrefix(path, "src/"))

			return fs.SkipDir
		},
	)
}
