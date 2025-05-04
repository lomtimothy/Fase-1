module DPTR_tb;
// Señales del testbench
    reg         clk;
    wire [31:0] PCout;
    wire [31:0] Instr;

// Instanciación de la DUT
DPTR DUT (
	.clk(clk),
    .PCout(PCout),
    .Instr(Instr)
);

// Generación del reloj: periodo de 10 ns
initial begin
    clk = 0;
	forever #70 clk = ~clk;
end
	
initial begin
    #2100; 
    $finish;
end
endmodule
