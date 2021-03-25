function first-commit-date
	set --local wd (pwd)
	cd ~/projects/$argv[1]
	git log --reverse --pretty="format:%as" | head -n1
	cd $wd
end
