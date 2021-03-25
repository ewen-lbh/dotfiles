set fail 1

function _pure_prompt_current_folder --argument-names current_prompt_width
    source ~/.config/fish/conf.d/_path_symbols.fish


    if test -z "$current_prompt_width"; return $fail; end

    set --local current_folder (_pure_parse_directory (math $COLUMNS - $current_prompt_width - 1))
    
    set --local current_folder (
        pwd -P \
        | sed "s|/mnt/d/projects/music|$path_symbol_music_projects_dir|" \
        | sed "s|/mnt/d/projects/.archived|$path_symbol_archived_projects_dir|" \
        | sed "s|/mnt/d/projects|$path_symbol_projects_dir|" \
        | sed "s|/mnt/d/resources|$path_symbol_resources_dir|" \
        | sed "s|/mnt/c/Users/ewenl|$path_symbol_windows_home|" \
        | sed "s|/mnt/d|$path_symbol_data_drive|" \
        | sed "s|/mnt/c|$path_symbol_os_drive|" \
        | sed "s|/||"
    )
    
    set --local current_folder_color (_pure_set_color $pure_color_current_directory)

    echo "$current_folder_color$current_folder"
end
