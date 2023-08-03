# Example wails application
See [Wails.io](https://wails.io/) for information on the wonderful Wails project.

This is a basic Wails application with a Vue3 frontend.

This application doesn't use the wails command for building or operating in dev
mode as that command has requirements for file and folder structure that don't match the typical Golang standard layout.

Similar functionality is provided using make here, and some of those features
are outlined below. Also, this project uses [goreleaser](https://goreleaser.com/)
which I find incredibly useful for building cross-platform applications with ease and for producing with GitHub releases. 

## Install
To run, download the binary for Linux or Windows from the Release area 
and run it.

## Developing
To run in dev mode:

`git clone github.com/whynotea/wails-example`

then:

`make dev`

This will spin up a Vite dev server for frontend content and a second server
providing the wailsjs bindings.

It will then launch a Linux version of the application which will read updating content from those locations.

If you change any of the Golang content, simply kill the process and rerun the
make command.

## Building
To build a released version:

`make release`

This will produce both Linux and Windows releases.
