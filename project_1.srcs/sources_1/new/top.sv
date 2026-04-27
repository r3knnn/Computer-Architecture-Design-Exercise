import riscv_pkg::*;

module top (
    input logic clk,
    input logic rst
);

    //program counter
    logic [31:0] pc, pc_next, pc_plus4, pc_branch, pc_jump;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) pc <= 32'd0;
        else     pc <= pc_next;
    end

    assign pc_plus4 = pc + 32'd4;

    // instruction memory
    logic [31:0] inst;
    instr_mem imem (.addr(pc), .inst(inst));

    // decoding instruction fields
    logic [6:0] opcode;
    logic [4:0] rs1, rs2, rd;
    logic [2:0] funct3;
    logic funct7_5;

    assign opcode = inst[6:0];
    assign rd = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];
    assign funct7_5 = inst[30];

    // control unit
    logic reg_we, mem_we, mem_to_reg, alu_src, branch, jump;
    logic [1:0] alu_op;
    logic [2:0] imm_sel;

    control ctrl (.opcode(opcode), .reg_we(reg_we), .mem_we(mem_we), .mem_to_reg(mem_to_reg), .alu_src(alu_src), .branch(branch), .jump(jump), .alu_op(alu_op), .imm_sel(imm_sel));

    // register file
    logic [31:0] rd1, rd2, wd;

    reg_file rf (.clk(clk), .we(reg_we), .rs1(rs1), .rs2(rs2), .rd(rd), .wd(wd), .rd1(rd1), .rd2(rd2));

    // immediate generator
    logic [31:0] imm;

    imm_gen ig (.inst(inst), .imm_sel(imm_sel), .imm(imm));

    // alu control
    logic [3:0] alu_ctrl;

    alu_control ac (.alu_op(alu_op), .funct3(funct3), .funct7_5(funct7_5), .alu_ctrl(alu_ctrl));

    // alu
    logic [31:0] alu_result;
    logic zero;

    logic [31:0] alu_b;
    assign alu_b = alu_src ? imm : rd2;   // mux either immediate or register

    alu alu_inst (.a(rd1), .b(alu_b), .alu_ctrl(alu_ctrl), .result(alu_result), .zero(zero));

    // data memory
    logic [31:0] mem_rdata;

    data_mem dmem ( .clk(clk), .we(mem_we), .funct3(funct3), .addr(alu_result), .wd(rd2), .rd(mem_rdata));

    // three way writeback mux
    always_comb begin
        if (jump)
            wd = pc_plus4;          // jal/jalr save return address
        else if (mem_to_reg)
            wd = mem_rdata;         // load instructions
        else
            wd = alu_result;        // alu instructions
    end

    // branch logic
    logic branch_taken;

    always_comb begin
        case (funct3)
            3'b000: branch_taken = branch & zero;           // beq
            3'b001: branch_taken = branch & ~zero;          // bne
            3'b100: branch_taken = branch & alu_result[31]; // blt signed
            3'b101: branch_taken = branch & ~alu_result[31];// bge signed
            3'b110: branch_taken = branch & (rd1 < rd2);    // bltu unsigned
            3'b111: branch_taken = branch & (rd1 >= rd2);   // bgeu unsigned
            default: branch_taken = 0;
        endcase
    end

    // pc next logic
    assign pc_branch = pc + imm;                  // branch target
    assign pc_jump = (opcode == OPCODE_JALR) ? (rd1 + imm) : (pc + imm);  // jump target

    always_comb begin
        if (jump)
            pc_next = pc_jump;
        else if (branch_taken)
            pc_next = pc_branch;
        else
            pc_next = pc_plus4;
    end

endmodule
