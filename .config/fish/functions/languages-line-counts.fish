function languages-line-counts
	for lang in py rb rs go ls ts js coffee pug html stylus sass scss css php fish nim 
		set total 0
		for f in (fd ".$lang\$" $argv[1])
			if test -f $f
				set total (math $total + (wc -l < $f))
			end
		end
		echo $total \t $lang
	end | sort -h -r
end

