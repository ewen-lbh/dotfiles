filename="$HOME/screenshots/$(date --iso-8601).png"


grim $filename && notify-send "Screenshot saved to $filename"
