function cointoss --description "Tosses N coins (defaults to 1)"
	for i in (seq 1 $argv[1])
		printf "%s " (random choice heads tails)
	end
	printf "\n"
end 

