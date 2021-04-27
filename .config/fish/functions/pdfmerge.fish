function pdfmerge --description "Like podofomerge, but can take more than two arguments"
	if test (count $argv) -lt 3
		echo "Pass at least three arguments"
		return 1
	end
	set --local buffer (mktemp --directory ./pdfmerge-stash-XXXXX)
	podofomerge "$argv[1]" "$argv[2]" $buffer/2.pdf 2>/dev/null
	for i in (seq 2 (math (count $argv) - 1))
		echo "Iter #$i: Merging $buffer/$i.pdf and $argv[$i]"
		podofomerge $buffer/$i.pdf "$argv[$i]" $buffer/(math "$i+1").pdf 2>/dev/null
	end
	pdftocairo -pdf -paper A4 -expand $buffer/(math (count $argv) - 1).pdf $argv[-1]
	rm -r $buffer/
end

