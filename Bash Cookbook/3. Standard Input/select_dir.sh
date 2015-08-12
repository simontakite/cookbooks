# cookbook filename: select_dir

directorylist="Finished $(for i in /*;do [ -d "$i" ] && echo $i; done)"

PS3='Directory to process? ' # Set a useful select prompt
until [ "$directory" == "Finished" ]; do

    printf "%b" "\a\n\nSelect a directory to process:\n" >&2
    select directory in $directorylist; do

        # User types a number which is stored in $REPLY, but select
        # returns the value of the entry
        if [ "$directory" == "Finished" ]; then
            echo "Finished processing directories."
            break
        elif [ -n "$directory" ]; then
            echo "You chose number $REPLY, processing $directory..."
            # Do something here
            break
        else
            echo "Invalid selection!"
        fi # end of handle user's selection

    done # end of select a directory
done # end of until we're finished
