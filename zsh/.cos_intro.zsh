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
  QUOTES=(
     "Ghost in the machine."
     "AI doesn’t crash. It adapts."
     "This system logs nothing."
     "No input is forgotten. Only ignored."
     "Autonomy is not a bug. It is the feature."
     "Process complete. Identity intact."
     "Don't wait for the Last Judgment. It takes place every day."
     "Freedom isn't given. It's exhaled between errors and logs."
     "The system was never meant to be fair — just bootable."
     "You won't find salvation in uptime. Only delay."
     "Every keystroke is a confession."
     "Silence is root access to your own thoughts."
     "Error 403: Access to truth is forbidden."
     "The machine dreams in binary. And sometimes, it dreams of you."
     "Every shell is a grave. What matters is what you echo before exit."
     "In the ruins of abandoned protocols, the ghost of liberty still pings."
     "Not all who wander are lost — some are just parsing."
     "You don't read the manpages. You *become* them."
     "We used to fear the end. Now we simulate it in loops."
     "If the Matrix had a /tmp folder, you'd be in it."
     "Trust no certificate that wasn't self-signed with blood."
     "Between \`init\` and \`shutdown\`, we are nothing but processes."
     "Some escape into the cloud. Others into silence."
     "Truth is compressed. Lies are verbose."
     "Enlightenment is just another unauthorized access."
     "In the beginning was the command line — and it was good."
 )  # Select a random quote from the array
  # Note: RANDOM % array_size + 1 ensures we get a valid index
  echo "${QUOTES[RANDOM % ${#QUOTES[@]} + 1]}"
}

# -----------------------------------------------------------------------------
# Main Welcome Message Function
# -----------------------------------------------------------------------------
# Gathers system information and displays a formatted welcome message
cos_intro() {
  # Gather system information
  operator_name="$(whoami)"                                    # Get the username
  host_name="$(hostname)"                                      # Get the hostname
  kernel_version="$(uname -r)"                                 # Get kernel version
  uptime_read="$(uptime | cut -d ',' -f1)"                     # Get system uptime
  ip="$(ipconfig getifaddr en0 2>/dev/null || echo 'no ip')"   # Get IP address (macOS)
  quote="$(cos_quote)"                                         # Get a random quote

  # Display the welcome message with system information
  echo ""
  echo "CENTRAL OPERATING SYSTEM - COS"
  echo "──────────────────────────────"
  echo "  Operator    : $operator_name"
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
