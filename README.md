# RMCARD302-Shutdown
**CyberPower RMCARD302 Shutdown Agent**

The purpose of this project is to shutdown computers when the CyberPower RMCARD302 SNMP card sends the *On Battery* and the *Low Battery* SNMP Traps. This is intended as lightweight option when compared to running a NUT server.

Add Documentaion links here

**Prerequisites**
You must configure the UPS to send SNMP traps
[Add screenshots here]
You must install python3
[Add Steps here]





### *MacOS Installation*
From the command line:
```
osascript -e 'display notification "Test Message" with title "UPS"'
```
If a dialog comes up asking to allow notifications, choose the option to allow.

After installing python3, install required modules via pip3:

```
pip3 install pysnmp getopts
```

Download and run the uninstall script and run:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cmh716/RMCARD302-Shutdown/main/macos_uninstall.sh)"
```

Download and run the installation script:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/cmh716/RMCARD302-Shutdown/main/macos_install.sh)"
```







