function mkproj
		set name $argv[1]
		set lang $argv[2]
		cd ~/projects
		mkdir $name
		cd $name
		switch $lang
				case typescript node
						bun init
				case rust
						cargo new . --name $name
				case go
						go mod init github.com/ewen-lbh/$name
						echo 'package main' > main.go
						printf 'build:\n\tgo mod tidy\n\tgo build main.go -o %s\n' $name > Justfile
						printf '\ninstall:\n\tjust build\n\tcp %s ~/.local/bin\n' $name >> Justfile
				case python
						poetry init --name $name
						poetry shell
		end
		create-gitignore $lang
		git init
		git add .
		git commit -m "🎉 Initial commit"
		gh repo create --source . --public ewen-lbh/$name
		git push -u origin main
end
