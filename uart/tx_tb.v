`timescale 1ns/10ps

module tx_tb ();
	parameter	c_CLK_PER_BIT		=87;

	reg clk=0;
	reg i_start_tx =0;
	reg [7:0] i_data=0;
	wire o_tx;
	wire o_done;
	wire o_busy;
	wire [1:0] o_state=0;

	always #50 clk = ~clk;

	uart_tx #(.CLK_PER_BIT(c_CLK_PER_BIT)
	) dut (
			.clk(clk),
			.i_start_tx(i_start_tx),
			.i_data(i_data),
			.o_done(o_done),
			.o_busy(o_busy),
			.o_tx(o_tx),
			.o_state(o_state)
		);

		initial begin
			$dumpfile("tx_tb.vcd");
			$dumpvars(0,tx_tb);
			i_start_tx=0;
			i_data=8'b10101011;
			#200;
			i_start_tx=1;
			#100;
			i_start_tx=0;
			wait (o_done==1);
			#200;
			$finish;
		end
endmodule
