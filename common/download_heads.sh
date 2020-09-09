#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
source /home/heads/common_scripts/variables.sh

IS_BUILD_DIR_EMPTY=$(ls -A "$DOCKER_HEADS_DIR")


################################################################################
## Update or clone git Heads repo
################################################################################
function gitUpdate() {
  if [ -z "$IS_BUILD_DIR_EMPTY" ]; then
    # Clone Heads
    git clone https://github.com/osresearch/heads "$DOCKER_HEADS_DIR"
    cd "$DOCKER_HEADS_DIR" || exit
  else
    cd "$DOCKER_HEADS_DIR" || exit
    git fetch --all --tags --prune
  fi
}
################################################################################



################################################################################
##
################################################################################
function checkoutTag() {
  cd "$DOCKER_HEADS_DIR" || exit
  git checkout tags/"$HEADS_TAG" || exit
}
################################################################################



################################################################################
##
################################################################################
function checkoutCommit() {
  cd "$DOCKER_HEADS_DIR" || exit
  # edge should checkout master
  git checkout "$HEADS_COMMIT" || exit

  if  [ "$HEADS_COMMIT" == "master"  ]; then
    git pull --all
  fi

  git submodule update --recursive --remote
}
################################################################################

################################################################################
## MAIN FUNCTION: download/clone/checkout appropriate version of Heads
########################################
########################################################################################################################
function downloadOrUpdateHeads() {
  gitUpdate

  if [ "$HEADS_COMMIT" ]; then
    checkoutCommit
  elif [ "$HEADS_TAG" ]; then
    checkoutTag
  else
    HEADS_COMMIT="master"
    checkoutCommit
  fi
}
################################################################################
