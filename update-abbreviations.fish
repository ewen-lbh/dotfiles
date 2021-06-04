#!/usr/bin/env fish

abbr --show | cat abbreviations.fish | awk '!seen[$0]++' | sponge abbreviations.fish
