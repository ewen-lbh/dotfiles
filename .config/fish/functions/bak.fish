function bak --description "Copies given file to a new one with a .bak at the end"
	for file in $argv
		cp -r "$file" "$file.bak"
	end
end

