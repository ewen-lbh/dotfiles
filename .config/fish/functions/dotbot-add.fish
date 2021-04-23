function dotbot-add --description "Move a file over to ~/.dotfiles/TARGET, add a link entry to dotbot, run dotbot to symlink it back"
	for file in $argv
		# Remove ~/ in front since we're gonna add it later
		echo "$file" | string replace $HOME/ ''
		# Move it over
		mkdir -p (dirname "$HOME/.dotfiles/$file")
		mv --verbose "$HOME/$file" "$HOME/.dotfiles/$file"

		# Add an entry
		echo "Doing. [1].link[\"~/$file\"] = \"$file\"" 
		jq ".[1].link[\"~/$file\"] = \"$file\"" "$HOME/.dotfiles/install.conf.json" | sponge "$HOME/.dotfiles/install.conf.json"
	end
	# Symlink it back
	$HOME/.dotfiles/install -c $HOME/.dotfiles/install.conf.json

	# TODO: Create a git commit
	# set wd (pwd)
	# cd $HOME/.dotfiles
	# git add (echo $argv | string replace $HOME $HOME/.dotconfig)
	# git commit -m "dotbot: add " (echo $argv | string join ", ")
	# cd $wd
end
