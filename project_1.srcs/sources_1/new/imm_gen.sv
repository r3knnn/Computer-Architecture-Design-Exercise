import riscv_pkg::*;
module imm_gen (
    input  logic [31:0] inst,
    input  logic [2:0]  imm_sel,    // selects which immediate type
    output logic [31:0] imm
);

    // imm_sel encoding
    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001; 
    localparam IMM_B = 3'b010;
    localparam IMM_U = 3'b011;
    localparam IMM_J = 3'b100;

    always_comb begin //sign extension to 32 bits
        case (imm_sel)
            IMM_I: imm = {{20{inst[31]}}, inst[31:20]}; 

            IMM_S: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            IMM_B: imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};

            IMM_U: imm = {inst[31:12], 12'b0};

            IMM_J: imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};

            default: imm = 32'd0;
        endcase
    end

endmodule