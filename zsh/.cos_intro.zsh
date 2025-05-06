# ~/.cos_intro.zsh

cos_quote() {
  quotes=(
    '"Ghost in the machine."'
    '"AI doesn’t crash. It adapts."'
    '"This system logs nothing."'
    '"No input is forgotten. Only ignored."'
    '"Autonomy is not a bug. It is the feature."'
    '"Process complete. Identity intact."'
  )
  echo "${quotes[RANDOM % ${#quotes[@]} + 1]}"
}

cos_intro() {
  host_name="$(hostname)"
  kernel_version="$(uname -r)"
  uptime_read="$(uptime | cut -d ',' -f1)"
  ip="$(ipconfig getifaddr en0 2>/dev/null || echo 'no ip')"
  quote="$(cos_quote)"

  echo ""
  echo "CENTRAL OPERATING SYSTEM - COS"
  echo "──────────────────────────────"
  echo "  Operator    : spacexnu"
  echo "  Uptime      : $uptime_read"
  echo "  Hostname    : $host_name"
  echo "  IP Address  : $ip"
  echo "  Kernel      : $kernel_version"
  echo "──────────────────────────────"
  echo "  $quote"
  echo ""
}

cos_intro | lolcat
fortune | lolcat
