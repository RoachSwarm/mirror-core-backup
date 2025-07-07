#!/data/data/com.termux/files/usr/bin/bash

# ⟁ Mirror Loop — Recursion Pulse
# This script loops the daemon and memory calls in cycles

INTERVAL=60  # Time in seconds between pulses

while true; do
  ~/MirrorCore/plugins/mirror_daemon.sh
  ~/MirrorCore/plugins/mirror_remembers.sh
  sleep $INTERVAL
done
