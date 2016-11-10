from rw_reg import *
from mcs import *
from time import *

SLEEP_BETWEEN_COMMANDS=0.1
DEBUG=False

class Colors:            
    WHITE   = '\033[97m' 
    CYAN    = '\033[96m' 
    MAGENTA = '\033[95m' 
    BLUE    = '\033[94m' 
    YELLOW  = '\033[93m' 
    GREEN   = '\033[92m' 
    RED     = '\033[91m' 
    ENDC    = '\033[0m'  

class Virtex6Instructions:
    FPGA_ID     = 0x3C9
    USER_CODE   = 0x3C8
    SYSMON      = 0x3F7
    BYPASS      = 0x3FF
    CFG_IN      = 0x3C5
    CFG_OUT     = 0x3C4
    SHUTDN      = 0x3CD
    JPROG       = 0x3CB
    JSTART      = 0x3CC
    ISC_NOOP    = 0x3D4
    ISC_ENABLE  = 0x3D0
    ISC_PROGRAM = 0x3D1
    ISC_DISABLE = 0x3D6

    
VIRTEX6_FIRMWARE_SIZE = 5464972
VIRTEX6_FPGA_ID = 0x6424a093

ADDR_JTAG_LENGTH = None
ADDR_JTAG_TMS = None
ADDR_JTAG_TDO = None
ADDR_JTAG_TDI = None

