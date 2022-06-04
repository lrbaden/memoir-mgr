#! /bin/sh

ORIGIN=$1
DESTINATION=$2
LOG=${3:-/tmp/CHANGES.log}


file_removed() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: $2 was removed from $1" >> "$LOG"
}

file_modified() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: The file $1$2 was modified" >> "$LOG"
}

file_created() {
    TIMESTAMP=`date`
    echo "[$TIMESTAMP]: The file $1$2 was created" >> "$LOG"
}

inotifywait -q -m -r -e modify,delete,create $1 | while read DIRECTORY EVENT FILE; do
    case $EVENT in
        MODIFY*)
            file_modified "$DIRECTORY" "$FILE"
            ;;
        CREATE*)
            file_created "$DIRECTORY" "$FILE"
            ;;
        DELETE*)
            file_removed "$DIRECTORY" "$FILE"
            ;;
    esac
    # handle extra arguments
    shift 2
    # sync files
    rsync -aqz $ORIGIN $DESTINATION $@
done
