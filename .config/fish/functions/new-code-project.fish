function new-code-project --description "new-code-project NAME TECH [[OWNER/]REPO] [-d DESC] [-# TAG]... [--private]"
    set --local current_pwd (pwd)
    argparse --name=new-code-project 'h/help' 'd/description=' 't/tags=+' 'p/private' 'l/license' -- $argv; or return
    set --local name $argv[1]
    set --local tech $argv[2]
    set --local owner (gh api user | jq .login --raw-output)
    set --local repo "$name"
    set --local desc "$_flag_d"
    set --local license "$_flag_l"
    if test (count $argv) -ge 3
        if echo $argv[3] | grep /
            set owner (echo $argv[3] | cut -d/ -f1)
            set repo (echo $argv[3] | cut -d/ -f2)
        else
            set repo $argv[3]
        end
    end
    cd $HOME/projects
    switch $tech
        case python
            poetry new --name $name ./$repo --no-interaction
            # set name
            tomlq .tool.poetry.description="$desc" -t < $repo/pyproject.toml | sponge $repo/pyproject.toml
            tomlq .tool.poetry.license="$license" -t < $repo/pyproject.toml | sponge $repo/pyproject.toml
            tomlq .tool.poetry.="$license" -t < $repo/pyproject.toml | sponge $repo/pyproject.toml
            cd $repo
            poetry add --dev --allow-prereleases black pylint isort rich 
            cd ..
        case rust
            cargo new --name $name ./$repo 
    end
    # publish to gh!
    cd $repo
    gh repo create $owner/$repo --description "$desc" (test "$_flag_p" && echo "--private" || echo "--public")
    cd "$current_pwd"
end
