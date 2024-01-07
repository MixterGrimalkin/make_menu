LAST=$(ls -1t *.gem | head -n 1)

mv "$LAST" "$LAST.bak"
rm *.gem 2>/dev/null
mv "$LAST.bak" "$LAST"
