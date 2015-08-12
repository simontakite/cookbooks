# cookbook filename: func_trunc_PWD


function trunc_PWD {
    # $PWD truncation code adapted from The Bash Prompt HOWTO:
    # 11.10. Controlling the Size and Appearance of $PWD
    # http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x783.html

    # How many characters of the $PWD should be kept
    local pwdmaxlen=30
    # Indicator that there has been directory truncation:
    local trunc_symbol='...'
    # Temp variable for PWD
    local myPWD=$PWD

    # Replace any leading part of $PWD that matches $HOME with '~'
    # OPTIONAL, comment out if you want the full path!
    myPWD=${PWD/$HOME/~}

    if [ ${#myPWD} -gt $pwdmaxlen ]; then
        local pwdoffset=$(( ${#myPWD} - $pwdmaxlen ))
        echo "${trunc_symbol}${myPWD:$pwdoffset:$pwdmaxlen}"
    else
        echo "$myPWD"
    fi
}
