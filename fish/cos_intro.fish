# Banner
set -g COS_BANNER "CENTRAL OPERATING SYSTEM - COS"
set -g COS_DIVIDER "──────────────────────────────"

function cos_quote
    set quotes \
        "Ghost in the machine." \
        "AI doesn't crash. It adapts." \
        "This system logs nothing." \
        "No input is forgotten. Only ignored." \
        "Autonomy is not a bug. It is the feature." \
        "Process complete. Identity intact." \
        "Don't wait for the Last Judgment. It takes place every day." \
        "Freedom isn't given. It's exhaled between errors and logs." \
        "The system was never meant to be fair — just bootable." \
        "You won't find salvation in uptime. Only delay." \
        "Every keystroke is a confession." \
        "Silence is root access to your own thoughts." \
        "Error 403: Access to truth is forbidden." \
        "The machine dreams in binary. And sometimes, it dreams of you." \
        "Every shell is a grave. What matters is what you echo before exit." \
        "In the ruins of abandoned protocols, the ghost of liberty still pings." \
        "Not all who wander are lost — some are just parsing." \
        "You don't read the manpages. You *become* them." \
        "We used to fear the end. Now we simulate it in loops." \
        "If the Matrix had a /tmp folder, you'd be in it." \
        "Trust no certificate that wasn't self-signed with blood." \
        "Between init and shutdown, we are nothing but processes." \
        "Some escape into the cloud. Others into silence." \
        "Truth is compressed. Lies are verbose." \
        "Enlightenment is just another unauthorized access." \
        "In the beginning was the command line — and it was good."
    set -l rand (random 1 (count $quotes))
    echo $quotes[$rand]
end

function _cos_user; whoami; end
function _cos_host; hostname; end
function _cos_kernel; uname -r; end
function _cos_uptime; uptime | cut -d ',' -f1; end

function _cos_ip
    switch (uname)
        case Darwin
            ipconfig getifaddr en0 ^/dev/null; or echo 'no ip'
        case Linux
            set -l ip (hostname -I | awk '{print $1}' 2>/dev/null)
            test -n "$ip"; and echo $ip; or echo 'no ip'
        case '*'
            echo unknown
    end
end

function cos_intro
    set -l user (_cos_user)
    set -l host (_cos_host)
    set -l kernel (_cos_kernel)
    set -l up (_cos_uptime)
    set -l ip (_cos_ip)
    set -l q (cos_quote)

    echo
    echo $COS_BANNER
    echo $COS_DIVIDER
    echo "  Operator    : $user"
    echo "  Uptime      : $up"
    echo "  Hostname    : $host"
    echo "  IP Address  : $ip"
    echo "  Kernel      : $kernel"
    echo $COS_DIVIDER
    echo "  $q"
    echo

    # If lolcat is installed, colorize; otherwise, just output (optional)
    # command -q lolcat; and commandline -f repaint
end

# Show the banner only in interactive shell (fish already calls fish_greeting)
if status is-interactive
    # Define fish_greeting as cos_intro if it isn't already
    functions -q fish_greeting; or functions -c cos_intro fish_greeting
end
