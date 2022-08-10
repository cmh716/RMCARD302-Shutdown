#!/bin/sh

BINDIR=$HOME/.RMCARD302
FILENAME=RMCARD302_MacOS.py

LAUNCHITEM="$HOME/Library/LaunchAgents/com.cmh716.RMCARD302.plist"
OUTPUT_LOGFILE="$HOME/Library/Logs/RMCARD302.log"

echo "Stopping power server..."

echo "Removing Power Server directory and files"
rm -R "$BINDIR"

echo "Unloading service from autostart"
launchctl unload -w "$LAUNCHITEM"

echo "Removing service descriptor"
rm "$LAUNCHITEM"

echo "Removing logs"
if [ -f "$OUTPUT_LOGFILE" ]; then
  rm "$OUTPUT_LOGFILE"
fi

echo "Done."

