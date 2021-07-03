#!/usr/bin/env fish
# vim: set tabstop=2 :
# vim: set shiftwidth=2 :
# vim: set noexpandtab :

set -l initialwd (pwd)
set -l commands ()
set -l names ""

for d in (status dirname)/*
	if test -d $d
		cd $d
		if test -d .git 
			set commands $commands "cd $d; git fetch; git pull; git push"
			set names "$names,"(basename $d)
		end
		cd "$initialwd"
	end
end

concurrently $commands --names $names
