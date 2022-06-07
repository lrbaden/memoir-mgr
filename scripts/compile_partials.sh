#! /bin/sh

MAN="${MANUSCRIPT_DIR:-/memoir/manuscript},${MANUSCRIPT_FILE:-/memoir/manuscript/manuscript.md},${MANUSCRIPT_UPDATE:-true}"
PRES="${PRESENTATION_DIR:-/memoir/presentation},${PRESENTATION_FILE:-/memoir/presentation/presentation.md},${PRESENTATION_UPDATE:-true}"
ALT="$SRC_DIR,$SRC_FILE,${SRC_UPDATE:-false}"

# parse: parses the input string and set required variables
function parse() { 
    export LOCATION=${1:+"$(echo $1| cut -d ',' -f 1)"}
    export FILE=${1:+"$(echo $1| cut -d ',' -f 2)"}
    export UPDATE=${1:+"$(echo $1| cut -d ',' -f 3)"}
}

# update_src: refreshes the content of a file using partials
# usage: update_src <file> <partials_dir>
function update_src() {

    # check source file
    if [ ! -f "$1" ]; then 
        echo "$1 not found." 
        exit 1
    fi

    # check partials directory
    if [ ! -d "$2" ] || [ -z "$(ls $2)" ]; then 
        echo "$(basename $1) was not updated because $2 is empty"
        exit 1
    fi

    # compare source vs partials
    old=$(< "$1")
    new=$(cat $(find $2 -type f))

    # update source file
    if [ "$old" != "$new" ]; then 
        echo "<!-- Last updated: `date` -->" > "$1"
        echo "$new" >> "$1"
    fi 
}

# process input strings
for str in "$MAN" "$PRES" "$ALT"; do
    parse "$str"
    if [ "$UPDATE" == "true" ]; then update_src "$FILE" "$LOCATION/partials" & fi
done

# wait for child processes
sleep 0.1s
