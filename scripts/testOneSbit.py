from cmd import Cmd
import sys, os, subprocess
from rw_reg import *
import time

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

NOISE_CHECK_SLEEP = 0.001

vfatN = 20
nInj  = 100

if __name__ == '__main__':
#    try:
        if (len(sys.argv) < 2):
            print "Let me know which VFAT you want to run on"
            exit(0)
        else:
            vfatN = int(sys.argv[1])
        
        print "Testing VFAT%i" % vfatN

        parseXML()
        print readReg(getNode("GEM_AMC.OH_LINKS.OH0.GBT0_READY"))
        print readReg(getNode("GEM_AMC.OH_LINKS.OH0.GBT1_READY"))
        print readReg(getNode("GEM_AMC.OH_LINKS.OH0.GBT2_READY"))

        writeReg(getNode("GEM_AMC.GEM_SYSTEM.CTRL.LINK_RESET"),1)

        print "Link good: "
        print readReg(getNode("GEM_AMC.OH_LINKS.OH0.VFAT%i.LINK_GOOD"%vfatN))
        print "Sync Error: "
        print readReg(getNode("GEM_AMC.OH_LINKS.OH0.VFAT%i.SYNC_ERR_CNT"%vfatN))

        #Configure TTC generator on CTP7
        writeReg(getNode("GEM_AMC.TTC.GENERATOR.RESET"),  1)
        writeReg(getNode("GEM_AMC.TTC.GENERATOR.ENABLE"), 1)
        writeReg(getNode("GEM_AMC.TTC.GENERATOR.CYCLIC_CALPULSE_TO_L1A_GAP"), 50)
        writeReg(getNode("GEM_AMC.TTC.GENERATOR.CYCLIC_L1A_GAP"),  500)
        writeReg(getNode("GEM_AMC.TTC.GENERATOR.CYCLIC_L1A_COUNT"),  0)

        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_RUN"%vfatN), 1)
        writeReg(getNode("GEM_AMC.GEM_SYSTEM.VFAT3.VFAT3_RUN_MODE"), 1)

        writeReg(getNode("GEM_AMC.TRIGGER.SBIT_MONITOR.OH_SELECT"), 0)

        writeReg(getNode("GEM_AMC.OH.OH0.TRIG.CTRL.VFAT_MASK"), 0xffffff & ~(1 << (23 - vfatN)))

        print "Configuring VFAT"

        #for i in range(128): writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.VFAT_CHANNELS.CHANNEL%i.CALPULSE_ENABLE"%(vfatN,i)), 0)
        for i in range(128): writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.VFAT_CHANNELS.CHANNEL%i"%(vfatN,i)), 0x4000)  # mask all channels and disable the calpulse

        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_PULSE_STRETCH"%vfatN),           7)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SYNC_LEVEL_MODE"%vfatN),         0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SELF_TRIGGER_MODE"%vfatN),       0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_DDR_TRIGGER_MODE"%vfatN),        0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SPZS_SUMMARY_ONLY"%vfatN),       0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SPZS_MAX_PARTITIONS"%vfatN),     0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SPZS_ENABLE"%vfatN),             0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SZP_ENABLE"%vfatN),              0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SZD_ENABLE"%vfatN),              0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_TIME_TAG"%vfatN),                0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_EC_BYTES"%vfatN),                0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BC_BYTES"%vfatN),                0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_FP_FE"%vfatN),                   7)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_RES_PRE"%vfatN),                 1)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAP_PRE"%vfatN),                 0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_PT"%vfatN),                     15)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_EN_HYST"%vfatN),                 1)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SEL_POL"%vfatN),                 1)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_FORCE_EN_ZCC"%vfatN),            0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_FORCE_TH"%vfatN),                0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_SEL_COMP_MODE"%vfatN),           1)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_VREF_ADC"%vfatN),                3)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_MON_GAIN"%vfatN),                0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_MONITOR_SELECT"%vfatN),          0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_IREF"%vfatN),                   32)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_THR_ZCC_DAC"%vfatN),            10)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_THR_ARM_DAC"%vfatN),            100)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_HYST"%vfatN),                    5)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_LATENCY"%vfatN),                45)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAL_SEL_POL"%vfatN),             1)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAL_PHI"%vfatN),                 0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAL_EXT"%vfatN),                 0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAL_DAC"%vfatN),               50)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAL_MODE"%vfatN),                1)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAL_FS"%vfatN),                  0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_CAL_DUR"%vfatN),               200)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_CFD_DAC_2"%vfatN),         40)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_CFD_DAC_1"%vfatN),         40)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_PRE_I_BSF"%vfatN),         13)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_PRE_I_BIT"%vfatN),        150)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_PRE_I_BLCC"%vfatN),        25)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_PRE_VREF"%vfatN),          86)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_SH_I_BFCAS"%vfatN),       250)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_SH_I_BDIFF"%vfatN),       150)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_SH_I_BFAMP"%vfatN),         0)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_SD_I_BDIFF"%vfatN),       255)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_SD_I_BSF"%vfatN),          15)
        writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.CFG_BIAS_SD_I_BFCAS"%vfatN),       255)

        writeReg(getNode("GEM_AMC.GEM_TESTS.VFAT_DAQ_MONITOR.CTRL.ENABLE"),    1)
        writeReg(getNode("GEM_AMC.GEM_TESTS.VFAT_DAQ_MONITOR.CTRL.OH_SELECT"), 0)
        writeReg(getNode("GEM_AMC.GEM_TESTS.VFAT_DAQ_MONITOR.CTRL.VFAT_CHANNEL_GLOBAL_OR"), 0)

        writeReg(getNode("GEM_AMC.TTC.GENERATOR.CYCLIC_START"), 1)

        addrSbitMonReset = getNode("GEM_AMC.TRIGGER.SBIT_MONITOR.RESET").real_address
        addrCluster = [0]*8
        for i in range(8):
            addrCluster[i] = getNode("GEM_AMC.TRIGGER.SBIT_MONITOR.CLUSTER%i"%i).real_address

        exit = False
        while(not exit):

            channel = int(raw_input("Enter the channel number to pulse"))
            sof_tap = int(raw_input("Enter the SOF tap delay"))
            bit_tap = int(raw_input("Enter the BIT tap delay"))

            writeReg(getNode("GEM_AMC.TTC.GENERATOR.RESET"), 1)

            print "masking all channels except %i" % channel
            for i in range(128): writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.VFAT_CHANNELS.CHANNEL%i" % (vfatN, i)), 0x4000)  # mask all channels and disable the calpulse
            writeReg(getNode("GEM_AMC.OH.OH0.GEB.VFAT%i.VFAT_CHANNELS.CHANNEL%i" % (vfatN, channel)), 0x8000)  # enable calpulse and unmask
            print "setting SOF delay to %i" % sof_tap
            writeReg(getNode("GEM_AMC.OH.OH0.TRIG.TIMING.SOT_TAP_DELAY_VFAT%i"%(23-vfatN)), sof_tap)
            print "setting BIT delay to %i" % bit_tap
            for bit in range(8): writeReg(getNode("GEM_AMC.OH.OH0.TRIG.TIMING.TAP_DELAY_VFAT%i_BIT%i"%((23-vfatN), bit)), bit_tap)

            raw_input("Press enter to start pulsing")
            writeReg(getNode("GEM_AMC.TTC.GENERATOR.CYCLIC_START"), 1)

            exitStr = raw_input("Exit? (Y/N)")
            if exitStr == "Y":
                exit = True

        writeReg(getNode("GEM_AMC.TTC.GENERATOR.RESET"), 1)

#    except Exception as exc:
#        print 'Caught an Exception %s\n'%exc

