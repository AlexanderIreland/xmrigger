#!/bin/bash
echo "# ██████╗  ██████╗ ███████╗████████╗   ██████╗ ██╗ ██████╗ "
echo "# ██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝   ██╔══██╗██║██╔════╝ "
echo "# ██████╔╝██║   ██║███████╗   ██║█████╗██████╔╝██║██║  ███╗"
echo "# ██╔═══╝ ██║   ██║╚════██║   ██║╚════╝██╔══██╗██║██║   ██║"
echo "# ██║     ╚██████╔╝███████║   ██║      ██║  ██║██║╚██████╔╝"
echo "# ╚═╝      ╚═════╝ ╚══════╝   ╚═╝      ╚═╝  ╚═╝╚═╝ ╚═════╝ "
echo "# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#todo
# 1) Throw fancy success message
# x) Verify wallet address
# 3) Provide miner start option

function start-miner-simple () {
  echo "I'm a stub function"
  ./xmrig #should need no args, planning to gen config file 
}

function start-miner-screen () {
  # starts a screen that is immediately detatched - using /bin/bash instead of bash
  screen -dmS /bin/bash -c "./xmrig" xmrig
}

function main () {
  start-miner-simple
}


