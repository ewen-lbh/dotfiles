#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Determine network interface based on hostname (might need a better way to get it though)

# Launch Polybar, using default config location ~/.config/polybar/config
for monitor in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do
	MONITOR=$monitor polybar -c ~/.config/polybar/config.ini top &
	MONITOR=$monitor polybar -c ~/.config/polybar/config.ini bottom &
done

echo "Polybar launched."
