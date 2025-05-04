module DPTR (
    input  wire        clk,
    output wire        ZF,
	output wire [31:0] PCout,  
    output wire [31:0] Instr    
);
    // Buses internos
    wire [31:0] PCin, PCnext;
    wire [5:0]  OpCode = Instr[31:26];
    wire [4:0]  rs     = Instr[25:21];
    wire [4:0]  rt     = Instr[20:16];
    wire [4:0]  rd     = Instr[15:11];
    wire [5:0]  funct  = Instr[5:0];

    // Señales de control
    wire MemToReg, MemToWrite, RegWrite, RegDst, MemRead, ALUSrc, Branch;
    wire [2:0]  ALUOp;

    // Más buses internos
    wire [31:0] C1, C2, C3, C5, WriteData, OP2;
    wire [2:0]  C4;
    wire [4:0]  WriteReg;

    // Program Counter
    PC pc_inst (
        .IN(PCin),
        .CLK(clk),
        .OUT(PCout)
    );

    // Suma 4 al PC
    ADD4 add_inst (
        .A(PCout),
        .RES(PCnext)
    );

    // Memoria de instrucciones
    MEMI memi_inst (
        .DR(PCout),
        .INS(Instr)
    );

    UnidadDeControl UC(
        .OpCode(OpCode),
        .MemToReg(MemToReg),
        .MemToWrite(MemToWrite),
        .ALUOp(ALUOp),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
		.Branch(Branch)
    );

    BancoReg BR(
        .clk(clk),
        .RegEn(RegWrite),
        .ReadReg1(rs),
        .ReadReg2(rt),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(C1),
        .ReadData2(C2)
    );

    ALuControl AC(
        .ALUOp(ALUOp),
        .funct(funct),
        .ALUCtl(C4)
    );

    ALU alu(
        .OP1(C1),
        .OP2(OP2),
        .ALUCtl(C4),
        .Res(C3),
        .ZF(ZF)
    );

    MemDatos MD(
        .clk(clk),
        .MemToWrite(MemToWrite),
        .Address(C3),
        .WriteData(C2),
        .ReadData(C5)
    );

    Mux2to1Param #(.WIDTH(5)) MUXWR (
    .entrada0(rt),
    .entrada1(rd),
    .sel(RegDst),
    .salida(WriteReg)
);
	
    Mux2to1Param #(.WIDTH(32)) MUXAL (
        .entrada0(C2),
        .entrada1(32'b0),    
        .sel(ALUSrc),
        .salida(OP2)
);
    Mux2to1Param #(.WIDTH(32)) MUXWD (
    .entrada0(C3),
    .entrada1(C5),
    .sel(MemToReg),
    .salida(WriteData)
);

    Mux2to1Param #(.WIDTH(32)) MUXPC (
    .entrada0(PCnext),
    .entrada1(32'b0),
    .sel(Branch),
    .salida(PCin)
);

endmodule

