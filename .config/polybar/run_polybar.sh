#!/bin/bash


# Determine network interface 
interface=`ip link | grep 'mode DORMANT' | head -n1 | cut -d':' -f2 | cut -d' ' -f2`
echo "Using interface $interface"

# Determine color depending on color scheme
color=$(grep light $HOME/.config/current_color_scheme 1>/dev/null && echo 000 || echo FFF)
other_color=$(test $color = "000" && echo FFF || echo 000)

# Launch spotify metadata receiver script
# TODO: kill previous instances within spotify-metadata-receiver.py itself
kill $(pgrep -af "python $HOME/.config/polybar/spotify-metadata-receiver.py" | cut -d' ' -f1)
python ~/.config/polybar/spotify-metadata-receiver.py localhost 8887 \
	'%{{T3}}{i("%{T5}%{F#F00} %{F-}%{T-}  ", liked)}%{{T-}}%{{T3}}{artist_clean}%{{T-}}{"  " if " " in artist_clean else " "}{title.replace("(", "%{T4}" + ("  " if " " in artist_clean else " ")).replace(")", "%{T-}" + ("  " if " " in artist_clean else " ")).replace("[", "%{T4}" + ("  " if " " in artist_clean else " ")).replace("]", "%{T-}" + ("  " if " " in artist_clean else " ")).replace(" - ", ("  " if " " in artist_clean else " ") + "%{T4}")}\n{lyric_line}\n' \
	~/.config/polybar/spotify-metadata.txt 2>receiver_errors.txt &

# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done


# Launch Polybar, using default config location ~/.config/polybar/config
for monitor in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do
	FONT_FAMILY=$(cat $HOME/.config/current_font_family) FG="#$color" BG="#A$other_color" BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini top &
    FONT_FAMILY=$(cat $HOME/.config/current_font_family) FG="#$color" BG="#A$other_color" BAR_HEIGHT=$height INTERFACE=$interface MONITOR=$monitor polybar -c ~/.config/polybar/config.ini bottom &
done

echo "Polybar launched."

