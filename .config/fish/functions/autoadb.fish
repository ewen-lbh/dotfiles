function autoadb
set port (nmap 192.168.1.24 -p 37000-44000 -oG - | grep -P '\d+(?=\/open\/tcp)' --only-matching)
adb connect 192.168.1.24:$port
end
