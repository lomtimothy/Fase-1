`timescale 1ns / 1ps
module ALUControl_tb;
    // Señales de entrada
    reg [2:0] ALUOp;
    reg [5:0] funct;
    // Señal de salida
    wire [2:0] ALUCtl;
    // Instanciar el módulo bajo prueba
    ALuControl uut (
        .ALUOp(ALUOp),
        .funct(funct),
        .ALUCtl(ALUCtl)
    );

    // Estímulos
    initial begin
        // Prueba: instrucciones R (ALUOp = 010)
        ALUOp = 3'b010;

        // ADD
        funct = 6'b100000; #10;
        
        // SUB
        funct = 6'b100010; #10;

        // AND
        funct = 6'b100100; #10;

        // OR
        funct = 6'b100101; #10;

        // SLT
        funct = 6'b101010; #10;

        // NOP
        funct = 6'b000000; #10;

        // Función no definida (default)
        funct = 6'b111111; #10;

        // Prueba ALUOp diferente (sin definición explícita)
        ALUOp = 3'b000;
        funct  = 6'b100000; #10;

        // Finalizar simulación
        #10;
        $finish;
    end
endmodule

