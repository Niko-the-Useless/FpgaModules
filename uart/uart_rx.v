module uart_rx 
#(parameter CLK_PER_BIT)
(
	input		clk,
	input 		i_rx,
	output [7:0] o_data
	);
	
	reg				r_r_data;//incoming data
	reg				r_r;//to fix metastability issues
	reg		[7:0]	r_data;
	reg		[7:0]	r_clk_count;//to check middle of the bit
	reg		[2:0]	r_bit_index;
	reg		[1:0]	r_state;
	
	localparam		s_idle=2'b00;
	localparam		s_start=2'b01;
	localparam	 	s_receive=2'b10;
  localparam		s_stop=2'b11;
	
	always @(posedge clk) begin //fix metastability issues
		r_r_data<=i_rx;
		r_r<=r_r_data;
	end

	always @(posedge clk) begin
		case (r_state)
        	s_idle: begin //if line is high then stay idle
                if (r_r) begin
                    r_state<=s_idle;
                    r_clk_count<=0;
                    r_bit_index<=0;
                end else r_state<=s_start;
            end
            s_start: begin //check if line is low for long enough
                if (r_clk_count==(CLK_PER_BIT-1)/2) begin
                    if (r_r) r_state=s_idle;
                    else begin 
                        r_state<=s_receive;
                        r_clk_count=0;
                    end
                end else begin
                    r_clk_count<=r_clk_count+1;
                    r_state<=s_start;
                end
            end
            s_receive: begin //wait for middle of bit and apend it to register
                if (r_clk_count==(CLK_PER_BIT-1)/2) begin
                    r_data[r_bit_index]<=r_r;
                   	r_bit_index<=r_bit_index+1;
                    r_clk_count<=0;
                    if (r_bit_index==7) r_state<=s_stop;
                end else begin
                    r_clk_count<=r_clk_count+1;
                    r_state<=s_receive;
                end
            end
            s_stop: begin
            	if (r_clk_count==(CLK_PER_BIT-1)/2) begin
                    r_clk_count<=0;
                    if (r_r==1) begin
                        r_state<=s_idle;
                    end
                end else begin
                    r_clk_count<=r_clk_count+1;
                    r_state<=s_stop;
                end
            end
        endcase
	end
  assign o_data =r_data;
endmodule
