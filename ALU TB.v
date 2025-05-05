`timescale 1ns / 1ps

module ALU_tb;
    // Entradas al ALU
    reg [31:0] OP1;
    reg [31:0] OP2;
    reg [2:0]  ALUCtl;

    // Salidas del ALU
    wire [31:0] Res;
    wire        ZF;

    // Instanciar el módulo bajo prueba
    ALU uut (
        .OP1(OP1),
        .OP2(OP2),
        .ALUCtl(ALUCtl),
        .Res(Res),
        .ZF(ZF)
    );

    // Estímulos
    initial begin
       

        // Caso AND
        ALUCtl = 3'b000;
        OP1   = 32'b11110000111100001111000011110000; 
        OP2   = 32'b00001111000011110000111100001111; 
        #10;

        // Caso OR
        ALUCtl = 3'b001;
        OP1   = 32'b11110000111100001111000011110000;
        OP2   = 32'b00001111000011110000111100001111;
        #10;

        // Caso ADD
        ALUCtl = 3'b010;
        OP1   = 32'b00000000000000000000000000001010; 
        OP2   = 32'b00000000000000000000000000001111; 
        #10;

        // Caso SUB no cero
        ALUCtl = 3'b110;
        OP1   = 32'b00000000000000000000000000010100;
        OP2   = 32'b00000000000000000000000000000101; 
        #10;

        // Caso SUB a cero (ZF=1)
        ALUCtl = 3'b110;
        OP1   = 32'b00000000000000000000000000000111; 
        OP2   = 32'b00000000000000000000000000000111; 
        #10;

        // Caso SLT verdadero
        ALUCtl = 3'b111;
        OP1   = 32'b00000000000000000000000000000011; 
        OP2   = 32'b00000000000000000000000000001000; 
        #10;

        // Caso SLT falso
        ALUCtl = 3'b111;
        OP1   = 32'b00000000000000000000000000001001; 
        OP2   = 32'b00000000000000000000000000000010; 
        #10;

        // Caso NOP
        ALUCtl = 3'b011;
        OP1   = 32'b00000000000000000000000001111011; 
        OP2   = 32'b00000000000000000000000111001000; 
        #10;

        // Caso default (invalido)
        ALUCtl = 3'b100;
        OP1   = 32'b00000000000000000000000000000001; 
        OP2   = 32'b00000000000000000000000000000001; 
        #10;

        // Finalizar simulación
        #10;
        $finish;
    end

endmodule

