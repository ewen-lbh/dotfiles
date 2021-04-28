function bw-register --description "bw-register URL LOGIN [NAME [PASS]]"
	set --local sessionkey (bw unlock --raw)
	bw get template item --session $sessionkey \
	| jq  '
		.login = {} 
		| .login.uris = [] 
		| .login.uris[0] = {}
		| .login.uris[0].match = null
		| .login.uris[0].uri = "'"$argv[1]"'"
		| .login.username = "'"$argv[2]"'" 
		| .login.password = "'(test (count $argv) -ge 5 && echo "$argv[5]" || passphrase -d)'" 
		| .notes = "" 
		| .name = "'(test (count $argv) -ge 3 && echo "$argv[3]" || echo "$argv[1]")'"
	' \
	| base64  \
	| bw create item --session $sessionkey \
	| jq '.login.password' --raw-output \
	| xclip -selection clipboard \
end

