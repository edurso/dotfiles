#!/usr/bin/env bash

# exit on error
set -e
set -o pipefail

# display constant
readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[1;34m'
readonly NC='\033[0m'

# display function
display() {
    local color=""
    local display_str=""

    # reset OPTIND to ensure correct parsing for multiple calls
    OPTIND=1

    # parse options
    while getopts "rygbh" flag; do
        case "$flag" in
            r) color=$RED ;;
            y) color=$YELLOW ;;
            g) color=$GREEN ;;
            b) color=$BLUE ;;
            h) 
                echo "Usage: $0 [-r|-y|-g|-b] <string>"
                return 0
                ;;
            *)
                echo "Invalid option"
                return 1
                ;;
        esac
    done

    # shift processed flags and capture the string parameter
    shift $((OPTIND - 1))
    display_str="$1"

    # validate input string
    if [ -z "$color" ]; then
        color=$BLUE
    fi
    if [ -z "$display_str" ]; then
        echo -e "${RED}error: a string parameter is required${NC}"
        return 1
    fi

    # display the input string
    echo -e "${color}$display_str${NC}"
}

# define function to prompt y/n
function select_continue {
	while true; do
		display -y "do you wish to continue? (y/n)"
		read -p "" yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit 1;;
			* ) display -r "answer yes (y) or no (n)";;
		esac
	done
}
