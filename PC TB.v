`timescale 1ns / 1ps

module PC_tb;
    // Entradas
    reg [31:0] IN;
    reg CLK;

    // Salida
    wire [31:0] OUT;

    // Instanciar el Módulo Bajo Prueba (UUT)
    PC uut (
        .IN(IN),
        .CLK(CLK),
        .OUT(OUT)
    );

    // Generación del reloj: periodo de 10ns
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Estímulos
    initial begin
        // Inicializar entrada
        IN = 32'b00000000000000000000000000000000;

        // Esperar algunos ciclos de reloj
        #20;

        // Aplicar vectores de prueba
        IN = 32'b00000000000000000000000000000001; // 1
        #10; // esperar un flanco de reloj

        IN = 32'b00010010001101000101011001111000; // 0x12345678
        #10;

        IN = 32'b10101011110011011110111100000001; // 0xABCDEF01
        #10;

        IN = 32'b11111111111111111111111111111111; // 0xFFFFFFFF
        #10;

        IN = 32'b00000000000000000000000000000000; // 0x00000000
        #10;

        // Finalizar simulación
        #20;
        $finish;
    end

    // Monitoreo
    initial begin
        $display("Tiempo(ns)\tCLK\tIN\t			OUT");
        $monitor("%0d\t%b\t%b\t%b", $time, CLK, IN, OUT);
    end

endmodule

