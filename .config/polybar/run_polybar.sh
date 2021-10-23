#!/bin/bash


# Determine network interface 
interface=`ip link | grep 'mode DORMANT' | head -n1 | cut -d':' -f2 | cut -d' ' -f2`
echo "Using interface $interface"

# Determine color depending on color scheme
color=$(grep light $HOME/.config/current_color_scheme 1>/dev/null && echo \#000 || echo \#FFF)

# Launch spotify metadata receiver script
# TODO: kill previous instances within spotify-metadata-receiver.py itself
kill $(pgrep -af "python $HOME/.config/polybar/spotify-metadata-receiver.py" | cut -d' ' -f1)
python ~/.config/polybar/spotify-metadata-receiver.py localhost 8887 '{i("%{F#F00}♥%{F-} ", liked)}{i("¹↷", loop)}{i("⇄", shuffle)} %{{T3}}{artist}%{{T-}} {title} %{{T4}}{chr(39).join(map("{:02}".format, divmod(duration - elapsed, 60)))}%{{T-}}"' ~/.config/polybar/spotify-metadata.txt 2>receiver_errors.txt &

# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done


# Launch Polybar, using default config location ~/.config/polybar/config
for monitor in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do
    FONT_FAMILY=$(cat $HOME/.config/current_font_family) COLOR_PRIM=$color COLOR_SEC=$color BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini top &
    FONT_FAMILY=$(cat $HOME/.config/current_font_family) COLOR_PRIM=$color COLOR_SEC=$color BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini bottom &
done

echo "Polybar launched."

