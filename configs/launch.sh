#!/usr/bin/env bash

# Resource-optimized launch script for i3wm
# Handles polybar, picom, and pywal efficiently

# Function to kill process safely
kill_process() {
    local process_name="$1"
    if pgrep -x "$process_name" >/dev/null; then
        killall -q "$process_name"
        # Wait for process to actually exit
        while pgrep -x "$process_name" >/dev/null; do 
            sleep 0.1
        done
        echo "Killed existing $process_name instances"
    fi
}

# Kill existing processes to prevent resource stacking
kill_process "polybar"
kill_process "picom"

# Wait for i3 to finish reload (fix race condition)
sleep 0.5

# Launch picom compositor (only if not running)
if ! pgrep -x picom >/dev/null; then
    picom -b --config ~/.config/picom/picom.conf &
    echo "Picom compositor started"
fi

# Load Xresources for Pywal colors (only if file exists)
if [ -f "$HOME/.cache/wal/colors-Xresources" ]; then
    xrdb -merge "$HOME/.cache/wal/colors-Xresources"
    echo "Loaded pywal Xresources"
fi

# Launch Polybar on all monitors
echo "Starting Polybar..."
for m in $(polybar --list-monitors | cut -d: -f1); do
    MONITOR=$m polybar main >>/tmp/polybar_"$m".log 2>&1 &
done

echo "Launch script completed - Polybar launched on all monitors"