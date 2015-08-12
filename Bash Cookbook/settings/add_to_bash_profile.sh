# cookbook filename: add_to_bash_profile

# If we're running in bash, search for then source our settings
# You can also just hard code $SETTINGS, but this is more flexible
if [ -n "$BASH_VERSION" ]; then
    for path in /opt/bin /etc ~ ; do
        # Use the first one found
        if [ -d "$path/settings" -a -r "$path/settings" -a -x "$path/settings" ]
        then
            export SETTINGS="$path/settings"
        fi
    done
    source "$SETTINGS/bash_profile"
    #source "$SETTINGS/bash_rc"      # If necessary
fi
