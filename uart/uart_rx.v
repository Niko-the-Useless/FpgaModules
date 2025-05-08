module uart_rx
#(parameter CLK_PER_BIT)
(
	input clk,
	input i_rx,
	output [7:0] o_data,
	output o_done
	);
	reg r_incoming;
	reg r_rx;
	reg r_done;
	reg [7:0] r_data;
	reg [7:0] r_clk_count;
	reg [2:0] r_bit_index;
	reg [1:0] r_state;
	localparam s_idle=2'b00;
	localparam s_start=2'b01;
	localparam s_recieve=2'b11;
	localparam s_stop=2'b10;

	//fix metastability issues
	always @(posedge clk) begin
		r_incoming <= i_rx;
		r_rx <= r_incoming;
	end

	//state machine
	always @(posedge clk) begin
		case (r_state)
			s_idle:
				begin
					r_done <= 1;
					r_state <= s_idle;
					r_clk_count <= 0;
					r_bit_index <= 0;
					if (~r_rx)
						begin
							r_state <= s_start;
							r_done <= 0;
						end else r_state <= s_idle;
					end
			s_start:
				begin
					if (r_clk_count==((CLK_PER_BIT-1)/2))
						begin
							if (r_rx) r_state <= s_idle;
							else begin
								r_state <= s_recieve;
								r_clk_count <= 0;
							end
						end else begin
							r_clk_count <= r_clk_count+1;
							r_state <= s_start;
						end
				end
			s_recieve:
				begin
					if (r_clk_count==(CLK_PER_BIT-1))
						begin
							r_data[r_bit_index] <= r_rx;
							r_clk_count <= 0;
							r_bit_index	<= r_bit_index+1;
							if (r_bit_index == 7) r_state <= s_stop;
						end else begin
							r_clk_count <= r_clk_count+1;
							r_state <= s_recieve;
							end
				end 
			s_stop:
				begin
					if (r_clk_count==(CLK_PER_BIT-1))
						begin
							r_clk_count <= 0;
							if (r_rx == 1)
								begin
									r_state <= s_idle;
								end
							end else begin
								r_clk_count <= r_clk_count+1;
								r_state <= s_stop;
								end
				end
			default: r_state<=s_idle;
		endcase
	end

	//ouputs
	assign o_done = r_done;
	assign o_data = r_data;
endmodule
