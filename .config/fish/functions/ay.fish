function ay
for pkg in $argv
yay -R $pkg && sed -i "/$pkg/d" ~/.dotfiles/softs 
end
end
