# RMCARD302-Shutdown
**CyberPower RMCARD302 Shutdown Agent**

The purpose of this project is to shutdown computers when the CyberPower [RMCARD302](https://www.cyberpowersystems.com/product/ups/hardware/rmcard302/) SNMP card sends the *On Battery* and the *Low Battery* SNMP Traps. This is intended as lightweight option when compared to running a NUT server.


**Prerequisites**

* Log into the RMCARD302 WebUI and click on UPS-->Configuration and set a *Low Battery Threshold*. The computer will not shutdown until this threshold is met.
* Log into the RMCARD302 WebUI and click on System-->Notifictions-->Trap Receivers.  You must have an entry for each computer running this script.  Currently, the script assumes your SNMP community is public.
* Log into the RMCARD302 WebUI and click on System-->Notifictions-->Event Action. 
    * Under *Input Line Status* ensure *"Utility power failed, transfer to backup mode"* and *"Utility power restored, return from backup mode"* are enabled.
    * Under *Battery* ensure *"The UPS battery capacity is low than threshold, soon to be exhausted"* and *"The UPS has returned from a low battery condition"* are enabled.
* You must have [python3](https://www.python.org/downloads/) installed.


**Thanks**

Thanks go out to @dniklewicz for his UPS Power Monitor [project](https://github.com/dniklewicz/UPSPowerHelper).


--- 

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

Check to ensure the process is running:
```
ps -A | grep RMCARD
```

You can view the logs here:
```
tail $HOME/Library/Logs/RMCARD302-Error.log
tail $HOME/Library/Logs/RMCARD302-Output.log
``` 
--- 


### *Windows Installation*
Windows Scripts will be added shortly






