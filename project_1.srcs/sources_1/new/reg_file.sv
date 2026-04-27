module reg_file (
    input  logic clk,
    input  logic we, // write enable from control unit
    input  logic [4:0]  rs1, // source register 1 address
    input  logic [4:0]  rs2, // source register 2 address
    input  logic [4:0]  rd, // destination register address
    input  logic [31:0] wd, // write data
    output logic [31:0] rd1, // read data 1
    output logic [31:0] rd2 // read data 2
);

    logic [31:0] regs [31:0];   // 32 registers each 32 bits

    // asynchronus read
    assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    // synchronous write on positive slock edge
    always_ff @(posedge clk) begin
        if (we && rd != 5'd0)    // not allowing to write to x0
            regs[rd] <= wd;
    end

endmodule