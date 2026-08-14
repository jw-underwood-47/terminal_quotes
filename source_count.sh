#!/bin/sh
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
QUOTES_FILE="quotes.txt"
STAT_FILE="source_stats.md"
FULL_QUOTE_PATH="$REPO_DIR/$QUOTES_FILE"
SOURCE_STAT_FILE="$REPO_DIR/$STAT_FILE"

# various places I have quotes from
SOURCES='(^|[^[:alnum:]_])(KJV|RV|ASV)([^[:alnum:]_]|$)
Analects
Marcus Aurelius
Havamal
Sun Tzu
Nicomachean Ethics'

# empty file before I start writing to it, if it exists
if [ -f "$SOURCE_STAT_FILE" ]; then
    rm "$SOURCE_STAT_FILE"
    touch "$SOURCE_STAT_FILE"
fi

# takes the list of sources, "print"s it into read with
# field separator set to empty so each line gets read in one
# at a time (-r makes the newlines literal). Then, print out
# how many times that source appears in quotes.txt.
printf '%s\n' "$SOURCES" |
while IFS= read -r SOURCE; do
    case $SOURCE in
        *KJV*)
            printf "Bible:  \n" >> "$SOURCE_STAT_FILE"
            ;;
        *)
            printf "%s:  \n" "$SOURCE" >> "$SOURCE_STAT_FILE"
            ;;
    esac
    grep -c -i -E "$SOURCE" "$FULL_QUOTE_PATH" >> "$SOURCE_STAT_FILE"
done
