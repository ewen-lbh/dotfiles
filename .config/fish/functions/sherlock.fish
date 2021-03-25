function sherlock
	set -l wd (pwd)
	cd ~/apps/sherlock
	poetry run python sherlock $argv
	cd "$wd"
end
