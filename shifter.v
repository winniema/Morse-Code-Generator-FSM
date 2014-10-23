module shifter (clock, D, Q, enable);
	input clock, enable;
	input [3:0]D;
	output reg [3:0]Q;
	
	always@(posedge clock)	
			if(enable)
				Q[3:0] <= D[3:0];
			else
		begin	
				Q[3] <= Q[2];
				Q[2] <= Q[1];
				Q[1] <= Q[0];
				Q[0] <= 0;
		end
endmodule
