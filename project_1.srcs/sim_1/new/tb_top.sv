`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2026 08:10:42
// Design Name: 
// Module Name: tb_top
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


module tb_top;
    logic clk, rst;

    top dut (.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; #10;
        rst = 0;
        #200;   // run for enough cycles
        $finish;
    end
endmodule
