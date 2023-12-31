package wails

import (
	"embed"
	"os"

	"github.com/spf13/cobra"
	"github.com/whynotea/wails-example/internal/wails"
)

//go:embed all:frontend/dist
var frontend embed.FS

var (
	loglevel             string
	frontenddevserverurl string
	devserver            string
)

// wailsCmd represents the wails command
var WailsCmd = &cobra.Command{
	Use:   "wails",
	Short: "Launch the wails application",
	Long:  `Launch the wails application`,
	Run: func(cmd *cobra.Command, args []string) {
		if loglevel != "" {
			os.Setenv("loglevel", loglevel)
		}
		if frontenddevserverurl != "" {
			os.Setenv("frontenddevserverurl", frontenddevserverurl)
		}
		if devserver != "" {
			os.Setenv("devserver", devserver)
		}
		wails.Init(frontend)
	},
}

func init() {
	WailsCmd.Flags().StringVarP(&loglevel, "loglevel", "l", "", "loglevel of the wails library in development mode")
	WailsCmd.Flags().StringVarP(&frontenddevserverurl, "frontenddevserverurl", "f", "", "url for the server providing frontend resources for the wails application whilst in development mode")
	WailsCmd.Flags().StringVarP(&devserver, "devserver", "b", "", "host:port for the server providing the wailsjs bindings for the wails application whilst in development mode")
}
