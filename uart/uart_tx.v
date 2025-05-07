module uart_tx
#(parameter CLK_PER_BIT)
(
	input	clk, //obvious
	input	i_start_tx, //set to high to start transmission
	input  [7:0] i_data, // data to be transmitted
	output o_busy, // busy flag
	output o_done, // done flag
	output	reg o_tx,// bits to be transmitted
	output [1:0] o_state
	);
	reg	[7:0]	r_data;
	reg	[1:0] r_state;
	reg	[2:0]	r_bit_index;
	reg	[7:0]	r_clk_count;
	reg				r_done;
	reg				r_busy;
	parameter	s_idle	=2'b00; // wait for i_start_tx
	parameter	s_start	=2'b01; //	send start bit 
	parameter	s_trans	=2'b11; // send data
	parameter	s_end		=2'b10; //send end bit

	always @(posedge clk)
	begin
		case (r_state)
			s_idle:
				begin
					o_tx				<=1'b1;
					r_done			<=1'b1;
					r_busy			<=1'b0;
					r_bit_index	<=0;
					r_clk_count	<=0;
					r_data			<=i_data;
					if (i_start_tx==1'b1)
						begin
							r_state	<=s_start;
							r_busy	<=1'b1;
							r_done	<=1'b0;
						end else r_state <=s_idle;
				end
				s_start:
					begin
						r_done	<=1'b0;
						r_busy	<=1'b1;
						o_tx		<=1'b0;
						if (r_clk_count<CLK_PER_BIT-1)
							begin
								r_clk_count	<=r_clk_count+1;
								r_state			<=s_start;
							end else begin
									r_clk_count	<=0;
									r_state			<=s_trans;
								end
					end
					s_trans:
						begin
							o_tx	<=r_data[r_bit_index];
							if (r_clk_count<CLK_PER_BIT-1)
								begin
									r_clk_count	<=r_clk_count+1;
									r_state			<=s_trans;
								end else r_clk_count	<=0;
							if (r_clk_count<7)
								begin
									r_bit_index	<=r_bit_index+1;
									r_state			<=s_trans;
								end else begin
									r_bit_index	<=0;
									r_state			<=s_end;
								end
						end
					s_end:
						begin
							o_tx	<=1;
							if (r_clk_count<CLK_PER_BIT-1)
								begin
									r_clk_count	<=r_clk_count+1;
									r_state			<=s_end;
								end else begin
									r_done	<=1;
									r_busy	<=0;
									r_state	<=s_idle;
								end
						end
					default: r_state	<=s_idle;
		endcase
	end
		assign o_done	=r_done;
		assign o_busy	=r_busy;
		assign o_state=r_state;
	endmodule
