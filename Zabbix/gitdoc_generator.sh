#/bin/bash

# #############################################################################

       NAME_="gitdoc_generator.sh"
    PURPOSE_="  This is a helper script for semi-automating the creation of Zabbix templates documentation on gitlab"
   SYNOPSIS_="$NAME_ <zabbix xml file> [-h]"
   REQUIRES_="standard GNU commands, xidel<http://videlibri.sourceforge.net/xidel.html>"
    VERSION_="1.0"
       DATE_="2014-19-05"
     AUTHOR_="Simon Takite <simont@uninett.no>"
   REVIEWED_="Rune Myrhaug <rune.myrhaug@uninett.no>, Bjørn Villa <bjørn.villa@uninett.no>"
        URL_="www.uninett.no"
   CATEGORY_="Utilities"
   PLATFORM_="Linux"
      SHELL_="bash"

# #############################################################################
# This program is distributed under the terms of the GNU General Public License

function usage {

echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
Usage: $SYNOPSIS_
Requires: $REQUIRES_
Options:
     -h, usage and options (this help)
     -l, see this script"
    exit 1
}

while getopts h options; do

    case "$options" in
        h) usage
                exit 1;; 
        \?) echo invalid argument, type $NAME_ -h for help; exit 1 ;;
    esac

done

## Temps
ITEM_TEMPFILE=$(mktemp)
TRIGGERS_TEMPFILE=$(mktemp)
GRAPHS_TEMPFILE=$(mktemp)
PRIORITY_TEMPFILE=$(mktemp)
TRIGGER_PRIORITY_TEMPFILE=$(mktemp)
DISCOVERYRULE_TEMPFILE=$(mktemp)

ARG=$1

HEADING=$(xidel $ARG -e /zabbix_export/templates/template/name 2>/dev/null)
ITEMS=$(xidel $ARG -e /zabbix_export/templates/template/items/item/name > $ITEM_TEMPFILE 2>/dev/null)
TRIGGERS=$(xidel $ARG -e /zabbix_export/triggers/trigger/name | sed 's/ /-/g' > $TRIGGERS_TEMPFILE 2>/dev/null)
PRIORITY=$(xidel $ARG -e /zabbix_export/triggers/trigger/priority > $PRIORITY_TEMPFILE 2>/dev/null)
TRIGGER_PRIORITY=$(paste -d' ' $TRIGGERS_TEMPFILE $PRIORITY_TEMPFILE > $TRIGGER_PRIORITY_TEMPFILE 2>/dev/null)
GRAPHS=$(xidel $ARG -e /zabbix_export/graphs/graph/name > $GRAPHS_TEMPFILE 2>/dev/null)
DISCOVERYRULE=$(xidel $ARG -e /zabbix_export/templates/template/discovery_rules/discovery_rule/name > $DISCOVERYRULE_TEMPFILE 2>/dev/null)
DIR=$(pwd)
FILE=$(echo $HEADING | sed s'/ /-/'g).md
MDFILE="$DIR/$FILE"

function header_info {
	
	echo "$HEADING"
	echo "==========="
	echo -e "\n"
	echo "This template use the APC-POWERNET-MIB to discover and manage APC UPS devices."
	echo -e "\n"
	}

function items {
	echo "Items"
	echo "-----"
	echo -e "\n"
	
	while read item 
	do
		echo "  * $item"
	done < $ITEM_TEMPFILE
	echo -e "\n"
	}

function triggers {
	echo "Triggers"
	echo "-----"
	echo -e "\n"
	
	while read trigger value
	do
		TYPE=""
		if [ $value -eq 0 ]; then
			TYPE="NOT CLASSIFIED"
		elif [ $value -eq 1 ]; then
			TYPE="INFORMATION"
		elif [ $value -eq 2 ]; then
			TYPE="WARNING"
		elif [ $value -eq 3 ]; then
			TYPE="AVERAGE"
		elif [ $value -eq 4 ]; then
			TYPE="HIGH"
		else [ $value -eq 5 ];
			TYPE="DISASTER"
		fi
		
		strip_trigger=$(echo $trigger | sed 's/-/ /g')
		
		echo "  * **[$TYPE]** => $strip_trigger"
	done < $TRIGGER_PRIORITY_TEMPFILE
		echo -e "\n"
	}

function discovery_rule {
	echo "Discovery rules"
	echo "-----"
	echo -e "\n"
	
	while read rule 
	do
		echo "  * $rule"
	done < $DISCOVERYRULE_TEMPFILE
	echo -e "\n"
	}

function graphs {
	echo "Graphs"
	echo "------"
	echo -e "\n"
	while read graph 
	do
		echo "  * $graph"
	done < $GRAPHS_TEMPFILE
	echo -e "\n"
	}
	
function installation {
	echo "Installation"
	echo "------------"
	echo -e "\n"
	}
	
function requirements {
	echo "### Requirements"
	echo -e "\n"
	echo "This template was tested for Zabbix 2.2.0"
	echo -e "\n"
	}

function license {
	echo "License"
	echo "-------"
	echo -e "\n"
	echo "This template is distributed under the terms of the GNU General Public License as published by \
the Free Software Foundation; either version 2 of the  License, or -at your option any- later version."
	echo -e "\n"
	}

function cleanup {
	rm /tmp/tmp.*
	}

function generatemd {
	echo '' > $MDFILE
	header_info >> $MDFILE
	items >> $MDFILE
	triggers >> $MDFILE
	discovery_rule >> $MDFILE
	graphs >> $MDFILE
	installation >> $MDFILE
	requirements >> $MDFILE
	license >> $MDFILE
	cleanup
	}

generatemd
