#!/bin/env python
from rw_reg import *
from mcs import *
from time import *
import array
import struct
import random

SLEEP_BETWEEN_COMMANDS=0.1
DEBUG=False
CTP7HOSTNAME = "eagle33"

class Colors:            
    WHITE   = '\033[97m' 
    CYAN    = '\033[96m' 
    MAGENTA = '\033[95m' 
    BLUE    = '\033[94m' 
    YELLOW  = '\033[93m' 
    GREEN   = '\033[92m' 
    RED     = '\033[91m' 
    ENDC    = '\033[0m'  

REG_CTP7_BOARD_ID = None
REG_OH0_VFAT0_LATENCY = None

def main():

    numIterations=0
    instructions=""

    if len(sys.argv) < 3:
        print('Usage: evkatest.py <instructions> <num_iterations>')
        print('instructions:')
        print('  contains ctp7:     test ctp7 reg access')
        print('  contains vfat:     test vfat reg access')
        return
    else:
        instructions = sys.argv[1]
        numIterations = parseInt(sys.argv[2])

    parseXML()
    initRegAddrs()

    if instructions == 'ctp7':
        subheading('Testing CTP7')
        regTest(REG_CTP7_BOARD_ID, 0xbeef, 0xffff, True, numIterations, True)
    elif instructions == 'vfat':
        if len(sys.argv) < 5:
            print('for VFAT testing please also provide the OH number and VFAT number e.g. for OH0 and VFAT #8 use the following command: evkatest.py vfat 100000 0 8')
            return
        ohIdx = parseInt(sys.argv[3])
        vfatIdx = parseInt(sys.argv[4])
        subheading('Testing VFAT #%d on OH #%d' % (vfatIdx, ohIdx))
        regAddr = REG_OH0_VFAT0_LATENCY + ((ohIdx * 0x00010000) << 2) + ((vfatIdx * 0x00000800) << 2)
        print "reg addr = " + hex(regAddr)
        regTest(regAddr, 0xabc, 0x0000ffff, True, numIterations, True)
 

def initRegAddrs():
    global REG_CTP7_BOARD_ID
    global REG_OH0_VFAT0_LATENCY
    REG_CTP7_BOARD_ID = getNode('GEM_AMC.GEM_SYSTEM.BOARD_ID').real_address
    REG_OH0_VFAT0_LATENCY = getNode('GEM_AMC.OH.OH0.GEB.VFAT0.CFG_GLOBAL_LATENCY').real_address

def regTest(regAddress, initValue, regMask, doInitWrite, numIterations, doRandomWrites):
    if (doInitWrite):
        wReg(regAddress, initValue)

    busErrors = 0
    valueErrors = 0

    timeStart = clock()
    for i in range(0, numIterations):
        if doRandomWrites:
            initValue = random.randint(0, 1023)
            wReg(regAddress, initValue)
        value = rReg(regAddress) & regMask
        if value != initValue & regMask:
            if value == 0xdeaddead & regMask:
                busErrors += 1
                printRed("Bus error.. :/ got this value here: " + hex(value))
            else:
                valueErrors += 1
                printRed("Value error. Expected " + hex(initValue & regMask) + ", got " + hex(value) + " in iteration #" + str(i))
                value = rReg(regAddress) & regMask
                printRed("Repeated read gave this value = " + hex(value))

    totalTime = clock() - timeStart
        
    printCyan("Test finished " + str(numIterations) + " iterations in " + str(totalTime) + " seconds. Bus errors = " + str(busErrors) + ", value errors = " + str(valueErrors))

def check_bit(byteval,idx):
    return ((byteval&(1<<idx))!=0);

def debug(string):
    if DEBUG:
        print('DEBUG: ' + string)

def debugCyan(string):
    if DEBUG:
        printCyan('DEBUG: ' + string)

def heading(string):                                                                    
    print Colors.BLUE                                                             
    print '\n>>>>>>> '+str(string).upper()+' <<<<<<<'
    print Colors.ENDC                   
                                                      
def subheading(string):                         
    print Colors.YELLOW                                        
    print '---- '+str(string)+' ----',Colors.ENDC                    
                                                                     
def printCyan(string):                                                
    print Colors.CYAN                                    
    print string, Colors.ENDC                                                                     
                                                                      
def printRed(string):                                                                                                                       
    print Colors.RED                                                                                                                                                            
    print string, Colors.ENDC                                           

def hex(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0x}".format(number)

def binary(number, length):
    if number is None:
        return 'None'
    else:
        return "{0:#0{1}b}".format(number, length + 2)

if __name__ == '__main__':
    main()
