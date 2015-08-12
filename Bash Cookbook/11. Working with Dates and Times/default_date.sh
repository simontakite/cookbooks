#!/usr/bin/env bash
# cookbook filename: default_date

# Use Noon time to prevent a script running around midnight and a clock a
# few seconds off from causing off by one day errors.
START_DATE=$(date -d 'last week Monday 12:00:00' '+%Y-%m-%d')

while [ 1 ]; do
    printf "%b" "The starting date is $START_DATE, is that correct? (Y/new date)"
    read answer

    # Anything other than ENTER, "Y" or "y" is validated as a new date
    # could use "[Yy]*" to allow the user to spell out "yes"...
    # validate the new date format as: CCYY-MM-DD
    case "$answer" in
        [Yy]) break
            ;;
        [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])
            printf "%b" "Overriding $START_DATE with $answer\n"
            START_DATE="$answer"
            ;;

        *)   printf "%b" "Invalid date, please try again...\n"
            ;;
    esac
done

END_DATE=$(date -d "$START_DATE +7 days" '+%Y-%m-%d')

echo "START_DATE: $START_DATE"
echo "END_DATE:   $END_DATE"
