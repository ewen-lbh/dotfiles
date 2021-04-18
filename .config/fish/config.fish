# if removed, autosetting of wal theme does not work (wal -r is deprecated)
cat ~/.cache/wal/sequences &

# Add things to the PATH
# set -gx PATH $PATH /home/ewen/.yarn/bin /usr/local/texlive/2020/bin/x86_64-linux /home/ewen/.gem/ruby/2.7.0

# Set bat(1)'s theme
alias bat="bat --theme (test (cat $HOME/.config/current_color_scheme) = light && echo OneHalfLight || echo OneHalfDark)"

# Set default browser
set -gx BROWSER qutebrowser
xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/http{s,}

set -gx EDITOR /usr/bin/nvim
# 
# Set tab width
tabs -4
# man(1) syntax highlighting
set -xU LESS_TERMCAP_md (printf "\e[01;31m")
set -xU LESS_TERMCAP_me (printf "\e[0m")
set -xU LESS_TERMCAP_se (printf "\e[0m")
set -xU LESS_TERMCAP_so (printf "\e[01;44;33m")
set -xU LESS_TERMCAP_ue (printf "\e[0m")
set -xU LESS_TERMCAP_us (printf "\e[01;32m")
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
# starship prompt
starship init fish | source
# alias gcal='gcalcli agenda --details description --details end --details location'
# lsd configuration
# alias lsd 'lsd --group-dirs first --date +"%Y-%m-%d %H:%M" --blocks permission,name,size,date --no-symlink'
alias lsd 'lsd --group-dirs first --date +"%Y-%m-%d %H:%M"'

# opam configuration
source /home/ewen/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# devour some programs (window swallowing, see https://youtu.be/mBNLzHcUtTo)
for program in zathura mpv sxiv vlc qimgv
	alias $program "devour $program"
end

# fix utf-8 for lynx
alias lynx "lynx --display_charset=utf-8"
# ideaseed alias
alias idea='ideaseed --auth-cache=\'/home/ewen/.cache/ideaseed/auth.json\' --check-for-updates --self-assign --default-project=\'{repository}\' --default-column=todo --create-missing'

thefuck --alias | source
