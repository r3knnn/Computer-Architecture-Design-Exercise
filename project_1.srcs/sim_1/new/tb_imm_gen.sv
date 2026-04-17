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
        // test I-type: ADDI x1, x0, 5
        inst = 32'b000000000101_00000_000_00001_0010011;
        imm_sel = IMM_I; #10;
        assert(imm == 32'd5) else $error("I-type failed: %h", imm);

        // test I-type negative: ADDI x1, x0, -1
        inst = 32'b111111111111_00000_000_00001_0010011;
        imm_sel = IMM_I; #10;
        assert(imm == 32'hFFFFFFFF) else $error("I-type negative failed: %h", imm);

        // test U-type: LUI x1, 1
        // imm = 0x00001000
        inst = 32'b00000000000000000001_00001_0110111;
        imm_sel = IMM_U; #10;
        assert(imm == 32'h00001000) else $error("U-type failed: %h", imm);

        $display("All imm_gen tests passed!");
        $finish;
    end
endmodule
