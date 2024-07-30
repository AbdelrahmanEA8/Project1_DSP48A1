module Multiplier(A,B,OUT);
parameter SIZE = 18;
input [SIZE-1:0] A,B;
output [2*SIZE-1:0] OUT;
assign OUT = A*B;
endmodule