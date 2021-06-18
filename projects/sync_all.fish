#!/usr/bin/env fish
# vim: set tabstop=2 :
# vim: set shiftwidth=2 :
# vim: set noexpandtab :

function _git_is_ahead
	set ahead_or_behind (git status -uno | rg -o 'Your branch is (behind|ahead)' -r '$1') 
	test "$ahead_or_behind" = "ahead"
end

function _git_is_behind
	set ahead_or_behind (git status -uno | rg -o 'Your branch is (behind|ahead)' -r '$1') 
	test "$ahead_or_behind" = "behind"
end

set -l separator "-----------------------------------------------------------------------------"
set -l initialwd (pwd)

for d in (status dirname)/*
	if test -d $d
		cd $d
		if test -d .git 
			set_color --dim
			echo "$d: fetching"
			set_color normal
			git fetch
			if _git_is_behind
				set_color magenta --reverse --bold 
				echo "$d: pulling"
				set_color normal
				git pull
				echo $separator
			else if _git_is_ahead
				set_color magenta --reverse --bold 
				echo "$d: pushing"
				set_color normal
				git push
				echo $separator
			end
		end
		cd "$initialwd"
	end
end
