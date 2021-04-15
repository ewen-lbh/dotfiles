function switch-color-scheme --description "switch-color-scheme VARIANT, where VARIANT is 'light' or 'dark'"
	set -l variant $argv[1]
	if test "$variant" != light -a "$variant" != dark
		echo "Unrecognized color scheme variant '$variant'"
		return 1
	end
	echo $variant > $HOME/.config/current_color_scheme
	# update config files that can't update on their own
	wal --theme one-half (test $variant = light && echo -- -l)
	cat $HOME/.config/lazygit/config.yml | yq '.gui.theme.lightTheme = '(test $variant = light && echo true || echo false) | sponge $HOME/.config/lazygit/config.yml
    # update wallpaper
    cp $HOME/.config/wallpaper-$variant.png $HOME/.config/wallpaper.png
    # reload wallpaper & polybar
    i3-msg restart
end
