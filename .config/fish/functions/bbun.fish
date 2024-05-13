function bbun --wraps=bun
for arg in $argv
if not echo $arg | string match -re '[+-][\w-]+'
bun $argv[1..]
return
end
end
for arg in $argv
printf '"%s"\n' $arg
if echo $arg | string match -re '\+.+'
bun add -- (echo $arg | string trim -c '+' --left )
else
bun remove -- (echo $arg | string trim -c '-' --left )
end
end
end
