from pysnmp.entity import engine, config
from pysnmp.carrier.asyncore.dgram import udp
from pysnmp.entity.rfc3413 import ntfrcv
import getopt
import subprocess
import sys
import logging

def shutdown():
    subprocess.call(['osascript', '-e', 'tell application "Finder" to shut down'])
    #subprocess.call(['osascript', '-e', 'display notification "Would shutdown now" with title "UPS"'])


Port=162;
CyberPowerOID = ['1.3.6.1.6.3.1.1.4.1.0']

logging.basicConfig(
    format='%(asctime)s %(levelname)-8s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S')

OnBattery = False;
LowBattery = False;

try:
    opts, args = getopt.getopt(sys.argv[1:], 'p:')
except getopt.GetoptError as err:
    pass

output = None
verbose = False
for o, a in opts:
    if o == '-p':
        Port = int(a)

snmpEngine = engine.SnmpEngine()

TrapAgentAddress='0.0.0.0'; 

logging.info("RMCARD302 Shutdown agent is listening for SNMP Traps on "+TrapAgentAddress+" , Port : " +str(Port));

config.addTransport(
    snmpEngine,
    udp.domainName + (1,),
    udp.UdpTransport().openServerMode((TrapAgentAddress, Port))
)

#Configure community here
config.addV1System(snmpEngine, 'my-area', 'public')

def cbFun(snmpEngine, stateReference, contextEngineId, contextName,
          varBinds, cbCtx):
    global OnBattery;
    global LowBattery;


    for name, val in varBinds:
        if name.prettyPrint() in CyberPowerOID:
            if val.prettyPrint() == '1.3.6.1.4.1.3808.0.5':
                OnBattery = True;
                logging.info('Power Failed - UPS is on battery');
                subprocess.call(['osascript', '-e', 'display notification "Power Failed - UPS is on battery" with title "UPS"'])
            elif val.prettyPrint() == '1.3.6.1.4.1.3808.0.9':
                OnBattery = False;
                logging.info('Power Restored - UPS is online');
                subprocess.call(['osascript', '-e', 'display notification "Power Restored - UPS is online" with title "UPS"'])
            elif val.prettyPrint() == '1.3.6.1.4.1.3808.0.7':
                LowBattery = True;
                logging.info('The UPS is battery is low');
            elif val.prettyPrint() == '1.3.6.1.4.1.3808.0.11':
                OnBattery = False;
                logging.info('The UPS is battery is no longer low');
            else:
                logging.info('CyberPower SNMP Message received: %s = %s' % (name.prettyPrint(), val.prettyPrint()))
    if OnBattery and LowBattery:
        OnBattery = False;
        LowBattery = False;
        subprocess.call(['osascript', '-e', 'display notification "The UPS is battery is low. Shutting down." with title "UPS"'])
        shutdown();

ntfrcv.NotificationReceiver(snmpEngine, cbFun)

snmpEngine.transportDispatcher.jobStarted(1)  

try:
    snmpEngine.transportDispatcher.runDispatcher()
except:
    snmpEngine.transportDispatcher.closeDispatcher()
    raise
