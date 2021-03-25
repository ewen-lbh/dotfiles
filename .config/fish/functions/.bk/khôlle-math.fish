function khôlle-math --description "gets the next khôlle of math's programme"
	# Khôlles are indexed by week number, with an offset of +11 relative to the ISO week number.
	# This computes the next khôlle's index by:
	# - getting the next khôlle's date (see ./khôlle-next-date.fish)
	# - getting its ISO week number via `date`
	# - adding the offset
	set --local offset 11
	set --local index (math (date --date=(khôlle-next-date math) +%V) "+ $offset")
	set --local url http://mpsi.daudet.free.fr/maths/kholles/Kholles_Maths_MPSI_S{$index}.pdf
	set --local localfile $HOME/rocketbook/math/khôlles/$index-sujet.pdf
	if test -e $localfile
		openpdf $localfile
	else if test (http head "$url" --print h | head -n1 | cut -d" " -f 2) = "300"
		openpdf $url
		wget $url -O $localfile
	else
		echo "ERROR: The khôlle programme for week #$index is still not up! (tried $url)"
	end
end
