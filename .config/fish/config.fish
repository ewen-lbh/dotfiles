if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH


#  toulouse:	43° 36′ 16″ nord, 1° 26′ 38″ est
set -Ux LOCATION_LATITUDE 43.604444444
set -Ux LOCATION_LONGITUDE 1.443888889

function dbg
end

dbg zoxide
zoxide init fish | source

# pnpm
set -gx PNPM_HOME "/home/uwun/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

abbr lg lazygit
abbr :q exit
abbr v nvim
abbr gj gitmoji -c
abbr oadd ortfodb -c ~/projects/portfolio/ortfodb.yaml add 
abbr wlc wl-copy
abbr wlp wl-paste

# env vars
set -gx EDITOR nvim

dbg opam
# opam configuration
source /home/uwun/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

dbg starship
eval (starship init fish)
fish_add_path /home/uwun/.spicetify

# vscode shell integration
dbg vscode shell integration
# https://code.visualstudio.com/docs/terminal/shell-integration#_manual-installation
string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)
abbr glab GL_HOST=git.inpt.fr glab

set -gx LD_LIBRARY_PATH "$LD_LIBRARY_PATH:~/.local/lib/mojo"

dbg kubebuilder
source (kubebuilder completion fish | psub)

dbg ortfodb
ortfodb completion fish | source

abbr cha chachacha
abbr +x chmod +x
abbr ncdu gdu
abbr kap kubectl apply -f
abbr fze 'nvim (fzf)'
abbr kubeseal kubeseal -o yaml
