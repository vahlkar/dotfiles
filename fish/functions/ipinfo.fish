function ipinfo
    curl -s 'https://ipinfo.io/' | jq -r '.ip'
end
