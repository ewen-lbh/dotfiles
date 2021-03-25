function select-wallpaper
	set --local walls ()
	set --local wallpaper_file ( \
		ls -l $HOME/wallpapers/*.png \
		| rev | cut -d"/" -f1 | rev \
		| cut -d" " -f1 \
		| cut -d"." -f1 \
		| rofi -dmenu -p "choose your wallpaper" \
	)
	if test "$wallpaper_file"
		cp $HOME/wallpapers/$wallpaper_file.png $HOME/.config/wallpaper.png
		i3-msg restart 1>/dev/null
		echo $HOME/wallpapers/$wallpaper_file.png 
	else
		return 1
	end
end

