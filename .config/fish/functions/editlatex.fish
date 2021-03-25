function editlatex --description "Start live compilation, preview and open vim on given LaTeX file"
    set -l filename $argv[1]
    if not test -f $filename
        echo "File not found."; return 1
    end
    set -l filedirectory (dirname (readlink -f $filename))
    kitty @ launch --type=tab --tab-title="Compiliation: $filename" --keep-focus fish -c "cd $filedirectory; latexmk -pvc $filename"
    nvim $filename
end
