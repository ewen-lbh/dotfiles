function startlatex --description "Start a new LaTeX file"
    set --local cwd (pwd)
    if not test -f .template.tex
        echo -ne "No LaTeX template found. Please create it:\n\n\tnvim $cwd/.template.tex"; return 1
    end
    set --local slug (slugify "$argv")
    set --local dat (date +%Y-%m-%d)
    mkdir $slug
    cd $slug
    cp ../.template.tex "$slug.tex"
    # echo (cat "$slug.tex" | string replace '@@PROJECT@@' "$argv") > "$slug.tex"
    # echo (cat "$slug.tex" | string replace '@@DATE@@' "$dat") > "$slug.tex"
    sed -i -e "s/@@PROJECT@@/$argv/g" "$slug.tex"
    sed -i -e "s/@@DATE@@/$dat/g" "$slug.tex"
    editlatex "$slug.tex"
    cd ..
end