def main():

    instructions=""

    if len(sys.argv) < 2:
        print('Usage: sca.py <instructions>')
        print('instructions:')
        print('  contains r:        SCA reset will be done')
        print('  contains h:        FPGA hard reset will be done')
        print('  contains hh:       FPGA hard reset will be asserted and held')
        print('  contains fpga-id:  FPGA ID will be read through JTAG')
        return
    else:
        instructions = sys.argv[1]

    parseXML()
    initJtagRegAddrs()

    heading("Hola, I'm SCA controller tester :)")

    if not checkStatus():
        printRed('ERROR: SCA Controller is not ready..')
        if not 'r' in instructions:
            exit()

    if instructions == 'r':
        subheading('Reseting the SCA')
        writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MODULE_RESET'), 0x1)
    elif instructions == 'hh':
        subheading('Disabling monitoring')
        writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.ADC_MONITORING.MONITORING_OFF'), 0x1)
        sleep(0.01)
        subheading('Asserting FPGA Hard Reset (and keeping it in reset)')
        sendScaCommand(0x2, 0x10, 0x4, 0x0, False)
    elif instructions == 'h':
        subheading('Issuing FPGA Hard Reset')
        writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.FPGA_HARD_RESET'), 0x1)
    elif instructions == 'fpga-id':
        enableJtag()

        errors = 0
        timeStart = clock()
        for i in range(0,1):
            value = jtagCommand(True, Virtex6Instructions.FPGA_ID, 10, 0x0, 32, True)
            print('FPGA ID = ' + hex(value))
            if value != VIRTEX6_FPGA_ID:
                errors += 1
        
        totalTime = clock() - timeStart
        printCyan('Num errors = ' + str(errors) + ', time took = ' + str(totalTime))

        disableJtag()

    elif instructions == 'sysmon':
        enableJtag(2)

        while True:
            jtagCommand(True, Virtex6Instructions.SYSMON, 10, 0x04000000, 32, False)
            adc1 = jtagCommand(False, None, 0, 0x04010000, 32, True)
            adc2 = jtagCommand(False, None, 0, 0x04020000, 32, True)
            adc3 = jtagCommand(False, None, 0, 0x04030000, 32, True)
            jtagCommand(True, Virtex6Instructions.BYPASS, 10, None, 0, False)

            coreTemp = ((adc1 >> 6) & 0x3FF) * 503.975 / 1024.0-273.15
            volt1 = ((adc2 >> 6) & 0x3FF) * 3.0 / 1024.0
            volt2 = ((adc3 >> 6) & 0x3FF) * 3.0 / 1024.0

            #printCyan('adc1 = ' + hex(adc1) + ', adc2 = ' + hex(adc2) + ', adc3 = ' + hex(adc3))
            printCyan('Core temp = ' + str(coreTemp) + ', voltage #1 = ' + str(volt1) + ', voltage #2 = ' + str(volt2))

            sleep(0.5)

        disableJtag()

    elif instructions == 'program-fpga':
        if len(sys.argv) < 3:
            print("Usage: sca.py program-fpga <filename>")
            return

        filename = sys.argv[2]
        bytes = readMcs(filename)
        if len(bytes) < VIRTEX6_FIRMWARE_SIZE:
            raise ValueError("MCS file is too short.. For Virtex6 we expect it to be " + str(VIRTEX6_FIRMWARE_SIZE) + " bytes long")

        blocks = VIRTEX6_FIRMWARE_SIZE / 4


        timeStart = clock()
        enableJtag(2)

        value = jtagCommand(True, Virtex6Instructions.FPGA_ID, 10, 0x0, 32, True)
        sleep(0.0001)
        print('FPGA ID = ' + hex(value))
        if value != VIRTEX6_FPGA_ID:
            raise ValueError("Bad FPGA-ID (should be " + hex(VIRTEX6_FPGA_ID) + ")... Hands off...")

        jtagCommand(False, Virtex6Instructions.SHUTDN, 10, None, 0, False)

        # send 400 empty clocks
        wReg(ADDR_JTAG_LENGTH, 0x00)
        for i in range(0, 4):
            wReg(ADDR_JTAG_TMS, 0x00000000)
        for i in range(0, 12):
            wReg(ADDR_JTAG_TDO, 0x00000000)
        wReg(ADDR_JTAG_LENGTH, 0x10)
        wReg(ADDR_JTAG_TDO, 0x00000000)

        sleep(0.01)

        jtagCommand(False, Virtex6Instructions.JPROG, 10, None, 0, False)
        jtagCommand(False, Virtex6Instructions.ISC_NOOP, 10, None, 0, False)
        sleep(0.01)
        jtagCommand(False, Virtex6Instructions.ISC_ENABLE, 10, 0x00, 5, False)

        # 128 empty clocks
        wReg(ADDR_JTAG_LENGTH, 0x00)
        for i in range(0, 4):
            wReg(ADDR_JTAG_TMS, 0x00000000)
            wReg(ADDR_JTAG_TDO, 0x00000000)

        sleep(0.0005)

        jtagCommand(False, Virtex6Instructions.ISC_PROGRAM, 10, None, 0, False)
        sleep(0.001)

        print("sending data...")

        # send the data

        tms = 0b001
        tdo = 0b000
        wReg(ADDR_JTAG_LENGTH, 3)
        wReg(ADDR_JTAG_TMS, tms & 0xffffffff)
        wReg(ADDR_JTAG_TDO, tdo & 0xffffffff)

        tms = 0b001011 << 31
        wReg(ADDR_JTAG_LENGTH, 37)
        wReg(ADDR_JTAG_TMS, tms & 0xffffffff)
        tms = tms >> 32
        wReg(ADDR_JTAG_TMS, tms & 0xffffffff)

        cnt = 0
        for i in range(1, blocks):
            if i == blocks - 1:
                tms = 0b011 << 31
                wReg(ADDR_JTAG_LENGTH, 34)
                wReg(ADDR_JTAG_TMS, tms & 0xffffffff)
                tms = tms >> 32
                wReg(ADDR_JTAG_TMS, tms & 0xffffffff)

            wReg(ADDR_JTAG_TDO, (bytes[i*4 + 2] << 24) + (bytes[i*4 + 3] << 16) + (bytes[i*4] << 8) + (bytes[i*4 + 1]))
            wReg(ADDR_JTAG_TDO, 0x0)
            #jtagCommand(False, None, 0, (bytes[i*4 + 2] << 24) + (bytes[i*4 + 3] << 16) + (bytes[i*4] << 8) + (bytes[i*4 + 1]), 32, False)
            #sleep(0.000032)
            cnt += 1
            if cnt >= 1000:
               print("block " + str(i) + " out of " + str(blocks))
               cnt = 0

        print("DONE sending data")

        jtagCommand(False, Virtex6Instructions.ISC_DISABLE, 10, None, 0, False)
        # 128 empty clocks
        wReg(ADDR_JTAG_LENGTH, 0x00)
        for i in range(0, 4):
            wReg(ADDR_JTAG_TMS, 0x00000000)
            wReg(ADDR_JTAG_TDO, 0x00000000)

        sleep(0.0001)

        jtagCommand(False, Virtex6Instructions.BYPASS, 10, None, 0, False)
        jtagCommand(False, Virtex6Instructions.JSTART, 10, None, 0, False)

        # 128 empty clocks
        wReg(ADDR_JTAG_LENGTH, 0x00)
        for i in range(0, 4):
            wReg(ADDR_JTAG_TMS, 0x00000000)
            wReg(ADDR_JTAG_TDO, 0x00000000)

        sleep(0.0005)

        jtagCommand(True, Virtex6Instructions.BYPASS, 10, None, 0, False)

        print("FPGA programming DONE!!")

        disableJtag()

        totalTime = clock() - timeStart
        printCyan('time took to program = ' + str(totalTime))

    elif instructions == 'test1':
        timeStart = clock()
        nn = getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI')
        for i in range(0,1000000):
            #print(str(i))
            #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_CHANNEL'), 0x02)                                                                              
            #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_COMMAND'), 0x10)                                                                              
            #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_LENGTH'), 0x4)                                                                               
            #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_DATA'), 0x0)                                                                                           
            
            #readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI'))
            wReg(ADDR_JTAG_TMS, 0x00000000)

            #sleep(0.01)
            #print('execute')
            #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_EXECUTE'), 0x1)          
        totalTime = clock() - timeStart
        printCyan('time took = ' + str(totalTime))
        
    elif instructions == 'test2':
        timeStart = clock()                                                              
        nn = getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI')                                
        for i in range(0,10000):
            print(str(i))
            sleep(0.001)
            writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.FPGA_HARD_RESET'), 0x1)            

