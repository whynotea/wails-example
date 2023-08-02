package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

var Version = "development"

var versionCommand = &cobra.Command{
	Use:   "version",
	Short: "Version of wails-example",
	Long:  "Version of wails-example",
	RunE:  version,
}

func init() {
	rootCmd.AddCommand(versionCommand)
}

func version(cmd *cobra.Command, args []string) error {
	fmt.Printf("name: %s, version: %s\n", name(), Version)
	return nil
}

func name() string {
	return "Basic Cli"
}
