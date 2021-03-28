/******************************************************************
* Description
*	RISCV TOP MODULE
* Author:
*	Jesus MArtin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	20/02/2021
******************************************************************/

module RISC_V_Multiciclo
#(
	parameter DATA_WIDTH = 32
)
(
	input clk,
	input reset,
	//input rx,
	//input [31:0]rx_ready,
	//input [31:0]rx_data,
	//output [31:0]clean_rx,
	output clk_out,
	output tx
);

wire[(DATA_WIDTH-1):0]ReadData_w;
wire[(DATA_WIDTH-1):0]Addres_w;
wire[(DATA_WIDTH-1):0]WriteData_w;
wire Mem_Write_w;

wire[(DATA_WIDTH-1):0]Ctrl2ID_ReadData_w;
wire[(DATA_WIDTH-1):0]Ctrl2Rx_ReadData_w;
wire[(DATA_WIDTH-1):0]Ctrl2Rx_ready_ReadData_w;
wire[(DATA_WIDTH-1):0]Ctrl2ID_Addres_w;
wire[(DATA_WIDTH-1):0]CtrlWriteData_w;
wire Ctrl2ID_Mem_Write_w;
wire Ctrl2Tx_enable_w;
wire Ctrl2Tx_data_enable_w;
wire Ctrl2Clean_rx_enable_w;
wire clk_1hz;
wire [(DATA_WIDTH-1):0]tx_start_w;
wire [(DATA_WIDTH-1):0]tx_data_w;
	
	
assign clk_out = clk_1hz;

Clock_Divider clk_divider
(
	// Input Ports
	.clk_in(clk),
	.rst(reset),
	.en(1'b1),
	// Output Ports
	.clk_out(clk_1hz)
);

CORE CORE_i
(
	.clk(clk_1hz),
	.reset(reset),
	.ReadData_i(ReadData_w),
	.Address_o(Addres_w),
	.WriteData_o(WriteData_w),
	.MemWrite_o(Mem_Write_w)
);
MemControl X
(
	. Address(Addres_w),
	.WriteData_in(WriteData_w),
	.MemWrite(Mem_Write_w),
	.ReadData(ReadData_w),
	.ID_Address(Ctrl2ID_Addres_w),
	.WriteData_out(CtrlWriteData_w),
	.ID_MemWrite(Ctrl2ID_Mem_Write_w),
	.Tx_MemWrite(Ctrl2Tx_enable_w),
	.Tx_data_Memwrite(Ctrl2Tx_data_enable_w),
	.Clean_rx_Memwrite(Ctrl2Clean_rx_enable_w),
	.ID_ReadData(Ctrl2ID_ReadData_w),
	.Rx_ReadData(Ctrl2Rx_ReadData_w),
	.Rx_ready_ReadData(Ctrl2Rx_ready_ReadData_w)
);

Register tx_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(Ctrl2Tx_enable_w),
  .DataInput(CtrlWriteData_w),
  .DataOutput(tx_start_w)
  
);
Register tx_data_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(Ctrl2Tx_data_enable_w),
  .DataInput(CtrlWriteData_w),
  .DataOutput(tx_data_w)
  
);
Register rx_ready_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(1'b1),
  .DataInput(rx_ready),
  .DataOutput(Ctrl2Rx_ready_ReadData_w)
  
);
Register rx_data_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(1'b1),
  .DataInput(rx_data),
  .DataOutput(Ctrl2Rx_ReadData_w)
  
);
Register clean_rx_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(Ctrl2Clean_rx_enable_w),
  .DataInput(CtrlWriteData_w),
  .DataOutput(clean_rx)
  
);
Instruction_Data_Memory ID_MEM
(
	.Address(Ctrl2ID_Addres_w),
	.WriteData(CtrlWriteData_w),
	.MemWrite(Ctrl2ID_Mem_Write_w),
	.clk(clk_1hz),
	.ReadData(Ctrl2ID_ReadData_w)
);
UART Uart_i
(	// Input Ports
	.clk(clk),
	.reset(reset),
	//.rx_pin,
	.tx_start(tx_start_w[0]),
	.tx_data(tx_data_w[7:0]),
	//input clear_rx,
	//.rx_data,
	// Output Ports
	//output tx_done,
	.tx_pin(tx)
);
endmodule