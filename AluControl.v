// ALuControl
module ALuControl (
    input  wire [2:0] ALUOp,
    input  wire [5:0] funct,
    output reg  [2:0] ALUCtl
);
    always @(*) begin
        case (ALUOp)
            3'b010: begin // instrucciones R
                case (funct)
                    6'b100000: ALUCtl = 3'b010; // ADD
                    6'b100010: ALUCtl = 3'b110; // SUB
                    6'b100100: ALUCtl = 3'b000; // AND
                    6'b100101: ALUCtl = 3'b001; // OR
                    6'b101010: ALUCtl = 3'b111; // SLT
					6'b000000: ALUCtl = 3'b011; // NOP
                    default:   ALUCtl = 3'b011;
                endcase
            end
        endcase
    end
endmodule
