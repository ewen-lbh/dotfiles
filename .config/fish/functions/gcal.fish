function gcal --description "Shows a gcal thru less for events in the next N days (give N as argument)"
	gcalcli agenda --details description --details location --details end (date --iso-8601) (date --iso-8601 -d "+$argv[1] days") | less -r
end
