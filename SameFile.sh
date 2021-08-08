#!/bin/bash

init () {
    local SUGGEST_USAGE
    SUGGEST_USAGE="Type \"./SameFile.sh --help\" to see usage"
    if [ "$1" == "--help" ]; then
        usage
        exit 0
    fi
    if [ "$1" == "" ]; then
        echo "SameFile: error: directory not specified"
        echo "$SUGGEST_USAGE"
        exit 1
    fi
    if [ ! -d "$1" ]; then
        echo "SameFile: error: \"$1\" - no such directory"
        echo "$SUGGEST_USAGE"
        exit 1
    fi
    if [ "$2" == "" ]; then
        echo "SameFile: error: output file not specified"
        echo "$SUGGEST_USAGE"
        exit 1
    fi
    trap interrupt SIGINT
    stty -echoctl
    tabs 4
    count "$1"
    confirm
    calc "$1"
    dupl "$2"
    exit 0
}

usage () {
    echo "SameFile v1.0 by MasterDevX"
    echo "Made in Ukraine"
    echo
    echo "Usage:"
    echo './SameFile.sh <path> <output>'
    echo
    echo "path   - Derectory to analyze."
    echo "output - Output file with results."
}

interrupt () {
    echo
    echo "Cancelled."
    exit 1
}

count () {
    echo "Counting files in \"$1\"..."
    FILE_COUNT=$(find "$1" -type f | wc -l)
    if [ $FILE_COUNT -eq 0 ]; then
        echo "No files found."
        exit 0
    fi
    echo "Files found: $FILE_COUNT"
}

confirm () {
    local CONFIRM
    echo
    read -p "Proceed? [ y / N ] " CONFIRM
    if [ "${CONFIRM,,}" != "y" ]; then
        echo
        echo "Aborted."
        exit 1
    fi
}

calc () {
    local COUNTER FILE_NAME
    COUNTER=0
    MD5_LIST=""
    echo
    while read FILE_NAME; do
        COUNTER=$(($COUNTER + 1))
        echo -ne "Calculating MD5... [ done: $COUNTER / $FILE_COUNT ]\r"
        MD5_LIST="$MD5_LIST$(md5sum "$FILE_NAME")\n"
    done < <(find "$1" -type f)
}

dupl () {
    local COUNTER MD5_SUM MD5_FILE FILE_SIZE STATUS_LINE
    COUNTER=0
    STATUS_LINE="Checking for duplicates..."
    echo
    echo -ne "$STATUS_LINE\r"
    if [ -f "$1" ]; then
        rm "$1"
    fi
    MD5_LIST="${MD5_LIST::-2}"
    while read MD5_SUM; do
        FILE_SIZE=""
        COUNTER=$(($COUNTER + 1))
        echo -ne "$STATUS_LINE [ found: $COUNTER ]\r"
        echo -n "$COUNTER. $MD5_SUM " >> "$1"
        while read MD5_FILE; do
            if [ "$FILE_SIZE" == "" ]; then
                FILE_SIZE="$(du -h "$MD5_FILE" | cut -f 1)"
                echo "[ $FILE_SIZE ]" >> "$1"
            fi
            echo -e "\t$MD5_FILE" >> "$1"
        done < <(echo -e "$MD5_LIST" | grep "^$MD5_SUM" | cut -d ' ' -f 3-)
        echo >> "$1"
    done < <(echo -e "$MD5_LIST" | cut -d ' ' -f 1 | sort | uniq -d)
    echo
    if [ ! -f "$1" ]; then
        echo "No duplicates found."
        exit 0
    fi
    echo "Results written to \"$1\"!"
}

init "$@"
