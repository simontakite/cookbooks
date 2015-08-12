# cookbook filename: func_choice.2
CHOICE=''
until [ "$CHOICE" = "y" ]; do
    printf "%b" "This package's date is $THISPACKAGE\n" >&2
    choice "Is that correct? [Y/,<New date>]: "
    if [ -z "$CHOICE" ]; then
        CHOICE='y'
    elif [ "$CHOICE" != "y" ]; then
        printf "%b" "Overriding $THISPACKAGE with ${CHOICE}\n"
        THISPACKAGE=$CHOICE
    fi
done

# Build the package here
