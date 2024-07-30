module DSP48A1 (
    input [17:0] A, B, D, BCIN,
    input [47:0] C, PCIN,
    input [7:0] OPMODE,
    input CLK, CARRYIN, RSTA, RSTB, RSTC, RSTD, RSTM, RSTP, 
          RSTCARRYIN, RSTOPMODE, CEA, CEB, CEC, CED, CEP, CEM, 
          CECARRYIN, CEOPMODE,
    output [47:0] P, PCOUT,
    output [17:0] BCOUT,
    output [35:0] M,
    output CARRYOUT, CARRYOUTF
);

parameter A0REG=1'b0, A1REG=1'b1, B0REG=1'b0, B1REG=1'b1,
          CREG=1'b1, DREG=1'b1, MREG=1'b1, PREG=1'b1,
          CARRYINREG=1'b1, CARRYOUTREG=1'b1, OPMODEREG = 1'b1,
          CARRYINSEL="OPMODE5", B_INPUT="DIRECT", RSTTYPE="SYNC";

wire D_SEL, B0_SEL, A0_SEL, C_SEL, B1_SEL, opmode5_out, CIN;
wire [17:0] D_OUT, B0_OUT, A0_OUT, Add_sub_OUT, B1_IN, A1_OUT;
wire [35:0] Multiplier_OUT;
wire [47:0] X_OUT, Z_OUT, P_IN,D_MUX_X,B_MUX_X,C_OUT;
wire [7:0] OPMODE_OUT;

DFF_MUX #(.SEL(DREG), .RSTTYPE(RSTTYPE)) M1 (.D(D), .CLK(CLK), .OUT(D_OUT), .RST(RSTD), .EN(CED));
DFF_MUX #(.SEL(A0REG), .RSTTYPE(RSTTYPE)) M2 (.D(A), .CLK(CLK), .OUT(A0_OUT), .RST(RSTA), .EN(CEA));
DFF_MUX #(.SEL(CREG), .SIZE(48), .RSTTYPE(RSTTYPE)) M3 (.D(C), .CLK(CLK), .OUT(C_OUT), .RST(RSTC), .EN(CEC));

DFF_MUX #(.SEL(B1REG), .RSTTYPE(RSTTYPE)) M5 (.D(B1_IN), .CLK(CLK), .OUT(BCOUT), .RST(RSTB), .EN(CEB));
DFF_MUX #(.SEL(A1REG), .RSTTYPE(RSTTYPE)) M6 (.D(A0_OUT), .CLK(CLK), .OUT(A1_OUT), .RST(RSTA), .EN(CEA));

Multiplier M7 (.A(A1_OUT), .B(BCOUT), .OUT(Multiplier_OUT));
DFF_MUX #(.SEL(MREG), .SIZE(36), .RSTTYPE(RSTTYPE)) M8 (.D(Multiplier_OUT), .CLK(CLK), .OUT(M), .RST(RSTM), .EN(CEM));

DFF_MUX #(.SEL(CARRYINREG), .SIZE(1), .RSTTYPE(RSTTYPE)) M9 (.D(opmode5_out), .CLK(CLK), .OUT(CIN), .RST(RSTCARRYIN), .EN(CECARRYIN));

assign D_MUX_X = {D_OUT[11:0], A1_OUT, BCOUT};
assign B_MUX_X = {12'b0, M};

MUX_4x1 M10 (.A(48'b0), .B(B_MUX_X), .C(P), .D(D_MUX_X), .sel(OPMODE_OUT[1:0]), .out(X_OUT));
MUX_4x1 M11 (.A(48'b0), .B(PCIN), .C(P), .D(C_OUT), .sel(OPMODE_OUT[3:2]), .out(Z_OUT));

DFF_MUX #(.SEL(CARRYOUTREG), .SIZE(1), .RSTTYPE(RSTTYPE)) M12 (.D(CIN), .CLK(CLK), .OUT(CARRYOUT), .RST(RSTCARRYIN), .EN(CECARRYIN));
DFF_MUX #(.SEL(PREG), .SIZE(48), .RSTTYPE(RSTTYPE)) M13 (.D(P_IN), .CLK(CLK), .OUT(P), .RST(RSTP), .EN(CEP));
DFF_MUX #(.SEL(OPMODEREG), .SIZE(8), .RSTTYPE(RSTTYPE)) M14 (.D(OPMODE), .CLK(CLK), .OUT(OPMODE_OUT), .RST(RSTOPMODE), .EN(CEOPMODE));

generate
    if (B_INPUT == "DIRECT")
        DFF_MUX #(.SEL(0)) B0 (.D(B), .CLK(CLK), .OUT(B0_OUT), .RST(RSTB), .EN(CEB));
    else
        DFF_MUX #(.RSTTYPE(B0REG), .SEL(1)) B0 (.D(BCIN), .CLK(CLK), .OUT(B0_OUT), .RST(RSTB), .EN(CEB));
endgenerate

assign Add_sub_OUT = (!OPMODE_OUT[6]) ? (B0_OUT + D_OUT) : (D_OUT - B0_OUT);
assign P_IN = (!OPMODE_OUT[7]) ? (X_OUT + Z_OUT ) : Z_OUT - X_OUT;
assign B1_IN = (!OPMODE[4]) ? B0_OUT : Add_sub_OUT;
assign opmode5_out = (CARRYINSEL == "OPMODE5") ? OPMODE[5] : CARRYIN;
assign CARRYOUTF = CARRYOUT;
assign PCOUT = P;

endmodule