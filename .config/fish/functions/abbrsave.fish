function abbrsave --wraps=abbr
abbr $argv
echo "abbr $argv" >> ~/.config/fish/config.fish
end
