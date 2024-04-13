set templates_file $HOME/.config/fish/completions/create-gitignore-templates

# only refresh gitignore templates if the file is older than 1 week
if not test -f $templates_file || test (date -r $templates_file +%s) -lt (math (date +%s) - 604800)
    echo "Refreshing gitignore templates"
	https -F gitignore.io/api/list | string join , | string split , | string join ' ' > $templates_file
end

complete -c create-gitignore -f -a (cat $templates_file)
