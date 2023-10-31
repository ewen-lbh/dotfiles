function colorswitch
	if test $argv[1] = "dark"
		set variant mocha
		set Variant Mocha
		set DarkOrLight Dark
	else
		set variant latte
		set Variant Latte
		set DarkOrLight Light
	end

	# Others
	echo $argv[1] > ~/.config/colorscheme

	# Kitty
	kitten themes --reload-in=all "Catppuccin-$variant"

	# Fish
	yes | fish_config theme save "Catppuccin $Variant" 

	# Lazygit
	set lazygit_config_dir (lazygit --print-config-dir)
	set -Ux LG_CONFIG_FILE "$lazygit_config_dir/config.yml,$lazygit_config_dir/$variant.yml"

	# Dunst
	killall dunst 2>/dev/null
	set dunst_config_dir "$HOME/.config/dunst"
	cat $dunst_config_dir/base.conf $dunst_config_dir/$variant.conf > $dunst_config_dir/dunstrc
	dunst & disown

	# Bat
	set -Ux BAT_THEME "Catppuccin-$variant"

	# VS Code
	set vscode_settings "$HOME/.config/Code/User/settings.json"
	jq (echo -s '.workbench.colorTheme = ."workbench.preferred' $DarkOrLight 'ColorTheme"') < $vscode_settings | sponge $vscode_settings
end
