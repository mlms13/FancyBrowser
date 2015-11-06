#!/bin/sh
set -e
rm -f fancybrowser.zip
zip -r fancybrowser.zip src haxelib.json README.md -x "*/\.*"
haxelib submit fancybrowser.zip
