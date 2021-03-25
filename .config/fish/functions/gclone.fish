function gclone --description "git-clone(1) with smart defaults"
	set -l repo $argv[1]
	set url "https://github.com/ewen-lbh/$repo"
	echo "$repo" | grep -oE '^https?://'        && set url "$repo"
	echo "$repo" | grep -oE '^(\w+\.)?\w+\.\w+' && set url "https://$repo"
	echo "$repo" | grep -oE '[^/]+/[^/]+'       && set url "https://github.com/$repo"
	echo "Cloning $url..."
	git clone "$url" $argv[2..-1]
end
