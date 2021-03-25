function gitignore --description "Creates a gitignore file using gitignore.io's Web API"
    set -l langlist (echo $argv | string split ' ' | string join ',')
    echo $langlist
    wget https://gitignore.io/api/$langlist -O .gitignore
    echo -ne "\n# Environment variables\n.env" >> .gitignore
end
