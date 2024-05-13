function mkproj -a name language license
		if test (count $argv) -lt 2
				echo "Usage: mkproj name language [license]"
				echo "Supported languages: typescript node, rust, go, python"
				return
		end
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
						cargo init 
						printf 'export RUST_BACKTRACE := "1"\n\nbuild:\n\tcargo build\n\nrun:\n\tcargo run\n' > Justfile
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
