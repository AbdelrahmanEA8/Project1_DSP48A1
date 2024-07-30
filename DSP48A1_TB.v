module DSP48A1_TB();
parameter A0REG=1'b0, A1REG=1'b1, B0REG=1'b0, B1REG=1'b1,
          CREG=1'b0, DREG=1'b0, MREG=1'b0, PREG=1'b0,
          CARRYINREG=1'b0, CARRYOUTREG=1'b0, OPMODEREG = 1'b0,
          CARRYINSEL="OPMODE5",B_INPUT="DIRECT",RSTTYPE="SYNC";

reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg [7:0] OPMODE;
reg CLK,CARRYIN,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,
      RSTP,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;

reg [47:0] p_expected;

wire [47:0] P,PCOUT;
wire [17:0] BCOUT;
wire [35:0] M;
wire CARRYOUT,CARRYOUTF;


// Instantiate the DSP48A1 module
DSP48A1 DUV (
    .A(A), .B(B), .D(D), .BCIN(BCIN), .C(C), .PCIN(PCIN), .OPMODE(OPMODE), .CLK(CLK), .CARRYIN(CARRYIN),
    .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE),
    .RSTP(RSTP), .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE),
    .CEP(CEP), .P(P), .PCOUT(PCOUT), .BCOUT(BCOUT), .M(M), .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF)
);

initial begin
    CLK = 0;
    forever begin
        #1; CLK = ~CLK;
    end
end

initial begin
    RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1; RSTD = 1; RSTM = 1; 
    RSTOPMODE = 1; RSTP = 1;
    CEA = 0; CEB = 0; CEC = 0; CECARRYIN = 0; CED = 0; CEM = 0; CEOPMODE = 0; CEP = 0;
    CARRYIN = 0;
    A = 0; B = 0; D = 0; BCIN = 0; C = 0; PCIN = 0; OPMODE = 0; p_expected=0;
    repeat(2) begin
        @(negedge CLK);
    end
    RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0; RSTD = 0; RSTM = 0; 
    RSTOPMODE = 0; RSTP = 0;
    CEA = 1; CEB = 1; CEC = 1; CECARRYIN = 1; CED = 1; CEM = 1; CEOPMODE = 1; CEP = 1;
    // 16-Test Cases
    //Case 1
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b0000; 
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=0;

    //Case 2
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b0100;

    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=PCIN;

    //Case 3
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b1000;

    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=P;

    //Case 4
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b1100;

    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=C;

    //Case 5
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b0001;

    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=((D+B)*A);

    //Case 6
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b0101;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=((D+B)*A)+PCIN;

    //Case 7
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b1001;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=((D+B)*A)+P;

    //Case 8
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b1101;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=((D+B)*A)+C;

    //Case 9
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b0; OPMODE[3:0]=4'b0011;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected={D[11:0],A,BCOUT};

    //Case 10
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b0; OPMODE[3:0]=4'b0111;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected={D[11:0],A,BCOUT}+PCIN;

    //Case 11
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b0; OPMODE[3:0]=4'b1011;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected={D[11:0],A,BCOUT}+P;

    //Case 12
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b0; OPMODE[3:0]=4'b1111;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected={D[11:0],A,BCOUT}+C;

    //Case 13
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b0010;

    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=P;

    //Case 14
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b0110;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=P+PCIN;

    //Case 15
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b1010;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=P+P;

    //Case 16
    @(negedge CLK);
    A =$urandom_range(0,131071); B = $urandom_range(0,131071); D = $urandom_range(0,131071);
    BCIN = $urandom_range(0,131071); C = $urandom_range(0,131071); PCIN = $urandom_range(0,131071);
    OPMODE[7]=1'b0; OPMODE[6]=1'b0; OPMODE[5]=$random; OPMODE[4]=1'b1; OPMODE[3:0]=4'b1110;
    repeat(3) begin
        @(negedge CLK);
    end
        p_expected=P+C;
    @(negedge CLK);
    $stop;
end
endmodule