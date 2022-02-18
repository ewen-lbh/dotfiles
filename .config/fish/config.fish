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
alias ..="cd .."
for i in (seq 3 20)
	alias (string repeat -n $i ".")="cd .."(string repeat -n (math $i - 1) "/..")
end
# starship prompt
starship init fish | source
# alias gcal='gcalcli agenda --details description --details end --details location'
# lsd configuration
# alias lsd 'lsd --group-dirs first --date +"%Y-%m-%d %H:%M" --blocks permission,name,size,date --no-symlink'
alias lsd 'lsd --group-dirs first --date +"%Y-%m-%d %H:%M" --git'

# opam configuration
# source /home/ewen/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# devour some programs (window swallowing, see https://youtu.be/mBNLzHcUtTo)
for program in zathura sxiv vlc qimgv neovide neovide-kbd-fix marktext
	alias $program "devour $program"
end

# devour mpv smartly
function mpvd --wraps mpv --description "mpv that devours only for video files"
	set mpv_program (which mpv)
	set has_non_video_files false
	set has_files false
	for arg in $argv
		if test -f "$arg"
			set has_files true
			if xdg-mime query filetype "$arg" | grep --quiet --invert-match video/ 
				set has_non_video_files true
				break
			end
		end
	end
	if $has_non_video_files or not $has_files
		$mpv_program $argv
	else
		devour $mpv_program $argv
	end
end

# fix utf-8 for lynx
alias lynx "lynx --display_charset=utf-8"

# add very useful columns to lsblk
alias lsblk "lsblk -o NAME,MODEL,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINT,UUID"

# add --multiGrid
alias neovide-kbd-fix "neovide-kbd-fix --multiGrid"


thefuck --alias | source
alias idea='ideaseed --auth-cache=/home/ewen/.cache/ideaseed/auth.json --check-for-updates --self-assign --create-missing --local-copy=/home/ewen/ideas --default-project=\'{repository}\' --default-column=todo --default-user-column=willmake --default-user-project=incubator'

# duf theme
alias duf "duf -theme "(cat $HOME/.config/current_color_scheme)

set -gx PNPM_HOME "/home/ewen/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

setxkbmap -option compose:(switch $hostname; case voyager; echo "rctrl"; case stealth; echo "rwin"; end)
