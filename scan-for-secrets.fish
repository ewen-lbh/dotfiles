#!/usr/bin/env fish

function scan
	set --local scan_results (detect-secrets scan --all-files --exclude-files dotbot/  | jq '.results')
	if test (echo $scan_results | jq '. | length') != 0
		echo !!!!!!SECRETS DETECTED!!!!!!
		echo $scan_results | jq
		echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!
		return 1
	else
		return 0
	end
end

scan
