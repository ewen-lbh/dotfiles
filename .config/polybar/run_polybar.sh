#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Determine network interface 
adaptater=`ip link | grep 'state UP' | cut -d':' -f2 | cut -d' ' -f2`

# Launch Polybar, using default config location ~/.config/polybar/config
for monitor in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do
	ADAPTATER=$adaptater MONITOR=$monitor polybar -c ~/.config/polybar/config.ini top &
	ADAPTATER=$adaptater MONITOR=$monitor polybar -c ~/.config/polybar/config.ini bottom &
done

echo "Polybar launched."
