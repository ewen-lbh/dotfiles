function _pure_prompt \
    --description 'Print prompt symbol' \
    --argument-names exit_code

    set --local jobs (_pure_prompt_jobs)
    set --local vimode_indicator (_pure_prompt_vimode) # vi-mode indicator
    set --local time (_pure_prompt_time)
    set --local pure_symbol (_pure_prompt_symbol $exit_code)

    echo (_pure_print_prompt $time $jobs $vimode_indicator $pure_symbol)
end
