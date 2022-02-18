function gitignore --description "Adds arguments to gitignore"
	for arg in $argv
		echo $argv >> .gitignore
	end
end
