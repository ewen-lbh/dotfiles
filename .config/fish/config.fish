if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

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
abbr yay paru
abbr up "paru && paru -R emacs"

# opam configuration
source /home/uwun/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

eval (starship init fish)
fish_add_path /home/uwun/.spicetify


abbr bunr bun --bun run
abbr glab GL_HOST=git.inpt.fr glab
