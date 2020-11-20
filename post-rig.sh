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

##########################
# Create service options #
##########################

# CentOS =<6 - service, CentOS =>7 init
# Service loc: /etc/systemd/system/xmrig.service

# broad example:
#[Unit]
#Description=xmrig
#[Service]
#User=root
#WorkingDirectory=$XMRIG_DIR/xmrig/build
##path to executable. 
##executable is a bash script which calls jar file
#ExecStart=$XMRIG_DIR/xmrig/build/xmrig
#SuccessExitStatus=143
#TimeoutStopSec=10
#Restart=on-failure
#RestartSec=5
#[Install]
#WantedBy=multi-user.target

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


