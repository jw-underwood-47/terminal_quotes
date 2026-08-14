#!/bin/sh
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
QUOTES_FILE="quotes.txt"
STAT_FILE="source_stats.md"
FULL_QUOTE_PATH="$REPO_DIR/$QUOTES_FILE"
SOURCE_STAT_FILE="$REPO_DIR/$STAT_FILE"

# various places I have quotes from
SOURCES='(^|[^[:alnum:]_])(KJV|RV|ASV|WEB)([^[:alnum:]_]|$)
Analects
Marcus Aurelius
Havamal
Sun Tzu
Nicomachean Ethics
Immanuel Kant'

# empty file before I start writing to it, if it exists
if [ -f "$SOURCE_STAT_FILE" ]; then
    rm "$SOURCE_STAT_FILE"
    touch "$SOURCE_STAT_FILE"
fi

# count total quotes, to compare with detected quotes
TOTAL_QUOTES=$(wc -l < "$FULL_QUOTE_PATH")
FOUND_QUOTES=0

# feeds the list of sources into the loop to read each line
# field separator set to empty so each line gets read in one
# at a time (-r makes the newlines literal). Then, store
# how many times that source appears in quotes.txt.
# also, count total quotes found so far
while IFS= read -r SOURCE; do
    case $SOURCE in
        *KJV*)
            printf "Bible: " >> "$SOURCE_STAT_FILE"
            ;;
        *)
            printf "%s: " "$SOURCE" >> "$SOURCE_STAT_FILE"
            ;;
    esac
    FROM_QUOTE=$(grep -c -i -E "$SOURCE" "$FULL_QUOTE_PATH")
    FOUND_QUOTES=$((FOUND_QUOTES + FROM_QUOTE))
    printf "%s  \n" "$FROM_QUOTE" >> "$SOURCE_STAT_FILE"
done <<EOF
$SOURCES
EOF
# if there are quotes that are not found, print a message
if [ "$FOUND_QUOTES" -ne "$TOTAL_QUOTES" ]; then
    printf "\nALERT! ALERT! %s quotes not documented!\n" "$((TOTAL_QUOTES - FOUND_QUOTES))"
fi
