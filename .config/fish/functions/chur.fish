function chur
set token (gql churros.inpt.fr/graphql "mutation { login(email: \"lebihae\", password: \""(rbw get bde.enseeiht.fr)"\") { ...on MutationLoginSuccess { data { token }}}}" | jq -r .login.data.token)
gql churros.inpt.fr/graphql $argv[1] "$token"
end
