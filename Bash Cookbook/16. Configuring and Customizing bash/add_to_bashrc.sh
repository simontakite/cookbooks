# cookbook filename: add_to_bashrc

# If we're running in bash, and it isn't already set,
# search for then source our settings
# You can also just hard code $SETTINGS, but this is more flexible
if [ -n "$BASH_VERSION" ]; then
    if [ -z "$SETTINGS" ]; then
        for path in /opt/bin /etc ~ ; do
            # Use the first one found
            if [ -d "$path/settings" -a -r "$path/settings" -a -x "$path/settings" ]
            then
                export SETTINGS="$path/settings"
            fi
        done
    fi
    source "$SETTINGS/bashrc"
fi
