.text
MAIN:
	auipc s0,0xFC10
	addi s1,s0,0x0024 # tx
	addi s2,s0,0x0028 # tx_data
	addi s3,s0,0x002C # rx ready
	addi s4,s0,0x0030 # rx_data
	addi s5,s0,0x0034 # clean rx
	addi t1,zero,1
RX_NOT_READY:
	lw  a3,0(s3)
	bne a3,t1,RX_NOT_READY
	lw a2,0(s4) #get rx data
	sw t1,0(s5)#set clean_Rx
	sw zero,0(s5)#clear clean_rx
	jal factorial # Calling procedure
	sw a0,0(s2) #set tx data
	sw t1,0(s1)#set tx
	sw zero,0(s1)#clean_tx
	j RX_NOT_READY	# Jump to Main label	
factorial:
	slti t0, a2, 1 # if n < 1
	beq t0, zero, loop # Branch to Loop
	addi a0, zero, 1 # Loading 1
	jr ra # Return to the caller	
loop:	
	addi sp, sp,-8 # Decreasing the stack pointer
	sw ra, 4(sp) # Storing n
	sw a2, 0(sp) #  Storing the resturn address
	addi a2, a2, -1 # Decreasing n
	jal factorial # recursive function
	lw a2, 0(sp) # Loading values from stak
	lw ra, 4(sp) # Loading values from stak
	addi sp, sp, 8 # Increasing stack pointer
	mul a0, a2, a0 # Multiplying n*Factorial(n-1)
	jr ra  # Return to the caller
