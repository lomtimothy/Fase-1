module BancoReg (
    input  wire        clk,
    input  wire        RegEn,
    input  wire [4:0]  ReadReg1,
    input  wire [4:0]  ReadReg2,
    input  wire [4:0]  WriteReg,
    input  wire [31:0] WriteData,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);
    reg [31:0]mem[0:31];
    
	initial begin
	    $readmemb("Bdatos", mem); 
    end
	
    // Escritura sincrona
    always @(posedge clk) begin
        if (RegEn)
            mem[WriteReg] <= WriteData;
    end
    // Lectura combinacional

    always @(*) begin
        ReadData1 = mem[ReadReg1];
        ReadData2 = mem[ReadReg2];
    end
endmodule

