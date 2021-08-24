function chext
for file in $argv[2..]
mv $file (echo $file | sed -E 's/\.\w+$//').(echo $argv[1] | sed -E 's/^\.+//')
end
end
