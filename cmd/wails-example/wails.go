package main

import (
	"os"

	"github.com/whynotea/wails-example/cmd/wails-example/wails"
)

var useWails = "false"

func init() {
	rootCmd.AddCommand(wails.WailsCmd)

	if useWails == "true" {
		os.Args = append([]string{os.Args[0], "wails"}, os.Args[1:]...)
	}
}
