module spi_master
(
	input clk,
	input reg i_enable,
	input reg i_miso,
	output reg o_sclk,
	output reg o_ss,
	output reg o_done,
	output reg o_mosi
	);
	reg [7:0] r_i_data;//recieved data
	reg [0:7] r_o_data;//data to be sent
	reg [2:0] r_input_bit_index;
	reg [2:0] r_output_bit_index;
	//control
	always @(posedge clk) begin
		if (i_enable == 1'b1) begin
			o_done <= 1'b0;
			o_ss <= 1'b1;
		end else begin
			o_done <= 1'b1;
			o_ss <= 1'b0;
		end
	end
	//o_mosi
	always @(posedge clk) begin
		if (i_enable == 1'b1) begin
			if (r_output_bit_index<7) begin
				o_mosi <= r_o_data[r_output_bit_index];
				r_output_bit_index <= r_output_bit_index+1;
			end else r_output_bit_index <= 0;
		end
	end
	//i_miso
	always @(posedge clk) begin
		if (i_enable == 1'b1) begin
			if(r_input_bit_index<7) begin
				r_i_data[r_input_bit_index] <= i_miso;
				r_input_bit_index <= r_input_bit_index + 1;
			end else r_input_bit_index <=0;
		end
	end
endmodule 
