function shebang --description "Adds a #!/usr/bin/env <program> atop the given <file>. Usage: shebang <program> <file>..."
	for file in $argv[2..]
		printf '%s\n%s\n' "#!/usr/bin/env $argv[1]" ""(cat $file)"" > $file
		chmod +x $file
	end
end

