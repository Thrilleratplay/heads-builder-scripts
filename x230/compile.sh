#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

# shellcheck disable=SC1091
source /home/heads/common_scripts/variables.sh
source /home/heads/common_scripts/download_heads.sh

################################################################################
## MODEL VARIABLES
################################################################################
MAINBOARD="lenovo"
MODEL="x230"

################################################################################

###############################################
##   download/git clone/git pull Heads  ##
###############################################
downloadOrUpdateHeads

##############################
##   Copy config and make   ##
##############################
cd "$DOCKER_HEADS_DIR" || exit;
make BOARD="$MODEL-flash"
make BOARD="$MODEL"

#####################
##   Post build    ##
#####################
if [ ! -f "$DOCKER_HEADS_DIR/build/$MODEL/coreboot.rom" ]; then
  echo "Uh oh. Things did not go according to plan."
  exit 1;
else
  # Move complete Heads rom to be installed via USB drive.
  mv "$DOCKER_HEADS_DIR/build/$MODEL/coreboot.rom" "$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-complete.rom"

  #split out top BIOS
  mv "$DOCKER_HEADS_DIR/build/$MODEL-flash/coreboot.rom" "$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-flash-complete.rom"

  #split out top BIOS
  dd if="$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-flash-complete.rom" of="$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-flash-top.rom" bs=1M skip=8

  sha256sum "$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-flash-complete.rom" > "$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-flash-complete.rom.sha256"
  sha256sum "$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-flash-top.rom" > "$DOCKER_HEADS_DIR/heads_$MAINBOARD-$MODEL-flash-top.rom-sha256"
fi
