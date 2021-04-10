#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Determine network interface 
interface=`ip link | grep 'mode DORMANT' | head -n1 | cut -d':' -f2 | cut -d' ' -f2`
echo "Using interface $interface"

# Determine font size & bar height from hostname
# TODO: from screen size instead (figure out the ratios)
if test `hostname` = "stealth"; then
    fz=11
    height=35
else
    fz=13
    height=50
fi

font1="unifont:fontformat=truetype:antialias=false:size=$fz;0"
font0="Fira Code Nerd Font;1"

# Launch Polybar, using default config location ~/.config/polybar/config
for monitor in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do
    FONT_1=$font1 FONT_0=$font0 BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini top &
    FONT_1=$font1 FONT_0=$font0 BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini bottom &
done

echo "Polybar launched."

