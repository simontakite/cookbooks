# cookbook filename: using_phases

# Main Loop
until [ "$phase" = "Finished." ]; do

    case $phase in

        phase0 )
            ThisPhase=0
            NextPhase="$(( $ThisPhase + 1 ))"
            echo '############################################'
            echo "Phase$ThisPhase = Initialization of FooBarBaz build"
            # Things that should only be initialized at the beginning of a
            # new build cycle go here
# ...
            echo "Phase${ThisPhase}=Ending"
            phase="phase$NextPhase"
        ;;


# ...


        phase20 )
        ThisPhase=20
            NextPhase="$(( $ThisPhase + 1 ))"
            echo '############################################'
            echo "Phase$ThisPhase = Main processing for FooBarBaz build"


# ...


            choice "[P$ThisPhase] Do we need to stop and fix anything? [y/N]: "
            if [ "$choice" = "y" ]; then
                echo "Re-run '$MYNAME phase${ThisPhase}' after handling this."
                exit $ThisPhase
            fi

            echo "Phase${ThisPhase}=Ending"
            phase="phase$NextPhase"
        ;;


# ...


        * )
            echo "What the heck?!? We should never get HERE! Gonna croak!"
            echo "Try $0 -h"
             exit 99
            phase="Finished."
        ;;
    esac
    printf "%b" "\a"        # Ring the bell
done
