function random-xkcd
set url https:(curl -fsSL https://c.xkcd.com/random/comic/ | htmlq '#comic img' --attribute src)
wget --quiet $url -O ~/.cache/xkcd/(path basename $url)
kitty +kitten icat ~/.cache/xkcd/(path basename $url)
end
