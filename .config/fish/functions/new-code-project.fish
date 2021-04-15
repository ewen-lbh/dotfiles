function _mutate_toml
    tomlq (string join '|' $argv[2..]) -t < $argv[1] | sponge $argv[1]
end

function _mutate_json
    jq (string join '|' $argv[2..]) < $argv[1] | sponge $argv[1]
end


function new-code-project --description "new-code-project NAME TECH [[OWNER/]REPO] [-d DESC] [-# TAG]... [--private]"
    argparse --name=new-code-project \
        'h/help'\
        'd/description='\
        't/tags=+'\
        'p/private'\
        'l/license='\
        'v/verbose'\
        'dry-run'\
    -- $argv; or return

    set --local name $argv[1]
    if test $name = "js"
        set name javascript
    end
    set --local tech $argv[2]
    # set --local owner (gh api user | jq .login --raw-output)
    set --local owner ewen-lbh
    set --local repo "$name"
    set --local desc "$_flag_d"
    set --local license (test (count "$_flag_l") -gt 0 && echo "$_flag_l" || echo "GPL-3.0")
    set --local tags $_flag_t
    set --local tags_json (echo -s "[\"" (echo $_flag_t | string replace --all ' ' '", "') "\"]")

    if test (count $argv) -ge 3
        if echo $argv[3] | grep /
            set owner (echo $argv[3] | cut -d/ -f1)
            set repo (echo $argv[3] | cut -d/ -f2)
        else
            set repo $argv[3]
        end
    end

    if test (count $_flag_v) -gt 0
        echo "Project{ "
        echo "    name: \"$name\","
        echo "    repository: $owner/$repo,"
        echo "    path: $HOME/projects/$repo,"
        echo "    description: \"$desc\","
        echo "    license: \"$license\","
        echo "    tags: $tags_json," 
        echo "    private:" (test (count $_flag_p) -gt 0 && echo "true" || echo "false") ","
        echo "}"
    end

    if test (count $_flag_dry_run) -gt 0
        return
    end

    cd $HOME/projects || return 1

    switch $tech
        case python
            poetry new --name $name ./$repo --no-interaction
            cd $repo
            _mutate_toml pyproject.toml \
               ".tool.poetry.description = \"$description\"" \
               ".tool.poetry.license = \"$license\"" \
               ".tool.poetry.readme = \"README.md\"" \
               ".tool.poetry.repository = \"https://github.com/$owner/$repo\"" 

            poetry add --dev --allow-prereleases black pylint isort rich 
            gitignore python
            git init

        case rust
            cargo new --name $name ./$repo 
            cd $repo
            _mutate_toml Cargo.toml \
                ".package.description = \"$description\"" \
                ".package.license = \"$license\" " \
                ".package.\"license-file\" = \"LICENSE\"" \
                ".package.readme = \"README.md\" " \
                ".package.repository = \"https://github.com/$owner/$repo\"" \
                ".package.keywords = $tags_json" 

        case go
            go mod init ./$repo

        case javascript
            mkdir ./$repo
            cd $repo
            pnpm init --yes
            _mutate_json package.json \
                ".name = \"$name\"" \
                ".description = \"$description\"" \
                ".keywords = $tags_json" \
                ".homepage = \"https://github.com/$owner/$repo\"" \
                ".license = \"$license\"" \
                (echo -s ".author = \"" (git config user.name) " <" (git config user.email) ">" "\"")

        case '*'
            echo $tech is not implemented.
            return 1
    end

    # create license
    cd $HOME/projects/$repo || return 1
    if licensor -l | grep "$license"
        # no --raw-output so that it's quoted!
        licensor $license (git config user.name) > LICENSE
    end

    # publish to gh!
    gh repo create $owner/$repo --description "$desc" (test "$_flag_p" && echo "--private" || echo "--public")
end
