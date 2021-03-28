.text
MAIN:
	auipc s0,0xFC10
	addi s1,s0,0x0024 # tx
	addi s2,s0,0x0028 # tx_data
	#addi s3,s0,0x002C # rx ready
	#addi s4,s0,0x0030 # rx_data
	#addi s5,s0,0x0034 # clean rx
	addi a0,zero,97
	addi a2,zero,98
	addi a1,zero,1
	sw a0,0(s2)
	sw a1,0(s1)
	sw zero,0(s1)
	sw a2,0(s2)
	sw a1,0(s1)

	

