function 8.3isgone --description "Replace silly truncated 3-characters-long extensions with their glorious, full-length counterparts"
	set -l shorts yml jpg htm tif pct mim aif mid
	set -l longs yaml jpeg html tiff pict mime aiff midi

	for shortext in $shorts
		if set -l longidx (contains -i -- $shortext $shorts)
			for filename in *.$shortext
				mv "$filename" (echo "$filename" | string replace ".$shortext" ".$longs[$longidx]") $argv
			end
		end
	end
end


