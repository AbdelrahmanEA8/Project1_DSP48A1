module Add_sub(A,B,OUT,OPMODE);
parameter SIZE = 18;
input [SIZE-1:0] A,B;
input OPMODE;
output [SIZE-1:0] OUT;
assign OUT = (OPMODE) ? (B-A):(A+B);
endmodule