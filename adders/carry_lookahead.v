`include "full_adder.v"
module carry_lookahead
	#(parameter WIDTH)
	(
		input [WIDTH-1:0]		i_add1,
		input [WIDTH-1:0]		i_add2,
		output [WIDTH-1:0]	o_res
		);
	wire [WIDTH:0] 		w_carry;
	wire [WIDTH-1:0]	w_g,w_p,w_sum
	genvar	ii;
	generate
		for	(ii=0;ii<WIDTH;ii=ii+1)
		begin
			full_adder full_adder_instance
			(
				.i_bit1(i_add1[ii]),
				.i_bit2(i_add2[ii]),
				.i_carry(w_sum[ii]),
				.o_carry()
				);
			end
	endgenerate
	genvar jj;
	generate
		for (jj=0;jj<WIDTH;jj=jj+1)
			begin
				assign w_g[jj]			= i_add1[jj]&i_add2[jj];
				assign w_p[jj]			= i_add1[jj]|i_add2[jj];
				assign w_carry[jj+1]=w_g[jj]|w_p[jj]&w_carry[jj];
			end 
	endgenerate
	assign w_c[0] = 1'b0;
	assign o_res = {w_c[WIDTH],w_sum};
endmodule
