module half_adder
	(
		input		i_bit1,
		input		i_bit2,
		output	o_sum,
		output	o_carry
		);
	assign o_sum		=	i_bit1^i_bit2;
	assign o_carry	= i_bit1&i_bit2;
endmodule
