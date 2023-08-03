#!/bin/bash
#==============================================================================
# Description
#==============================================================================
description="Description: 
run wails in dev mode" 
#------------------------------------------------------------------------------

#==============================================================================
# Global constants
#==============================================================================
# A list of useful constants
script_name=`basename "$0"`
script_dir=`dirname "$0"`
node=""
#------------------------------------------------------------------------------

#============================================================================
# Usage 
#============================================================================
Usage()
{
  local output="
           $script_name [opts] <node ip/host>\n\n
           \t${description}\n\n
           \t[-h] - print this usage statement\n
           \t[-v] - print more verbose output\n
           "
  echo -e $output >&2
}
#----------------------------------------------------------------------------

#============================================================================
# Settings 
#============================================================================
Settings()
{
  if $verbose; then
    echo
    echo "User     : ${user}"
    echo
  fi
}
#----------------------------------------------------------------------------

#============================================================================
# Get Options 
#============================================================================
Get_Options()
{
  OPTIND=1
  while getopts ":hvbx" opt; do 
    case $opt in 
      h) 
        Usage 
        exit 1
        ;;
      v) 
        verbose=true
        ;;
      x) 
        runApplication=false
        ;;
      b) 
        bindings=true
        ;;
      \?)
        echo "Invalid option: -$OPTARG." >&2
        Usage
        exit 1
        ;;
      :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
  done 
  shift "$((OPTIND-1))" # Shift off the options

  # Output settings if verbose output is specified.
  Settings 
}
#----------------------------------------------------------------------------

#==============================================================================
# Cleanup
#==============================================================================
pid=$$

function cleanup {
  echo "Closing"
  # $$ indicates the pid of the current process
  # ps j -p lists the group id for all processes spawned by this script
  # it's used to ensure all spawned processed are killed
  echo "$(ps j -p $$)"
  gid=$(ps j -p $$ | grep -o '[0-9]*' | sed '3q;d')
  echo "Killing ${gid}"
  kill -SIGTERM -- -${gid}
  return 0
}

#------------------------------------------------------------------------------

#==============================================================================
# Defaults
#==============================================================================
# Set some defaults
verbose=false
bindings=false
runApplication=true
wintags="remote exclude_graphdriver_btrfs btrfs_noversion exclude_graphdriver_devicemapper containers_image_openpgp"
btags="bindings"
devtags="dev"
#------------------------------------------------------------------------------

#==============================================================================
# Main
#==============================================================================
Get_Options "$@" 

trap cleanup EXIT

home_dir=$(pwd)
app_dir="${home_dir}/cmd/wails-example"
frontend_dir="${app_dir}/wails/frontend"
if ! [[ -d "${frontend_dir}/dist" ]]; then
  echo "Building Frontend"
  cd ${frontend_dir}
  npm install
  npm run build
  cd $home_dir
fi

# If we want to regenerate bindings or bindings currently don't exist
if $bindings || ! [[ -d "${app_dir}/wails/frontend/wailsjs" ]]; then
  echo "Creating Bindings"
  cd ${app_dir}
  go build -ldflags "-s -w -X main.useWails=true" -tags "$btags" -gcflags "all=-N -l" -o bindings
  ./bindings
  rm ./bindings
  cd $home_dir
fi

cd "${app_dir}/wails/frontend"
npx http-server -p 3335 &
cd $home_dir

cd ${frontend_dir}
npm run dev &
cd $home_dir

echo "Building APP"

goreleaser release --config $home_dir/.goreleaser-dev.yml --snapshot --clean --skip-sbom --skip-sign --skip-publish --skip-validate --skip-docker

if $runApplication; then
  # Give the web servers time to start up before starting the app
  sleep 5

  echo "Running APP"
  ./dist/wails-example_linux_amd64_v1/wails-example -l "warning" -f "http://localhost:3333" -b "localhost:3335"
else
  cat -
fi
#------------------------------------------------------------------------------
