function _mutate_toml
    tomlq -t (string join '|' $argv[2..]) $argv[1] < $argv[1] | sponge $argv[1]
end

function _mutate_json
    jq -i (string join '|' $argv[2..]) $argv[1] 
end

set description  "new-code-project NAME TECH [[OWNER/]REPO] [-d DESC] [-# TAG]... [--private]"

function new-code-project --description "$description"
    if test (count $argv) -eq 1 -a $argv[1] = "--help"
	    echo $description
	    return
    end
    argparse --name=new-code-project \
        'h/help'\
        'd/description='\
        't/tags=+'\
        'p/private'\
        'l/license='\
        'v/verbose'\
        'library'\
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

        case rust
            cargo new --name $name ./$repo (test (count $_flag_library) -gt 0 && echo --lib)
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
            # add Makefile
            echo -e "default:\n\tcargo build --release\n\ninstall:\n\tsudo cp -i target/release/$name /usr/bin/\n\tsudo chmod +x /usr/bin/$name" > Makefile

        case go
            go mod init ./$repo
            cd $repo
            gitignore go
            # add Makefile
            echo -e "default:\n\tgo build\n\ninstall:\n\tsudo cp -i $name /usr/bin/\n\tsudo chmod +x /usr/bin/$name" > Makefile

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
            echo $tech is not implemented. Available technologies: python, rust, go, javascript
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

    # portfoliodb
    mkdir .portfoliodb
    set --local today (date --iso-8601)
    echo "---
    created: $today
    made with: [$tech]
    wip: yes
    ----

    # $name

    :: fr

    [Code source](https://github.com/$owner/$repo)

    :: en

    [Source code](https://github.com/$owner/$repo)
    " > .portfoliodb/description.md



    # publish to gh!
    git init # git init is idempotent, so it's fine if some language already inits (and does potentially other stuff involving git)
    gh repo create $owner/$repo --description "$description" (test "$_flag_p" && echo "--private" || echo "--public")
    # add topics to repo (temp file needed: see https://github.com/cli/cli/issues/1484)
    echo -s '{"names": ' (echo "$tags_json" | string lower) '}' > tempreq.json \
       && gh api --preview mercy repos/:owner/:repo/topics -X PUT --input tempreq.json \
       && rm tempreq.json
    # in case some language's creation process already commits an initial commit
    if not git log 2>/dev/null
        git add .
        git commit -m "🎉 Initial commit"
    end
    git push -u origin main
end
