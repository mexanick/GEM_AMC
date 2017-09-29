#!/usr/bin/env python

# ============== slow control data ================

#INPUT_DATA = 0x00000a64000000872001bb1f0300 # real TX HDLC data
#INPUT_DATA =  0x2001bb100300 # real RX HDLC data without CRC
# INPUT_DATA =  0xb2dc2001bb100300 # real RX HDLC data with CRC
#INPUT_DATA =  0xbb4c2001ac100300 # another example of real RX HDLC data with CRC
#INPUT_DATA =  0xe8e500000b20200101000300 # yet another example of real RX HDLC data with CRC
#INPUT_DATA =  0x3eaf00000b20200131000300 # yet another example of real RX HDLC data with CRC
#INPUT_DATA =  0xc15000000b20200131000300 # the above packet but with CRC inverted -- results in 0x0000 !!!!!!!!

#NUM_BITS = 112
#NUM_BITS = 64
NUM_BITS = 96

# ============== DAQ control data ================

INPUT_DATA = 0xb34a00000000000000000000000000000000f501011e # real DAQ event with header
#INPUT_DATA = 0xace600000000000000000000000000000000f501031e # real DAQ event with header
#INPUT_DATA = 0xb3dc00000000000000000000000000000000f501041e # real DAQ event with header

NUM_BYTES = 22

DAQ_POLY = 0x1021
HENRI_POLY = 0x8408

def main():
    crc = 0xffff

    #test
    # bit_value = check_bit(INPUT_DATA, 2)
    # data = 0x20 | (bit_value << 2)
    # print hex(data)

    #SCA version
    # WORKS WHEN CRC IS INVERTED IN THE DATA
    # for i in range(0, NUM_BITS):
    #     bit_value = check_bit(INPUT_DATA, i)
    #     crc_temp = (crc << 1) | bit_xor(bit_value, check_bit(crc, 15))
    #     crc_temp = crc_temp & 0xefdf
    #     crc_temp = crc_temp | (bit_xor(check_bit(crc, 4), bit_xor(bit_value, check_bit(crc, 15))) << 5)
    #     crc_temp = crc_temp | (bit_xor(check_bit(crc, 11), bit_xor(bit_value, check_bit(crc, 15))) << 12)
    #     crc = crc_temp
    #     print("tmp CRC: " + hex(crc))
    #
    # print("--------------------------------------")
    # print("real CRC: " + hex(crc))
    # print("inverted CRC: " + hex(invert(crc, 16)))


    #DAQ CRC from Henri (crc_ccitt.v)
    data = INPUT_DATA
    for i in range(0, NUM_BYTES):
        byte = data & 0xff
        data = data >> 8
        print("byte %i (%s)" % (i, hex(byte)))
        for j in range(7, -1, -1):
            if bit_xor(check_bit(byte, j), check_bit(crc, 15) == True):
                crc = ((crc << 1) & 0xffff) ^ DAQ_POLY
            else:
                crc = (crc << 1) & 0xffff
            print("tmp CRC: " + hex(crc))
    print("--------------------------------------")
    print("real CRC: " + hex(crc))
    print("inverted CRC: " + hex(invert(crc, 16)))



    # for i in range(0, NUM_BITS):
    #     bit_value = check_bit(INPUT_DATA, i)
    #
    #     temp_data = 0x96
    #     if (bit_value):
    #         temp_data = 0x99
    #
    #     for j in range(0, 8):
    #         bit_value = check_bit(temp_data, j)
    #         if (bit_xor(bit_value, check_bit(crc, 15)) == True):
    #             crc_temp = (crc << 1) | bit_xor(bit_value, check_bit(crc, 15))
    #             crc_temp = crc_temp & 0xefdf
    #             crc_temp = crc_temp | (bit_xor(check_bit(crc, 4), bit_xor(bit_value, check_bit(crc, 15))) << 5)
    #             crc_temp = crc_temp | (bit_xor(check_bit(crc, 11), bit_xor(bit_value, check_bit(crc, 15))) << 12)
    #         else:
    #            crc_temp = (crc << 1) & 0xffff
    #     crc = crc_temp
    #
    # print hex(crc)

    #crc16_8 version from Henri
    # for i in range(0, NUM_BITS):
    #     bit_value = check_bit(INPUT_DATA, i)
    #
    #     enc_data = 0x96
    #     if (bit_value):
    #         enc_data = 0x99
    #
    #     for j in range(0, 8):
    #         bit_value = check_bit(enc_data, j)
    #         crc_temp = (crc >> 1)
    #         if (bit_xor(bit_value, check_bit(crc, 0)) == True):
    #             crc_temp = crc_temp & 0x7bf7
    #             crc_temp = crc_temp | (bit_xor(bit_value, check_bit(crc, 0)) << 15)
    #             crc_temp = crc_temp | (bit_xor(check_bit(crc, 11), bit_xor(bit_value, check_bit(crc, 0))) << 10)
    #             crc_temp = crc_temp | (bit_xor(check_bit(crc, 4), bit_xor(bit_value, check_bit(crc, 0))) << 3)
    #     crc = crc_temp
    #
    # print hex(crc)

    #Henri's code:
    # WORKS FOR SLOW CONTROL
    # crc = crc_remainder([0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,1,0,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    #
    # crc_bin = bin(crc)
    # crc_bin = crc_bin[2:]
    # crc_len = len(crc_bin)
    # crc_bin = (16 - crc_len) * '0' + crc_bin
    # crc_bin = list(crc_bin)
    # crc_bin = [int(i) for i in crc_bin]
    # # crc_bin.reverse()
    # crc = []
    # for i in crc_bin:
    #     if i == 0:
    #         crc.append(1)
    #     elif i == 1:
    #         crc.append(0)
    #
    # for i in range(0, 16):
    #     print(crc[i])

#Henri's code:
def crc_remainder(input_package):
    polynomial_bitstring = 4129
    crc = 65535

    input_package_len = len(input_package)/8

    for j in range(0,input_package_len):
        input_bitstring = input_package[(j*8):((j+1)*8)]
        input_bitstring.reverse()
        input_bitstring = ''.join(str(e) for e in input_bitstring)

        for i in range(7,-1,-1):

            crc_bin = bin(crc)				# Convert CRC dec to bin.
            crc_bin = crc_bin[2:]			#
            crc_len = len(crc_bin)			#
            crc_bin = (16-crc_len)*'0' + crc_bin	#

            if int(input_bitstring[i],2)^int(crc_bin[0],2) == 1:

                crc_bin = crc_bin[1:]+'0'
                crc = int(crc_bin,2)
                crc =crc^polynomial_bitstring
            else:
                crc_bin = crc_bin[1:]+'0'
                crc = int(crc_bin,2)
    return crc

def check_bit(byteval,idx):
    return ((byteval&(1<<idx))!=0);

def bit_xor(bit1, bit2):
    return bit1 != bit2

def hex(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0x}".format(number)

def invert(number, num_bits):
    ret = 0
    for i in range(0, num_bits):
        if (not check_bit(number, i)):
            ret += 1 << i
    return ret

if __name__ == '__main__':
    main()
