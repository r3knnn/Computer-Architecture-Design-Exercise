`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 13:39:50
// Design Name: 
// Module Name: tb_imm_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  
//////////////////////////////////////////////////////////////////////////////////
import riscv_pkg::*;

module tb_imm_gen;
    logic [31:0] inst, imm;
    logic [2:0]  imm_sel;

    imm_gen dut (.inst(inst), .imm_sel(imm_sel), .imm(imm));

    initial begin

        // Test I-Type Positive : ADDI x1, x0, 5  
        inst = 32'b000000000101_00000_000_00001_0010011;
        imm_sel = IMM_I; #10;
        assert(imm == 32'd5) else $error("I-type positive failed: %h", imm);

        // Test I Type Negative: ADDI x1, x0, -1 
        inst = 32'b111111111111_00000_000_00001_0010011;
        imm_sel = IMM_I; #10;
        assert(imm == 32'hFFFFFFFF) else $error("I-type negative failed: %h", imm);

        // Test S-Type: SW x3, 4(x0)
        // Immediate split across inst[31:25] and inst[11:7], combined = 000000000100 = 4
        inst = 32'b0000000_00011_00000_010_00100_0100011;
        imm_sel = IMM_S; #10;
        assert(imm == 32'd4) else $error("S-type positive failed: %h", imm);

        // Test S-Type: SW x3, -4(x0
        // imm[11:5] = inst[31:25] = 1111111 and imm[4:0]  = inst[11:7]  = 11100 combined = 111111111100 sign extended = 0xFFFFFFFC
        inst = 32'b1111111_00011_00000_010_11100_0100011;
        imm_sel = IMM_S; #10;
        assert(imm == 32'hFFFFFFFC) else $error("S-type negative failed: %h", imm);

        // Test B-Type (Positive): 
        // BEQ x0, x0, 8 imm = 000000001000 = 8
        // inst[31]=0, inst[7]=0, inst[30:25]=000000, inst[11:8]=0100
        inst = 32'b0_000000_00000_00000_000_0100_0_1100011;
        imm_sel = IMM_B; #10;
        assert(imm == 32'd8) else $error("B-type positive failed: %h", imm);

        // Test B Type (Negative): BEQ x0, x0, -8 → imm should be -8 (0xFFFFFFF8)
        inst = 32'b1_111111_00000_00000_000_1100_1_1100011;
        imm_sel = IMM_B; #10;
        assert(imm == 32'hFFFFFFF8) else $error("B-type negative failed: %h", imm);

        // Test U-Type: LUI x1, 1 → imm should be 0x00001000 
        // Immediate is inst[31:12] shifted to upper 20 bits and lower 12 bits are always zero
        inst = 32'b00000000000000000001_00001_0110111;
        imm_sel = IMM_U; #10;
        assert(imm == 32'h00001000) else $error("U-type small failed: %h", imm);

        // Test U-Type: LUI x1, 0xABCDE → imm should be 0xABCDE000
        inst = 32'b10101011110011011110_00001_0110111;
        imm_sel = IMM_U; #10;
        assert(imm == 32'hABCDE000) else $error("U-type large failed: %h", imm);

        // Test J-Type: JAL x0, 8 imm = 000000001000 = 8
        inst = 32'b0_0000000100_0_00000000_00000_1101111;
        imm_sel = IMM_J; #10;
        assert(imm == 32'd8) else $error("J-type positive failed: %h", imm);

        // Test J-Type: JAL x0, -8 → imm should be -8 (0xFFFFFFF8)
        inst = 32'b1_1111111100_1_11111111_00000_1101111;
        imm_sel = IMM_J; #10;
        assert(imm == 32'hFFFFFFF8) else $error("J-type negative failed: %h", imm);

        $finish;
    end
endmodule