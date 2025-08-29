#!/usr/bin/env bash

# Kill all running Polybar instances
killall -q polybar

# Wait for all Polybar processes to exit
while pgrep -x polybar >/dev/null; do sleep 0.2; done

# Optional: Wait for i3 to finish reload (fix race condition)
sleep 1

# Load Xresources for Pywal colors
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge "$HOME/.Xresources"
fi

# Launch Polybar on all monitors
for m in $(polybar --list-monitors | cut -d: -f1); do
    MONITOR=$m polybar main >>/tmp/polybar.log 2>&1 &
done

echo "Polybar launched on all monitors"