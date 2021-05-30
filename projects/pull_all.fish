#!/usr/bin/env fish

function _git_is_behind
	set ahead_or_behind (git status -uno | rg -o 'Your branch is (behind|ahead)' -r '$1') 
	test "$ahead_or_behind" = "behind"
end

for d in *
	if test -d $d
		cd $d
		if test -d .git && _git_is_behind
			echo "doing $d"
			echo "------------------------------------------------------------------------"
			git pull
			echo "------------------------------------------------------------------------"
		end
		cd ..
	end
end
