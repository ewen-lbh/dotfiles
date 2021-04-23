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
    fz=14
    height=35
else
    fz=13
    height=50
fi

font1="unifont:fontformat=truetype:antialias=false:size=$fz;0"
# font0="Fira Code Nerd Font;1"
font0="Scientifica:size=$fz;0"

# Determine color depending on color scheme
color=$(grep light $HOME/.config/current_color_scheme 1>/dev/null && echo \#000 || echo \#FFF)

# Launch spotify metadata receiver script
# TODO: kill previous instances within spotify-metadata-receiver.py itself
kill $(pgrep -af "python $HOME/.config/polybar/spotify-metadata-receiver.py" | cut -d' ' -f1)
python ~/.config/polybar/spotify-metadata-receiver.py localhost 8887 '{i("♥ ", liked)}{i("→ ", not repeat)}{i("¹↷", loop)}{i("⇄", shuffle)}{artist} — {title}' ~/.config/polybar/spotify-metadata.txt

# Launch Polybar, using default config location ~/.config/polybar/config
for monitor in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do
    COLOR_PRIM=$color COLOR_SEC=$color FONT_1=$font1 FONT_0=$font0 BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini top &
    COLOR_PRIM=$color COLOR_SEC=$color FONT_1=$font1 FONT_0=$font0 BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini bottom &
done

echo "Polybar launched."

