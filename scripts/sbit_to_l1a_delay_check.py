from cmd import Cmd
import sys, os, subprocess
from rw_reg import *
import time
import collections

class Colors:
    WHITE   = '\033[97m'
    CYAN    = '\033[96m'
    MAGENTA = '\033[95m'
    BLUE    = '\033[94m'
    YELLOW  = '\033[93m'
    GREEN   = '\033[92m'
    RED     = '\033[91m'
    ENDC    = '\033[0m'

def printCyan(string):  
    print Colors.CYAN  
    print string, Colors.ENDC

def printGreen(string):
    print Colors.GREEN
    print string, Colors.ENDC
                          
def printRed(string):
    print Colors.RED
    print string, Colors.ENDC

#NUM_READS = 1000
#NUM_READS = 3500
#NUM_READS = 50000
NUM_READS = 1000000

if __name__ == '__main__':

    parseXML()

    addrSbitMonReset = getNode("GEM_AMC.TRIGGER.SBIT_MONITOR.RESET").real_address
    addrSbitMonL1aDelay = getNode("GEM_AMC.TRIGGER.SBIT_MONITOR.L1A_DELAY").real_address

    l1aDelays = {}
    numTimeouts = 0

    for i in range(NUM_READS):
        if (i % 10 == 0):
            print("progress: %i/%i" % (i, NUM_READS))
        wReg(addrSbitMonReset, 1)
        l1aDelay = 0
        while(l1aDelay == 0):
            time.sleep(0.000001)
            l1aDelay = rReg(addrSbitMonL1aDelay)

        # wait 1ms to make sure the counter has settled
        time.sleep(0.000025)
        l1aDelay = rReg(addrSbitMonL1aDelay)
        l1aDelayLater = rReg(addrSbitMonL1aDelay)
        
        if l1aDelay != l1aDelayLater:
            numTimeouts += 1
        else:
            l1aDelays[l1aDelay] = l1aDelays.get(l1aDelay, 0) + 1

    l1aDelaysOrdered = collections.OrderedDict(sorted(l1aDelays.items()))

    printCyan("There were %i timeouts" % numTimeouts)
    printCyan("Results (latency, count):")
    printCyan("The following section can be used with sbitDelayPlot.py to make a plot:")
    print("")
    print("BX/I:Count/I")
    for delay in l1aDelaysOrdered:
        print("%i, %i" % (delay, l1aDelaysOrdered[delay]))