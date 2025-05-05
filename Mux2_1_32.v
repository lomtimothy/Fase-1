module Mux2to1Param #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] entrada0,
    input  wire [WIDTH-1:0] entrada1,
    input  wire             sel,
    output reg  [WIDTH-1:0] salida
);
    always @(*) begin
        salida = sel ? entrada1 : entrada0;
    end
endmodule
