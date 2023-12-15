ip addr show up | grep "inet " | tail -n1 | rg -o "([0-9])*\.([0-9])*\.([0-9])*\.([0-9])*/[0-9][0-9]" | head -n1
