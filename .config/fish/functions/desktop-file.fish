function desktop-file
echo "[Desktop Entry]
Name=$argv[2]
Comment=$argv[3]
Exec=$argv[1]
Type=Application
Terminal=false
Icon=$argv[4]
NoDisplay=false"
end
