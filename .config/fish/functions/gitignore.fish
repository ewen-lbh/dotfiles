function gitignore
for arg in $argv
echo $arg >> (git rev-parse --show-toplevel)/.gitignore
end
end
