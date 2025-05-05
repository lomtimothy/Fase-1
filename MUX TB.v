`timescale 1ns / 1ps
module Mux2to1Param_tb;
    // Parámetro de ancho (utilizando valor por defecto 32)
    localparam WIDTH = 32;
    // Entradas
    reg [WIDTH-1:0] entrada0;
    reg [WIDTH-1:0] entrada1;
    reg sel;
    // Salida
    wire [WIDTH-1:0] salida;
    // Instanciar el MUX parametrizable
    Mux2to1Param #(.WIDTH(WIDTH)) uut (
        .entrada0(entrada0),
        .entrada1(entrada1),
        .sel(sel),
        .salida(salida)
    );
    // Estímulos
    initial begin       
        // Patrón de prueba inicial
        entrada0 = 32'b10101010101010101010101010101010; 
        entrada1 = 32'b01010101010101010101010101010101; 
        sel      = 1'b0;
        #10; // Con sel=0, salida debe ser entrada0

        sel      = 1'b1;
        #10; // Con sel=1, salida debe ser entrada1

        // Cambiar valores y repetir
        entrada0 = 32'b11110000111100001111000011110000; 
        entrada1 = 32'b00001111000011110000111100001111; 
        sel      = 1'b0;
        #10;

        sel      = 1'b1;
        #10;

        // Probar con ambos entran iguales
        entrada0 = 32'b11111111111111111111111111111111; 
        entrada1 = 32'b11111111111111111111111111111111;
        sel      = 1'b0;
        #10;

        sel      = 1'b1;
        #10;

        // Finalizar simulación
        #10;
        $finish;
    end

endmodule

