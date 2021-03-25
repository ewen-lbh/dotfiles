function todo --description "Adds a new entry to ~/todo: todo SOME TEXT"
	echo "$argv" >> ~/todo
end

function todos --description "Lists the things you need to do"
	nano ~/todo
end
