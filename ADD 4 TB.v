`timescale 1ns / 1ps

module ADD4_tb;
    // Entradas
    reg [31:0] A;

    // Salidas
    wire [31:0] RES;

    // Instanciar el módulo bajo prueba (UUT)
    ADD4 uut (
        .A(A),
        .RES(RES)
    );

    // Estímulos
    initial begin      

        // Inicializar
        A = 32'b00000000000000000000000000000000; 
        #10;

        A = 32'b00000000000000000000000000000001; 
        #10;

        A = 32'b00000000000000000000000000000100; 
        #10;

        A = 32'b11111111111111111111111111111100; 
        #10;

        A = 32'b11111111111111111111111111111111; 
        #10;

        // Finalizar simulación
        #20;
        $finish;
    end

endmodule
