`timescale 1ns / 1ps

module UnidadDeControl_tb;
    // Señales
    reg [5:0] OpCode;

    wire RegDst;
    wire Branch;
    wire MemRead;
    wire MemToReg;
    wire [2:0] ALUOp;
    wire MemToWrite;
    wire ALUSrc;
    wire RegWrite;

    // Instanciar módulo bajo prueba
    UnidadDeControl uut (
        .OpCode(OpCode),
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .MemToWrite(MemToWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    // Generar VCD para GTKWave (opcional)
    initial begin
        $dumpfile("UnidadDeControl.vcd");
        $dumpvars(0, UnidadDeControl_tb);
    end

    // Estímulos
    initial begin
 
        // Prueba para instrucción tipo R (OpCode = 000000)
        OpCode = 6'b000000;
        #10;

        // Prueba para opcode no definido (por defecto)
        OpCode = 6'b100011; // LW, por defecto outputs en cero
        #10;

        OpCode = 6'b101011; // SW, por defecto
        #10;

        OpCode = 6'b000100; // BEQ, por defecto Branch=0
        #10;

        // Finalizar simulación
        #10;
        $finish;
    end

endmodule

