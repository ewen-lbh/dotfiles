function khôlle-math-qc --description "gets the next math khôlle's course questions programme"
	set --local offset 11
	set --local index (math (date --date=(khôlle-next-date math) +%V) "+ $offset")
	set --local url http://mpsi.daudet.free.fr/maths/kholles/Kholles_Maths_MPSI_S{$index}_QC.pdf
	set --local localfile $HOME/rocketbook/math/khôlles/$index-qc-sujet.pdf
	if test -e $localfile
		echo $localfile
		openpdf $localfile
	else if test (http head "$url" --print h | head -n1 | cut -d" " -f 2) = "300"
		openpdf $url
		wget $url -O $localfile
	else
		echo "ERROR: The khôlle programme for week #$index is still not up! (tried $url)"
	end
end
