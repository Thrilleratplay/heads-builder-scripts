#!/bin/sh
# SPDX-License-Identifier: GPL-3.0+
set -e

## import variables
# shellcheck disable=SC1091
. ./common/variables.sh

################################################################################
## Menu
################################################################################

## Parse avialble models from directory names
AVAILABLE_MODELS=$(find ./ -maxdepth 1 -mindepth 1 -type d | sed  's/\.\///g' | grep -Ev "common|git")

## Help menu
usage()
{
  echo "Usage: "
  echo
  echo "  $0 [-t <TAG>] [-c <COMMIT>] [--clean-slate] <model>"
  echo
  echo "  --clean-slate                Purge previous build directory and config"
  echo "  -c, --commit <commit>        Git commit hash"
  echo "  -h, --help                   Show this help"
  echo "  -t, --tag <tag>              Git tag/version"
  echo
  echo "If a tag or commit not given, heads build the latest master branch commit."
  echo
  echo
  echo "Available models:"
  for AVAILABLE_MODEL in $AVAILABLE_MODELS; do
      echo "$(printf '\t')$AVAILABLE_MODEL"
  done
}

## Iterate through command line parameters
while :
do
    case "$1" in
      --clean-slate)
        CLEAN_SLATE=true
        shift 1;;
      -c | --commit)
        HEADS_COMMIT="$2"
        shift 2;;
      -h | --help)
        usage >&2
        exit 0;;
      -t | --tag)
        HEADS_TAG="$2"
        shift 2;;
      -*)
        echo "Error: Unknown option: $1" >&2
        usage >&2
        exit 1;;
      *)
        break;;
    esac
done

## Validate and normalize given model number
MODEL=$(echo "$@" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]');

## Check if valid model
if [ -z "$MODEL" ] || [ ! -d "$PWD/$MODEL" ]; then
  usage
  exit 1;
fi;

################################################################################
################################################################################

if [ ! -d "$PWD/$MODEL/build" ]; then
  mkdir "$PWD/$MODEL/build"
elif [ "$CLEAN_SLATE" ]; then
  rm -rf "$PWD/$MODEL/build" || true
  mkdir "$PWD/$MODEL/build"
fi

## Run Docker
docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    -v "$PWD/$MODEL/build:$DOCKER_HEADS_DIR" \
    -v "$PWD/$MODEL:$DOCKER_SCRIPT_DIR" \
    -v "$PWD/common:$DOCKER_COMMON_SCRIPT_DIR" \
    -v "$PWD/$MODEL/stock_bios:$DOCKER_STOCK_BIOS_DIR:ro" \
    -e HEADS_COMMIT="$HEADS_COMMIT" \
    -e HEADS_TAG="$HEADS_TAG" \
    "$(docker build -q .)" \
    /home/heads/scripts/compile.sh
