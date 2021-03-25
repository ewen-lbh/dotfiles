function wikitrans --description "translates a term via Wikipedia"
	set --local source $argv[1]
	set --local target $argv[2]
	set --local word $argv[3]
	set --local source_page (curl -s "https://$source.wikipedia.org/wiki/$word")
	echo "$source_page"
end
