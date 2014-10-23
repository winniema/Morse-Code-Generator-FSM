module morse (I[2:0], M[3:0], L[3:0]);
	input [2:0]I;
	output reg [3:0]M;
	output reg [3:0]L;
	
	always @ (*)
		case(I[2:0])			
			3'b000: M=4'b0100;  
			3'b001: M=4'b1000;
			3'b010: M=4'b1010;
			3'b011: M=4'b1000; 
			3'b100: M=4'b0000;
			3'b101: M=4'b0010;
			3'b110: M=4'b1100;
			3'b111: M=4'b0000;	
		endcase
	always @ (*)
		case(I[2:0])			
			3'b000: L=4'b1100;  
			3'b001: L=4'b1111;
			3'b010: L=4'b1111;
			3'b011: L=4'b1110; 
			3'b100: L=4'b1000;
			3'b101: L=4'b1111;
			3'b110: L=4'b1110;
			3'b111: L=4'b1111;	
		endcase
endmodule

module shifty (clock, moveit, D, Q, enable);
	input clock, moveit, enable;
	input [3:0]D;
	output reg [3:0]Q;
	
	always@(posedge clock)	
		begin
			if(enable)
				Q[3:0] <= D[3:0];
			else if (moveit == 1)
				begin	
				Q[3] <= Q[2];
				Q[2] <= Q[1];
				Q[1] <= Q[0];
				Q[0] <= 0;
				end
		end
endmodule
		
module part3(SW, KEY, LEDR, CLOCK_50);
	input [2:0]SW;
	input [1:0]KEY;
	input CLOCK_50;
	output [0:0]LEDR;
	
	wire [3:0]L;
	wire [3:0]M;
	wire [3:0]l;
	wire [3:0]m;
	
	reg [2:0]y;
	reg [2:0]Y;
	reg mooove = 0;
	reg z;
	
	parameter A = 3'b000;
	parameter B = 3'b001;
	parameter C = 3'b010;
	parameter D = 3'b011;
	parameter E = 3'b100;
	
	morse u1 (SW[2:0], M[3:0], L[3:0]);
	shifty u2 (CLOCK_50, mooove & z, L, l, (~KEY[1]&(y==A)));
	shifty u3 (CLOCK_50, mooove & z, M, m, (~KEY[1]&(y==A)));
	
	always @ (*)
	begin
	   mooove <= 0;
		case(y)
			A: begin
					if(l[3])
					begin
						if(m[3]) Y <= C;
						else Y <= B;	
					end
					else Y <= A;
				end
			B: begin Y <= A; mooove <= 1; end
			C: Y <= D;
			D: Y <= E;
			E: begin Y <= A; mooove <= 1; end
		endcase
	end

	always @ (posedge CLOCK_50) 
		begin
		   if(~KEY[0]) y <= A;
			else
			begin
				if (z == 1)
				begin
					y <= Y;
				end
			end
		end
		
	reg [1:0]i;
	always @ (posedge CLOCK_50) 
	begin
		z <= 0;
		if(~KEY[0]) i <= 0;
		else
		begin
			if (i == 2'b11)
			begin
				z <= 1;
				i <= 2'b11;
			end
			i <= i + 1;
		end
	end
	
	assign LEDR[0] = (y==B) | (y==C) | (y==D) | (y==E);
endmodule
