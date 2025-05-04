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
        // Mostrar encabezado en consola
        $display("Tiempo(ns)\tA\t\t\t\tRES");
        $monitor("%0d\t%b\t%b", $time, A, RES);

        // Inicializar
        A = 32'b00000000000000000000000000000000; // 0
        #10;

        A = 32'b00000000000000000000000000000001; // 1
        #10;

        A = 32'b00000000000000000000000000000100; // 4
        #10;

        A = 32'b11111111111111111111111111111100; // 0xFFFFFFFC
        #10;

        A = 32'b11111111111111111111111111111111; // 0xFFFFFFFF
        #10;

        // Finalizar simulación
        #20;
        $finish;
    end

endmodule
