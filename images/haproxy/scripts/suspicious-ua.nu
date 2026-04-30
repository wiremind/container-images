#!/usr/bin/env nu

# Script to download and extract suspicious HTTP user agents from a CSV file
# hosted on GitHub, then save the cleaned list to a text file.

let url = "https://raw.githubusercontent.com/mthcht/awesome-lists/main/Lists/suspicious_http_user_agents_list.csv"
let dest: string = "files/suspicious-ua.txt"

http get $url
| get http_user_agent
| into string
| str replace --all '*' ''
| str trim
| where {|ua| ($ua | str length) > 2 }
| to text
| save --force $dest
