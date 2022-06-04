#! /bin/sh

MANUSCRIPT_DIR="manuscript"
MANUSCRIPT="$MANUSCRIPT_DIR/manuscript.md"
PRESENTATION_DIR="presentation"
PRESENTATION="$PRESENTATION_DIR/presentation.md"
MSG="<!-- This file was generated automatically. -->"

echo "preparing manuscript.md ..."
echo -e "$MSG" > "$MANUSCRIPT"

for partial in $(find "$MANUSCRIPT_DIR/partials" -type f); do
    (echo -e "\n"; cat "$partial") >> "$MANUSCRIPT"
done

echo "done."

# if [ ! -z "$($PRESENTATION_DIR/partials")" ]
echo "preparing presentation.md ..."
echo -e "$MSG" > "$PRESENTATION"
for partial in $(find "$PRESENTATION_DIR/partials" -type f); do
    (echo -e "\n"; cat "$partial") >> "$PRESENTATION"
done

echo "done."