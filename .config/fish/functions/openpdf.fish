function openpdf
	if test -f "$argv[1]"
		set file "$argv[1]"
	else
		set file (mktemp /tmp/XXXXXXXXX.pdf)
		wget "$argv[1]" -O $file --quiet
	end
	zathura "$file" & 
	# Relies on the fact that no other zathura processes will be opened in the meantime...
	disown (pidof zathura | cut -d' ' -f1 )
end
