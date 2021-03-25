function 4cc 
	curl https://a.4cdn.org/c/catalog.json | jq "[.[].threads[] | {title: .sub?, post: (.last_replies[]? | { img: ((.tim? | tostring) + .ext?), comment: .com? })}]" | jq '[.[] | "<h2>\(.title)</h2><img src=https://i.4cdn.org/c/\(.post.img) />"] | join("<hr>")' > 4cc.html && echo "<style>img{max-width:100vw}</style>" >> 4cc.html && $BROWSER 4cc.html && sleep 2 && rm 4cc.html
end

