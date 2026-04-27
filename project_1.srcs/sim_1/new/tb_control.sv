`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2026 08:01:31
// Design Name: 
// Module Name: tb_control
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

module tb_control;
    logic [6:0] opcode;
    logic       reg_we, mem_we, mem_to_reg, alu_src, branch, jump;
    logic [1:0] alu_op;
    logic [2:0] imm_sel;

    control dut (.*);   // .* auto-connects matching port names

    initial begin
        // R-type
        opcode = OPCODE_RTYPE; #10;
        assert(reg_we == 1 && alu_src == 0 && alu_op == 2'b10)
            else $error("R-type control failed");
            
        // I-type
        opcode = OPCODE_ITYPE; #10;
        assert(reg_we == 1 && alu_src == 1 && alu_op == 2'b10 && imm_sel == IMM_I)
            else $error("I-type control failed");
 
        // JAL
        opcode = OPCODE_JAL; #10;
        assert(reg_we == 1 && jump == 1 && imm_sel == IMM_J)
            else $error("jal control failed");
 
        // JALR
        opcode = OPCODE_JALR; #10;
        assert(reg_we == 1 && jump == 1 && alu_src == 1 && imm_sel == IMM_I)
            else $error("jalr control failed");
 
        // LUI
        opcode = OPCODE_LUI; #10;
        assert(reg_we == 1 && alu_src == 1 && imm_sel == IMM_U)
            else $error("lui control failed");
 
        // AUIPC
        opcode = OPCODE_AUIPC; #10;
        assert(reg_we == 1 && alu_src == 1 && imm_sel == IMM_U)
            else $error("auipc control failed");

        // Load
        opcode = OPCODE_LOAD; #10;
        assert(reg_we == 1 && mem_to_reg == 1 && alu_src == 1)
            else $error("load control failed");

        // Store
        opcode = OPCODE_STORE; #10;
        assert(mem_we == 1 && alu_src == 1)
            else $error("store control failed");

        // Branch
        opcode = OPCODE_BRANCH; #10;
        assert(branch == 1 && reg_we == 0)
            else $error("branch control failed");

        $finish;
    end
endmodule
