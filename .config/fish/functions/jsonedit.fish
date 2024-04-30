function jsonedit
set file $argv[1]
jq $argv[2] < $file | sponge $file
end
