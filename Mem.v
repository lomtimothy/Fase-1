module MemDatos (
    input  wire        clk,
	input  wire        MemToWrite,
    input  wire [31:0] Address,
    input  wire [31:0] WriteData,
    output reg [31:0] ReadData
);
    reg [31:0] mem [0:127];
	//Leemos el archivo
            initial
            begin 
	        $readmemb("Mdatos", mem); 
end
	
    // Lectura combinacional
	always @(*) begin
    ReadData = mem[Address];
	end
    // Escritura síncrona
  always @(posedge clk) begin
    if (MemToWrite)
      mem[Address] <= WriteData;
  end
endmodule
