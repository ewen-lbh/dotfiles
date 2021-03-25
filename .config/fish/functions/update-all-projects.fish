function update-all-projects --description "Run git pull on all ~/projects folders with a .git folder"
	for project in ~/projects/*
		if test -d "$project"
			if test -e "$project/.git"
				echo "PROJECT:" (basename "$project")
				cd "$project"
				git pull
				cd ..
				echo "==========================================================================="
			end
		end
	end
end
