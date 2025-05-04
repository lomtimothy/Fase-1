`timescale 1ns / 1ps

module BancoReg_tb;
    // Señales de reloj y habilitación
    reg clk;
    reg RegEn;

    // Índices de registros de lectura y escritura
    reg [4:0] ReadReg1;
    reg [4:0] ReadReg2;
    reg [4:0] WriteReg;

    // Datos de escritura
    reg [31:0] WriteData;

    // Datos de lectura
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Instanciar el módulo bajo prueba
    BancoReg uut (
        .clk(clk),
        .RegEn(RegEn),
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Generación de reloj: periodo de 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Generar archivo VCD para GTKWave (opcional)
    initial begin
        $dumpfile("BancoReg.vcd");
        $dumpvars(0, BancoReg_tb);
    end

    // Estímulos
    initial begin
        // Inicialización
        RegEn = 0;
        ReadReg1 = 5'b00000;
        ReadReg2 = 5'b00001;
        WriteReg = 5'b00010;
        WriteData = 32'hDEADBEEF;

        // Esperar carga inicial desde archivo Bdatos
        #5;

        // Lectura inicial de registros 0 y 1
        $display("Tiempo(ns)\tReadReg1\tReadData1\tReadReg2\tReadData2");
        $monitor("%0d\t%b\t%h\t%b\t%h", $time, ReadReg1, ReadData1, ReadReg2, ReadData2);

        #10;  // Espera un ciclo de reloj combinacional

        // Habilitar escritura: escribir en reg 2
        RegEn = 1;
        WriteReg = 5'b00010;     // reg 2
        WriteData = 32'hDEADBEEF;
        #10; // Un ciclo de reloj

        // Deshabilitar escritura y leer de reg 2 y reg 3
        RegEn = 0;
        ReadReg1 = 5'b00010;     // reg 2
        ReadReg2 = 5'b00011;     // reg 3
        #10;

        // Escribir otro valor en reg 3
        RegEn = 1;
        WriteReg = 5'b00011;
        WriteData = 32'hCAFEBABE;
        #10;

        // Leer de nuevo reg 2 y reg 3
        RegEn = 0;
        ReadReg1 = 5'b00010;
        ReadReg2 = 5'b00011;
        #10;

        // Finalizar simulación
        #10;
        $finish;
    end

endmodule

