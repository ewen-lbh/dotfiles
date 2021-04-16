function _mutate_toml
    tomlq --in-place (string join '|' $argv[2..]) -t $argv[1]
end

function _mutate_json
    jq --in-place (string join '|' $argv[2..]) $argv[1] 
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
    set --local description "$_flag_d"
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
        echo "    description: \"$description\","
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
            # remove silly hello world
            echo -e "fn main() {\n    \n}\n" > src/main.rs

        case go
            go mod init ./$repo
            cd $repo
            gitignore go

        case javascript
            mkdir ./$repo
            cd $repo
            pnpm init --yes
            gitignore javascript
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

    # create editorconfig
    echo "# https://editorconfig.org

    [*]
    end_of_line = lf
    insert_final_newline = true
    charset = utf-8
    indent_style = tab

    [**.py]
    indent_style = space
    indent_size = 4

    [**.rs]
    indent_style = space
    indent_size = 4
    " | string trim > .editorconfig

    # create README
    echo "----------

    ***WARNING: This is a very early work-in-progress, nothing works yet.***

    This project uses [README-driven development](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html)
    (i.e.: I'm still figuring out how exactly that program will work)

    ----------

    # $name

    > $description

    ## Installation

    (work in progress)

    ## Usage

    (work in progress)
    " | string trim > README.md
    # publish to gh!
    git init # git init is idempotent, so it's fine if some language already inits (and does potentially other stuff involving git)
    gh repo create $owner/$repo --description "$description" (test "$_flag_p" && echo "--private" || echo "--public")
    # in case some language's creation process already commits an initial commit
    if not git log 2>/dev/null
        git add .
        git commit -m "🎉 Initial commit"
    end
    git push -u origin main
end
