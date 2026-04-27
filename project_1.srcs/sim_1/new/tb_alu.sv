`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2026 15:06:34
// Design Name: 
// Module Name: tb_alu
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
module tb_alu;
    logic [31:0] a, b, result;
    logic [3:0]  alu_ctrl;
    logic        zero;

    alu dut (.a(a), .b(b), .alu_ctrl(alu_ctrl), .result(result), .zero(zero));

    initial begin
        $dumpfile("alu.vcd"); $dumpvars(0, tb_alu);

        // test add: 5 + 3 = 8
        a = 32'd5; b = 32'd3; alu_ctrl = ALU_ADD; #10;
        assert(result == 32'd8) else $error("ADD failed");

        // test sub: 5 - 3 = 2
        a = 32'd5; b = 32'd3; alu_ctrl = ALU_SUB; #10;
        assert(result == 32'd2) else $error("SUB failed");

        // test and: 1 AND 0
        a = 32'd1; b = 32'd0; alu_ctrl = ALU_AND; #10;
        assert(result == 32'd0) else $error("AND failed");
        
        // test or: 1 OR 0
        a = 32'd1; b = 32'd0; alu_ctrl = ALU_OR; #10;
        assert(result == 32'd1) else $error("OR failed");
        
        // test xor: 1 XOR 1
        a = 32'd1; b = 32'd1; alu_ctrl = ALU_XOR; #10;
        assert(result == 32'd0) else $error("XOR failed");
        
        // test slt: -1 < 1 (signed)
        a = 32'hFFFFFFFF; b = 32'd1; alu_ctrl = ALU_SLT; #10;
        assert(result == 32'd1) else $error("SLT signed failed");

        // test zero flag
        a = 32'd7; b = 32'd7; alu_ctrl = ALU_SUB; #10;
        assert(zero == 1'b1) else $error("Zero flag failed");
        $finish;
    end
endmodule
