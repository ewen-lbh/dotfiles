function sun-is-up
	set data (curl -s https://api.sunrise-sunset.org/json\?lat=$HERE_LAT\&lng=$HERE_LNG\&formatted=0 | jq .results)
	set sunrise (date --date=(echo "$data" | jq .sunrise -r) +%s)
	set sunset (date --date=(echo "$data" | jq .sunset -r) +%s)
	set now (date +%s)
	test $sunset -gt $now -a $sunrise -lt $now
end
