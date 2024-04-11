complete -c portedit -e
complete -c portedit -f -a (echo ~/projects/* | string split ' ' | xargs -I@ basename @ | string join ' ') 
