function khôlle-next-date
	set --local subject "$argv[1]"
	set --local cachefile "$HOME/.cache/khôlles-schedules/$subject.tsv"
	if test (count $argv) -ge 2; and test $argv[2] = "cleancache"
		rm "$cachefile"
	end
	if not test -e "$cachefile"
		gcalcli search "Khôlle $subject" (date --iso-8601 ) --tsv --military > "$cachefile"
	end
	cat "$cachefile" | head -n1 | cut -f 1
end

