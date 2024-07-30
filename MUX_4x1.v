module MUX_4x1(A,B,C,D,sel,out);
parameter SIZE = 48;
input [SIZE-1:0] A,B,D;
input [SIZE-1:0] C;
output reg [SIZE-1: 0] out;
input [1:0] sel;

always @(*) begin
    case (sel)
      0  : out = A;
      1  : out = B;
      2  : out = C;
      3  : out = D;
    endcase
end
endmodule