function _pure_prompt_time --description "Display current local time"
    set --local localtime (date +%H:%M)
    set --local time_color (_pure_set_color $pure_color_time)
    echo -n $time_color$localtime
end
