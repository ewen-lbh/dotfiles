function portedit
	test -f ~/projects/$argv[1]/.ortfo/description.md || ortfodb ~/projects add $argv[1] && $EDITOR ~/projects/$argv[1]/.ortfo/description.md
end
