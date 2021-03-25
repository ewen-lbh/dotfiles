function declare-function --description "Creates a new function in ~/.config/fish/functions/$argv[1].fish"
	nvim ~/.config/fish/functions/$argv[1].fish
end
