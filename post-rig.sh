#!/bin/bash

#todo
# 1) Throw fancy success message
# x) Verify wallet address
# 3) Provide miner start option

BASIC_START="false"
SILENT_START="false"

function intro-text () {
  echo "${CYAN}+---------------------------------------------------------+"
  echo "${PURPLE}# ██████╗  ██████╗ ███████╗████████╗   ██████╗ ██╗ ██████╗ "
  echo "${PURPLE}# ██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝   ██╔══██╗██║██╔════╝ "
  echo "${PURPLE}# ██████╔╝██║   ██║███████╗   ██║█████╗██████╔╝██║██║  ███╗"
  echo "${PURPLE}# ██╔═══╝ ██║   ██║╚════██║   ██║╚════╝██╔══██╗██║██║   ██║"
  echo "${PURPLE}# ██║     ╚██████╔╝███████║   ██║      ██║  ██║██║╚██████╔╝"
  echo "${PURPLE}# ╚═╝      ╚═════╝ ╚══════╝   ╚═╝      ╚═╝  ╚═╝╚═╝ ╚═════╝ "
  echo "${CYAN}+---------------------------------------------------------+"
}

while getopts bs:ss: flag
do
  case "${flag}" in
    bs) BASIC_START=true;;
    ss) SILENT_START=true;;
  esac
done


function start-miner-basic () {
  echo "I'm a stub function"
  ./xmrig #should need no args, planning to gen config file 
}

function start-miner-silent () {
  # starts a screen that is immediately detatched - using /bin/bash instead of bash
  screen -dmS /bin/bash -c "./xmrig" xmrig
}

function main () {
  intro-text
  if [[ BASIC_START==true ]]
  then
	  start-miner-basic
  else
  start-miner-silent
}


