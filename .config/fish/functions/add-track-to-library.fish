function add-track-to-library
echo -e "$argv[1]\t$argv[2]" >> ~/music/library.tsv
~/music/backup 
end
