function openpdf
	if test -f "$argv[1]"
		set file "$argv[1]"
	else
		set file (mktemp /tmp/XXXXXXXXX.pdf)
		wget "$argv[1]" -O $file --quiet
	end
	# no disown madness as zathura windows get swallowed
	zathura "$file"
end
