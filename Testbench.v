`timescale 1ns/1ps

module DPTR_tb;
    // Señales de testbench
    reg         clk;
    wire        ZF;
    wire [31:0] PCout;
    wire [31:0] Instr;

    // Instanciación de la DUT
    DPTR DUT (
        .clk(clk),
        .ZF(ZF),
        .PCout(PCout),
        .Instr(Instr)
    );

    // Reloj: 10 ns de periodo
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Volcado de ondas (ModelSim/GTKWave)
    initial begin
        $dumpfile("DPTR_tb.vcd");
        $dumpvars(0, DPTR_tb);
    end

    // Termina a los 200 ns
    initial begin
        #200;
        $finish;
    end
endmodule


