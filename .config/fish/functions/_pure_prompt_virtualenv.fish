function _pure_prompt_virtualenv --description "Display virtualenv directory"
    if test -n "$VIRTUAL_ENV"
        set --local venv_python_version (basename "$VIRTUAL_ENV" | sed -r "s|.+-\w{8}-py([0-9.]+)|\1|")
        set --local virtualenv_color (_pure_set_color $pure_color_virtualenv)

        echo -s "[" $virtualenv_color "python $venv_python_version" (set_color normal) "]"
    end
end
