function mkproj -a name language license
		set name $argv[1]
		set lang $argv[2]
		set license $argv[3]
		if test -z $license
				set license MIT
		end
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
						printf 'build:\n\tgo mod tidy\n\tgo build -o %s main.go\n' $name > Justfile
						printf '\ninstall:\n\tjust build\n\tcp %s ~/.local/bin\n' $name >> Justfile
				case python
						poetry init --name $name
						poetry shell
		end
		create-gitignore $lang
		if test $lang = go
				echo /$name >> .gitignore
		end
		licensor $license > LICENSE
		git init
		git add .
		git commit -m "🎉 Initial commit"
		gh repo create --source . --public ewen-lbh/$name
		git push -u origin main
		code .; exit
end
