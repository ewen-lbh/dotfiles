function edit-json
	jq $argv[2] $argv[1] | sponge $argv[1]
end

function colorswitch
	if test $argv[1] = "dark"
		set variant mocha
		set Variant Mocha
		set DarkOrLight Dark
		set darkOrLight dark
		set contrast_color white
	else
		set variant latte
		set Variant Latte
		set DarkOrLight Light
		set darkOrLight light
		set contrast_color black
	end

	# Others
	echo $argv[1] > ~/.config/colorscheme

	# Waybar's custom logo
	set waybar_config "$HOME/.config/waybar"
	rm $waybar_config/net7.png
	ln -s $waybar_config/net7-$contrast_color.png $waybar_config/net7.png
	killall waybar
	waybar & disown

	# Wallpaper (hyprpaper)
	sed -i "s|^wallpaper = .*\$|wallpaper = ,$HOME/.config/wallpaper-$darkOrLight.png|" $HOME/.config/hypr/hyprpaper.conf
	killall hyprpaper
	hyprpaper &>/dev/null & disown


	# Kitty
	kitten themes --reload-in=all "Catppuccin-$variant"

	# Fish
	yes | fish_config theme save "Catppuccin $Variant" 

	# Lazygit
	set lazygit_config_dir (lazygit --print-config-dir)
	set -ge LG_CONFIG_FILE
	set -Ux LG_CONFIG_FILE "$lazygit_config_dir/config.yml,$lazygit_config_dir/$variant.yml"

	# Dunst
	killall dunst &>/dev/null
	set dunst_config_dir "$HOME/.config/dunst"
	cat $dunst_config_dir/base.conf $dunst_config_dir/$variant.conf > $dunst_config_dir/dunstrc
	dunst &>/dev/null & disown

	# Bat
	set -ge BAT_THEME
	set -Ux BAT_THEME "Catppuccin-$variant"

	# VS Code
	set vscode_settings "$HOME/.config/Code/User/settings.json"
	edit-json $vscode_settings \
		".workbench.colorTheme = .\"workbench.preferred$(echo $DarkOrLight)ColorTheme\"" $vscode_settings
	edit-json $vscode_settings \
		".workbench.iconTheme = \"catppuccin-$variant\""  

	# (Better)Discord
	set betterdiscord_themes_config "$HOME/.config/BetterDiscord/data/stable/themes.json"
	edit-json $betterdiscord_themes_config \
		"map_values(false) | .\"Catppuccin $Variant\" = true" 
	betterdiscordctl &>/dev/null reinstall
	discord &>/dev/null & disown
end
