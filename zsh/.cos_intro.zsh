# =============================================================================
# SHELL WELCOME MESSAGE SCRIPT
# =============================================================================
# This script displays a stylized welcome message when opening a new shell,
# showing system information and a random quote.
# Dependencies: lolcat (for colorized output), fortune (for random messages)

# -----------------------------------------------------------------------------
# Random Quote Function
# -----------------------------------------------------------------------------
# Selects and returns a random quote from the predefined list
cos_quote() {
  # Array of cyberpunk/AI-themed quotes
  quotes=(
    '"Ghost in the machine."'
    '"AI doesn’t crash. It adapts."'
    '"This system logs nothing."'
    '"No input is forgotten. Only ignored."'
    '"Autonomy is not a bug. It is the feature."'
    '"Process complete. Identity intact."'
  )
  # Select a random quote from the array
  # Note: RANDOM % array_size + 1 ensures we get a valid index
  echo "${quotes[RANDOM % ${#quotes[@]} + 1]}"
}

# -----------------------------------------------------------------------------
# Main Welcome Message Function
# -----------------------------------------------------------------------------
# Gathers system information and displays a formatted welcome message
cos_intro() {
  # Gather system information
  host_name="$(hostname)"                                      # Get the hostname
  kernel_version="$(uname -r)"                                 # Get kernel version
  uptime_read="$(uptime | cut -d ',' -f1)"                     # Get system uptime
  ip="$(ipconfig getifaddr en0 2>/dev/null || echo 'no ip')"   # Get IP address (macOS)
  quote="$(cos_quote)"                                         # Get a random quote

  # Display the welcome message with system information
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

# -----------------------------------------------------------------------------
# Execute the Welcome Message
# -----------------------------------------------------------------------------
# Display the welcome message with colorized output using lolcat
cos_intro | lolcat
# Display a random fortune message with colorized output
fortune | lolcat
