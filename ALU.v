module ALU (
    input  wire [31:0] OP1,
    input  wire [31:0] OP2,
    input  wire [2:0]  ALUCtl,	// Lee del Alu control
    output reg  [31:0] Res,
    output wire        ZF
);
    always @(*) begin
        case (ALUCtl)
            3'b000: Res = OP1 & OP2;                  // AND
            3'b001: Res = OP1 | OP2;                  // OR
            3'b010: Res = OP1 + OP2;                  // ADD
            3'b110: Res = OP1 - OP2;                  // SUB
            3'b111: Res = (OP1 < OP2) ? 32'd1 : 32'd0;// SLT
			3'b011: Res = 32'd0;                      // NOP
            default: Res = 32'd0;
        endcase
    end
    assign ZF = (Res == 32'd0);
endmodule
