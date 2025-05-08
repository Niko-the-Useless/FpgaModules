`timescale 1ns/10ps

module uart_tb ();
	parameter	c_CLK_PER_BIT		=87;

	reg clk=0;
	reg i_start_tx =0;
	reg [7:0] i_data=0;
	wire o_tx;
	wire o_tx_done;
	wire o_tx_busy;
	wire o_rx_done;
	wire [7:0] o_rx_data;

	always #50 clk = ~clk;

	uart_tx #(.CLK_PER_BIT(c_CLK_PER_BIT)
	) dut_tx (
			.clk(clk),
			.i_start_tx(i_start_tx),
			.i_data(i_data),
			.o_done(o_tx_done),
			.o_busy(o_tx_busy),
			.o_tx(o_tx)
		);

	uart_rx #(.CLK_PER_BIT(c_CLK_PER_BIT)
	) dut_rx (
			.clk(clk),
			.i_rx(o_tx),
			.o_data(o_rx_data),
			.o_done(o_rx_done)
		);

		initial begin
			$dumpfile("uart_tb.vcd");
			$dumpvars(0,uart_tb);
			i_start_tx=0;
			i_data=8'b10101011;
			#200;
			i_start_tx=1;
			#100;
			i_start_tx=0;
			wait (o_tx_done==1);
			wait (o_rx_done==1);
			#200;
			$finish;
		end
endmodule
