dunstctl history | jq '.data[0] | .[] | {app: .appname.data, body: .body.data, title: .summary.data}' | jq -n '[inputs]'
