function switch-color-scheme --description "switch-color-scheme VARIANT, where VARIANT is 'light' or 'dark'"
	set -l variant $argv[1]
	if test "$variant" = auto
		set variant (test (date +%H) -ge 0 -a (date +%H) -le 21; and echo light; or echo dark)
	end
	if test "$variant" != light -a "$variant" != dark
		echo "Unrecognized color scheme variant '$variant'"
		return 1
	end
	set -l varianttitlecase 
	if test $variant = light
		set varianttitlecase Light
	else
		set varianttitlecase Dark
	end
	echo $variant > $HOME/.config/current_color_scheme
	# update config files that can't update on their own
	wal --theme one-half (test $variant = light && echo -- -l)
	cat $HOME/.config/lazygit/config.yml | yq -Y '.gui.theme.lightTheme = '(test $variant = light && echo true || echo false) | sponge $HOME/.config/lazygit/config.yml
	git config --global delta.syntax-theme (test $variant = light && echo OneHalfLight || echo OneHalfDark)
	set vscodesettings "$HOME/.config/Code/User/settings.json"
	jq (echo -s '."workbench.colorTheme" = ."workbench.preferred' $varianttitlecase 'ColorTheme"') < $vscodesettings | sponge $vscodesettings
    # update wallpaper
    cp $HOME/.config/wallpaper-$variant.png $HOME/.config/wallpaper.png
    # reload wallpaper & polybar
    i3-msg restart
end
