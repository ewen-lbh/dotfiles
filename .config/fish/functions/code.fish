function code --description "Clone with gclone if the given first argument is not an existing file (directory or not)"
    set --local name "$argv[1]"
    if not test -e $name
        gclone $name
    end
    code-insiders $argv
end
