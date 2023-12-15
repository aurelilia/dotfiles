dunstctl history | jq '.data[0] | .[] | {body: .body.data, title: .summary.data}' | jq -n '[inputs]'
