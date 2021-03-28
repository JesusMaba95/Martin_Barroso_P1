.text
MAIN:
	auipc s0,0xFC10
	addi s1,s0,0x0024 # tx
	addi s2,s0,0x0028 # tx_data
	addi s3,s0,0x002C # rx ready
	addi s4,s0,0x0030 # rx_data
	addi s5,s0,0x0034 # clean rx
START:
	addi t0,zero,1
RX_READY:
	lw  a0,0(s3)
	bne a0,t0,RX_READY
	lw a1,0(s4) #get rx data
	sw t0,0(s5)#set clean_Rx
	sw zero,0(s5)#clear clean_rx
	sw a1,0(s2) #set tx data
	sw t0,0(s1)#set tx
	sw zero,0(s1)#clean_tx
	jal START
	