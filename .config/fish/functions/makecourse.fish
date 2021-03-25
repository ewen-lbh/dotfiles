function makecourse
	set --local chapter "$argv[1]"
	set --local slug (python -c "import slugify; print(slugify.slugify('$chapter'))")
	if not test -d .normalized-$slug
		mkdir .normalized-$slug
	end

	for file in (find -maxdepth 1 -iname "$chapter cours *.pdf" | sort)
		echo "-> Normalizing $file..."
		pdftocairo -paper A4 -pdf -expand "$file" ".normalized-$slug/$file"
		echo "-> Deleting source"
		rm "$file"
	end

	if not test -d $slug
		mkdir $slug
	end

	echo "-> Uniting to $slug/cours.pdf..."
	pdfunite .normalized-$slug/*.pdf $slug/cours.pdf
	echo "-> Cleaning up..."
	rm -r .normalized-$slug
end
