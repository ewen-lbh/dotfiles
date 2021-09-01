function shebang
for file in $argv[2..]
printf "%s\n%s\n" "#!/usr/bin/env $argv[1]" ""(cat $file)"" > $file
chmod +x $file
end
end
