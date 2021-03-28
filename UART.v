module UART
(	// Input Ports
	input clk,
	input reset,
	input rx_pin,
	input tx_start,
	input [7:0]tx_data,
	//input clear_rx,
	output [7:0]rx_data,
	// Output Ports
	//output tx_done,
	output tx_pin
);

wire tx_start_w;
wire clk_9600hz;
wire clk_38400hz;
/*
uart_rx_top rx
(
  .clk(clk_38400hz),
  .rst_n(reset),
  .i_Rx_Serial(rx_pin), //data serial 
  .o_Rx_Byte(rx_data_wire), //data
  .o_Rx_DV(data_ready)// data ready INTR
)*/
uart_tx_top tx
(
  .clk(clk_9600hz),
  .rst_n(reset),
  .i_Tx_DV(tx_start),//start
  .i_Tx_Byte(tx_data),//data input [7:0] 
  //.o_Tx_Active(),
  .o_Tx_Serial(tx_pin),
  //.o_Tx_Done(tx_done)
);

Clocks_Uart	Clocks_Uart_inst (
	.areset ( !reset ),
	.inclk0 ( clk ),
	.c0 ( clk_9600hz ),
	.c1 ( clk_38400hz )
	);

endmodule