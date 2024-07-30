module A_DFF(D,Q,RST,CLK,EN);
parameter SIZE = 18;
input CLK,RST,EN;
input [SIZE-1:0] D;
output reg [SIZE-1:0] Q;
always @(posedge CLK or posedge RST) begin
    if (RST)
      Q<=1'b0;
    else
        if (EN)
          Q<=D;  
end
endmodule