module spi_master
#(parameter NUM_SLAVES, parameter NUM_SLAVES_BIT)
(
	input clk,
	input i_miso,
	output o_mosi,
	output o_sclk,
	output [NUM_SLAVES-1:0] o_ss
	);
	reg [7:0] r_i_data;//recieved data
	reg [7:0] r_o_data;//data to be sent
	reg [NUM_SLAVES_BIT:0] r_ss;
	reg [2:0] r_bit_index;
	reg [1:0] r_state;
	reg r_done;
	localparam s_idle		= 2'b00;//only send sclk
	localparam s_start	= 2'b01;//chip select
	localparam s_com		= 2'b11;//send and receive
	localparam s_stop		= 2'b10;//stop
	//state machine
	//o_mosi
	always @(posedge clk) begin
		if (r_state == s_com) begin
			//code
		end
	end
	//i_miso
	always @(posedge clk) begin
		if (r_state == s_com) begin
			//code
		end
	end


endmodule 

