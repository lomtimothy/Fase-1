// UnidadDeControl
module UnidadDeControl (
    input  wire [5:0]  OpCode,
    output reg         RegDst,
	output reg         Branch,
    output reg         MemRead,
	output reg         MemToReg,
	output reg [2:0]   ALUOp,
    output reg         MemToWrite,
	output reg         ALUSrc,
	output reg         RegWrite
    
);
    always @(*) begin
        // Valores por defecto
        MemToReg  = 1'b0;
        MemToWrite  = 1'b0;
        ALUOp     = 3'b000;
        RegWrite  = 1'b0;
		RegDst = 1'b0;
		Branch = 1'b0;
		MemRead = 1'b0;
		ALUSrc = 1'b0;
		
        case (OpCode)
            6'b000000: begin // Instuccion R
                RegWrite = 1'b1;
                ALUOp    = 3'b010;
				RegDst = 1'b1;
				
            end
            default: begin
                // Aquí se pueden agregar otros opcodes
            end
        endcase
    end
endmodule
