#!/usr/bin/env fish
# vim: set tabstop=2 :

function _git_is_ahead
	set ahead_or_behind (git status -uno | rg -o 'Your branch is (behind|ahead)' -r '$1') 
	test "$ahead_or_behind" = "ahead"
end

function _git_is_behind
	set ahead_or_behind (git status -uno | rg -o 'Your branch is (behind|ahead)' -r '$1') 
	test "$ahead_or_behind" = "behind"
end

set -l separator "-----------------------------------------------------------------------------"

for d in *
	if test -d $d
		cd $d
		if test -d .git 
			if _git_is_behind
							echo "$d: pulling"
							git pull
							echo $separator
			else if _git_is_ahead
							echo "$d: pushing"
							git push
							echo $separator
			end
		end
		cd ..
	end
end
