function is-xinput-device-enabled
	set --local device $argv[1]
	test (xinput list-props $device | rg 'Device Enabled' | cut -d':' -f2 | string trim) = 1
end