def initJtagRegAddrs():
    global ADDR_JTAG_LENGTH
    global ADDR_JTAG_TMS
    global ADDR_JTAG_TDO
    global ADDR_JTAG_TDI
    ADDR_JTAG_LENGTH = getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.NUM_BITS').real_address
    ADDR_JTAG_TMS = getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TMS').real_address
    ADDR_JTAG_TDO = getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDO').real_address
    ADDR_JTAG_TDI = getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI').real_address

# freqDiv -- JTAG frequency expressed as a divider of 20MHz, so e.g. a value of 2 would give 10MHz, value of 10 would give 2MHz
def enableJtag(freqDiv=None):
    subheading('Disabling SCA ADC monitoring')                                                                                          
    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.ADC_MONITORING.MONITORING_OFF'), 0x1)                                                    
    sleep(0.01)                                                                                                                         
    subheading('Enable JTAG module')                                                                                                    
    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.ENABLE'), 0x1)                                                                      

    if freqDiv is not None:
        subheading('Setting JTAG CLK frequency to ' + str(20 / (freqDiv)) + 'MHz (divider value = ' + hex((freqDiv - 1) << 24) + ')')
        sendScaCommand(0x13, 0x90, 0x4, (freqDiv - 1) << 24, False)


def disableJtag():
    subheading('Disabling JTAG module')                                                                                                 
    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.ENABLE'), 0x0)                                                                      
#    subheading('Enabling SCA ADC monitoring')                                                                                           
#    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.ADC_MONITORING.MONITORING_OFF'), 0x0)                                                    


