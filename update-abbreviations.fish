#!/usr/bin/env fish

abbr --show >> abbreviations.fish
cat abbreviations.fish | awk '!seen[$0]++' | sponge abbreviations.fish
