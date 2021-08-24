function bak
for thing in $argv
if test -f $thing.bak
echo a backup already exists. delete it first
return 1
else
mv $thing $thing.bak
end
end
end
