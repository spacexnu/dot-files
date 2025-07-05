# Constant for banner header
set COS_BANNER "CENTRAL OPERATING SYSTEM - COS"
set COS_DIVIDER "──────────────────────────────"

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
        "Between `init` and `shutdown`, we are nothing but processes." \
        "Some escape into the cloud. Others into silence." \
        "Truth is compressed. Lies are verbose." \
        "Enlightenment is just another unauthorized access." \
        "In the beginning was the command line — and it was good."
    set rand (random 1 (count $quotes))
    echo $quotes[$rand]
end

function get_user_name
    echo (whoami)
end

function get_host_name
    echo (hostname)
end

function get_kernel_version
    echo (uname -r)
end

function get_uptime
    echo (uptime | cut -d ',' -f1)
end

function get_ip_address
    switch (uname)
        case Darwin
            echo (ipconfig getifaddr en0 2>/dev/null || echo 'no ip')
        case Linux
            set ip (hostname -I | awk '{print $1}' 2>/dev/null)
            if test -z "$ip"
                echo 'no ip'
            else
                echo $ip
            end
        case '*'
            echo unknown
    end
end

function cos_intro
    set user_name (get_user_name)
    set host_name (get_host_name)
    set kernel_version (get_kernel_version)
    set uptime_read (get_uptime)
    set ip (get_ip_address)
    set quote (cos_quote)

    echo ""
    echo $COS_BANNER
    echo $COS_DIVIDER
    echo "  Operator    : $user_name"
    echo "  Uptime      : $uptime_read"
    echo "  Hostname    : $host_name"
    echo "  IP Address  : $ip"
    echo "  Kernel      : $kernel_version"
    echo $COS_DIVIDER
    echo "  $quote"
    echo ""
end

if status is-interactive
    # cos_intro | lolcat
    cos_intro
end
