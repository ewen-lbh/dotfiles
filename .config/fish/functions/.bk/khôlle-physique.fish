function khôlle-physique --description "Like khôlle-math, but for physics"
	set --local offset 11
	set --local index (math (date --date=(khôlle-next-date physique) +%V) "+ $offset")
	set --local filename "$HOME/rb/physique/khôlles/"(printf "%02d" $index)".pdf"
	if not test -e "$filename"
		~/rb/physique/khôlles/update.fish
	end
	if not test -e "$filename"
		echo "ERROR: The khôlle programme for week #$index is still not up!"
		return 1
	else
		openpdf "$filename"
	end
end
