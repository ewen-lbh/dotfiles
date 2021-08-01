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
	cp ~/projects/abstract-wallpapers-per-color-scheme/$variant/preferred.png ~/.config/wallpaper.png
	echo $variant > $HOME/.config/current_color_scheme
	# update config files that can't update on their own
	# preferred is a symlink to the current wal theme (in dark/ and light/ subdirectories, see ~/.config/wal)
	wal --theme preferred (test $variant = light && echo -- -l)
	cat $HOME/.config/lazygit/config.yml | yq -Y '.gui.theme.lightTheme = '(test $variant = light && echo true || echo false) | sponge $HOME/.config/lazygit/config.yml
	git config --global delta.syntax-theme (test $variant = light && echo OneHalfLight || echo OneHalfDark)
	set vscodesettings "$HOME/.config/Code/User/settings.json"
	jq (echo -s '."workbench.colorTheme" = ."workbench.preferred' $varianttitlecase 'ColorTheme"') < $vscodesettings | sponge $vscodesettings
    # update wallpaper

    # reload wallpaper & polybar
    i3-msg restart
end
