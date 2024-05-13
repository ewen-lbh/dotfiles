function up
# System
paru
# NodeJS
pnpm up -g
# Rust toolchain
rustup update
# Go
gup update
# Python
pipxu upgrade --all
# OCaml
opam update
opam upgrade
# Github CLI
gh extension upgrade --all
# Rust
cargo install-update -a
# Ruby
gem update
# Fish
fisher update
# Hyprland plugins
hyprpm update
end
