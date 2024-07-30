module DFF_MUX(D,CLK,OUT,RST,EN);
parameter RSTTYPE="SYNC",
          SIZE = 18, 
          SEL = 0;

input CLK,RST,EN;
input [SIZE-1:0] D;
output [SIZE-1:0] OUT;
generate
    if(SEL)begin
        if(RSTTYPE=="SYNC")
            DFF #(SIZE) B0 (.D(D),.Q(OUT),.CLK(CLK),.EN(EN),.RST(RST));
        else if (RSTTYPE=="ASYNC")
            A_DFF #(SIZE) B0 (.D(D),.Q(OUT),.CLK(CLK),.EN(EN),.RST(RST));
    end
    else
         assign OUT=D;
endgenerate
endmodule