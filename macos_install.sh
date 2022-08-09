#!/bin/sh

## Prevent the execution of the script if the user has root privileges
if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root or sudo" 1>&2
  exit 1
fi

PORT=${1:-162}

BINDIR=$HOME/.RMCARD302
FILENAME=RMCARD302_MacOS.py

mkdir -p "$BINDIR"

XML="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.cmh716.RMCARD302</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/python3</string>
        <string>$BINDIR/$FILENAME</string>
        <string>-p $PORT</string>
    </array>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/RMCARD302-Error.log</string>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/RMCARD302-Output.log</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>"

LAUNCHITEM="$HOME/Library/LaunchAgents/com.cmh716.RMCARD302.plist"
URL="https://raw.githubusercontent.com/cmh716/RMCARD302-Shutdown/main/src/RMCARD302_MacOS.py"

# Creating ~/Library/LaunchAgents if needed
LIB_LAUNCH_AGENTS="$HOME/Library/LaunchAgents/"

if [ ! -d "$LIB_LAUNCH_AGENTS" ]
then
  echo "Creating directory $LIB_LAUNCH_AGENTS"
  mkdir -p "$LIB_LAUNCH_AGENTS"
else
  echo "Directory $LIB_LAUNCH_AGENTS already exists"
fi

curl -L "$URL" --output "$FILENAME"
mv "$FILENAME" "$BINDIR/$FILENAME"
chmod +x "$BINDIR/$FILENAME"
echo $XML > "$LAUNCHITEM"
if (( `launchctl list | grep com.cmh716.RMCARD302 | wc -l` > 0 ))
then
  echo "Unloading previous instance of RMCAR302 listener."
  launchctl unload -w "$LAUNCHITEM"
fi
launchctl load -w "$LAUNCHITEM"
# launchctl start "$LAUNCHITEM"

echo "Starting RMCAR302 listener on port $PORT"
