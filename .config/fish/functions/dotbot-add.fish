function dotbot-add --description "Move a file over to ~/.dotfiles/TARGET, add a link entry to dotbot, run dotbot to symlink it back"
	for file in $argv
		# Move it over
		mkdir -p (dirname "$HOME/.dotfiles/$file")
		mv --verbose "$HOME/$file" "$HOME/.dotfiles/$file"

		# Add an entry
		set -l entry (echo -s '.[1].link.["~/' "$file" '"] = "' "$file" '"')
		echo "Doing $entry"
		jq (echo -s '.[1].link.["~/' "$file" '"] = "' "$file" '"') "$HOME/.dotfiles/install.conf.json" | sponge "$HOME/.dotfiles/install.conf.json"

	end
	# Symlink it back
	$HOME/.dotfiles/install -c $HOME/.dotfiles/install.conf.json
end
