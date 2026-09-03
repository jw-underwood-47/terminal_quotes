#!/bin/sh

# Create a temporary file to avoid overwriting the source file mid-read
TMP_FILE=$(mktemp)

# Use awk to find and replace the textwrap logic in get_quotes.py
awk '
/wrapped_quote = textwrap.fill/ {
    print "    # split by backslash, strip whitespace, wrap each line, and join with newlines"
    print "    lines = [textwrap.fill(line.strip(), width=terminal_width) for line in quote.split(\"\\\\\")]"
    print "    print(\"\\n\".join(lines))"
    skip = 1
    next
}
/print\(wrapped_quote\)/ {
    if (skip) { skip = 0; next }
}
{ print $0 }
' get_quotes.py > "$TMP_FILE"

# Replace the original file and maintain executable permissions
mv "$TMP_FILE" get_quotes.py
chmod +x get_quotes.py

echo "Modified get_quotes.py to render backslashes as line breaks."
