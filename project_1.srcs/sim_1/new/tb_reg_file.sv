`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2026 15:35:22
// Design Name: 
// Module Name: tb_reg_file
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


module tb_reg_file;
    logic clk, we;
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] wd, rd1, rd2;

    reg_file dut (.clk(clk), .we(we), .rs1(rs1), .rs2(rs2),
                  .rd(rd), .wd(wd), .rd1(rd1), .rd2(rd2));

    // generate clock
    always #5 clk = ~clk;

    initial begin
        clk = 0; we = 0;

        // write 42 to x1
        rd = 5'd1; wd = 32'd42; we = 1; @(posedge clk); #1;

        // write 100 to x2
        rd = 5'd2; wd = 32'd100; we = 1; @(posedge clk); #1;

        // read back x1 and x2
        we = 0; rs1 = 5'd1; rs2 = 5'd2; #10;
        assert(rd1 == 32'd42)  else $error("x1 read failed");
        assert(rd2 == 32'd100) else $error("x2 read failed");

        // test x0 is always 0
        rd = 5'd0; wd = 32'hFFFFFFFF; we = 1; @(posedge clk); #1;
        rs1 = 5'd0; #10;
        assert(rd1 == 32'd0) else $error("x0 not hardwired to 0");
        $finish;
    end
endmodule