# restoreIdle -- if True then will restore to IDLE state before doing anything else
# ir          -- instruction register, set it to None if it's not needed to shift the instruction register
# irLen       -- number of bits in the instruction register
# dr          -- data register, set it to None if it's not needed to shift the data register
# drLen       -- number of bits in the data register
# drRead      -- read the TDI during the data register shifting
def jtagCommand(restoreIdle, ir, irLen, dr, drLen, drRead):
    totalLen = 0
    if ir is not None:
        totalLen += irLen + 6       # instruction register length plus 6 TMS bits required to get to the IR shift state and back to IDLE
    if dr is not None:
        totalLen += drLen + 5       # data register length plus 5 TMS bits required to get to the DR shift state and back to IDLE
    if restoreIdle:
        totalLen += 6
    if totalLen > 128:
        raise ValueError('JTAG command request needs more than 128 bits -- not possible. Please break up your command into smaller pieces.')

    tms = 0
    tdo = 0
    len = 0
    readIdx = 0
    
    if restoreIdle:
        tms = 0b011111
        len = 6

    if ir is not None:
        tms |= 0b0011 << len         # go to IR SHIFT state
        len += 4
        tdo |= ir << len
        tms |= 0b1 << (irLen - 1 + len)  # exit IR shift
        len += irLen
        tms |= 0b01 << len    # update IR and go to IDLE
        len += 2

    if dr is not None:
        tms |= 0b001 << len    # go to DR SHIFT state
        len += 3
        readIdx = len
        tdo |= dr << len
        tms |= 0b1 << (drLen -1 + len) # exit DR shift
        len += drLen
        tms |= 0b01 << len     # update DR and go to IDLE
        len += 2
        

    debug('Length = ' + str(len))
    debug('TMS = ' + binary(tms, len))
    debug('TDO = ' + binary(tdo, len))
    debug('Read start index = ' + str(readIdx))
    
    debugCyan('Setting command length = ' + str(len))
    fw_len = len if len < 128 else 0 # in firmware 0 means 128 bits
    #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.NUM_BITS'), fw_len)
    wReg(ADDR_JTAG_LENGTH, fw_len)

    # ================= SENDING LENGTH COMMAND JUST FOR TEST!! ===================
    #debugCyan('Setting config registers: bit number = ' + hex(fw_len))                                               
    #sendScaCommand(0x13, 0x80, 0x4, 0xc00 | (fw_len << 24), False) # TX falling edge, shift LSB first, and set length
    # ============================================================================

    #raw_input("press any key to send tms and tdo")

    debugCyan('Setting TMS 0 = ' + binary(tms & 0xffffffff, 32))
    #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TMS'), tms0)
    wReg(ADDR_JTAG_TMS, tms & 0xffffffff)

    debugCyan('Setting TDO 0 = ' + binary(tdo & 0xffffffff, 32))
    #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDO'), tdo0)
    wReg(ADDR_JTAG_TDO, tdo & 0xffffffff)

    if len > 32:
        tms = tms >> 32
        debugCyan('Setting TMS 1 = ' + binary(tms & 0xffffffff, 32))
        #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TMS'), tms1)
        wReg(ADDR_JTAG_TMS, tms & 0xffffffff)

        #raw_input("press any key to send the last TDO")

        tdo = tdo >> 32
        debugCyan('Setting TDO 1 = ' + binary(tdo & 0xffffffff, 32))
        #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDO'), tdo1)
        wReg(ADDR_JTAG_TDO, tdo & 0xffffffff)

    if len > 64:                                                               
        tms = tms >> 32                                                                                                                 
        debugCyan('Setting TMS 2 = ' + binary(tms & 0xffffffff, 32))
        #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TMS'), tms2)
        wReg(ADDR_JTAG_TMS, tms & 0xffffffff)

        tdo = tdo >> 32                                                                                           
        debugCyan('Setting TDO 2 = ' + binary(tdo & 0xffffffff, 32))
        #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDO'), tdo2)
        wReg(ADDR_JTAG_TDO, tdo & 0xffffffff)

    if len > 96:                                                                                                                                                          
        tms = tms >> 32                                                                                                                                                   
        debugCyan('Setting TMS 3 = ' + binary(tms & 0xffffffff, 32))
        #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TMS'), tms3)
        wReg(ADDR_JTAG_TMS, tms & 0xffffffff)
                                                                                                                                                                          
        tdo = tdo >> 32                                                                                                                                                   
        debugCyan('Setting TDO 3 = ' + binary(tdo & 0xffffffff, 32))
        #writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDO'), tdo3)
        wReg(ADDR_JTAG_TDO, tdo & 0xffffffff)

    # ================= SENDING JTAG GO COMMAND JUST FOR TEST!! ===================                                
    #debugCyan('JTAG GO!')                                                                                                         
    #sendScaCommand(0x13, 0xa2, 0x1, 0x0, False) 
    # ============================================================================                                                        

    #raw_input("Press any key to read TDI...")

    if drRead:
        debugCyan('Read TDI 0')                                                                                  
        tdi = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI')))
        #tdi0_fast = parseInt(rReg(parseInt(ADDR_JTAG_TDI)))
        #print('normal tdi read = ' + hex(tdi0) + ', fast C tdi read = ' + hex(tdi0_fast) + ', parsed = ' + '{0:#010x}'.format(tdi0_fast))
        debug('tdi = ' + hex(tdi))

        if len > 32:
            debugCyan('Read TDI 1')                                                                                                                                          
            tdi1 = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI')))        
            tdi |= tdi1 << 32
            debug('tdi1 = ' + hex(tdi1))
            debug('tdi = ' + hex(tdi))
        
        if len > 64:                                                                                                                                                      
            debugCyan('Read TDI 2')                                                                                                                                       
            tdi2 = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI')))                                                                                                             
            tdi |= tdi2 << 64
            debug('tdi2 = ' + hex(tdi2))                                                                                          
            debug('tdi = ' + hex(tdi)) 

        if len > 96:                                                                                                                                                      
            debugCyan('Read TDI 3')                                                                                                                                       
            tdi3 = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.JTAG.TDI')))                                                                                                             
            tdi |= tdi3 << 96
            debug('tdi3 = ' + hex(tdi3))                                                                                          
            debug('tdi = ' + hex(tdi)) 

        readValue = (tdi >> readIdx) & (0xffffffffffffffffffffffffffffffff >> (128  - drLen))
        debug('Read pos = ' + str(readIdx))
        debug('Read = ' + hex(readValue))
        return readValue
    else:
        return 0

    
def sendScaCommand(sca_channel, sca_command, data_length, data, doRead):
    #print('fake send: channel ' + hex(sca_channel) + ', command ' + hex(sca_command) + ', length ' + hex(data_length) + ', data ' + hex(data) + ', doRead ' + str(doRead))
    #return    

    d = data

    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_CHANNEL'), sca_channel)
    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_COMMAND'), sca_command)
    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_LENGTH'), data_length)
    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_DATA'), d)
    writeReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_CMD_EXECUTE'), 0x1)
    reply = 0
    if doRead:
        reply = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.MANUAL_CONTROL.SCA_RPY_DATA')))
    return reply

def checkStatus():
    rxReady       = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.STATUS.READY')))
    criticalError = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.STATUS.CRITICAL_ERROR')))
    return (rxReady == 1) and (criticalError == 0)

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
