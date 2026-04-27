import riscv_pkg::*;

module control (
    input  logic [6:0] opcode,
    output logic reg_we, // register write enable
    output logic mem_we, // memory write enable
    output logic mem_to_reg, //writeback mux
    output logic alu_src, // alu b-input mux
    output logic branch, // conditional branch
    output logic jump, // unconditional jump
    output logic [1:0] alu_op, // alu operation hint passed to alu control
    output logic [2:0] imm_sel // select immediate format
);

    always_comb begin
        // defaults everything off
        reg_we     = 0;
        mem_we     = 0;
        mem_to_reg = 0;
        alu_src    = 0;
        branch     = 0;
        jump       = 0;
        alu_op     = 2'b00;
        imm_sel    = IMM_I;

        case (opcode)
            OPCODE_RTYPE: begin //r-type, result comes from alu and is written back to rd
                reg_we  = 1;
                alu_op  = 2'b10;
            end

            OPCODE_ITYPE: begin
                reg_we  = 1;
                alu_src = 1; // second operand uses immediate instead of rs2
                alu_op  = 2'b10; // decode the operation
                imm_sel = IMM_I; // sign extend 12 bit immediate
            end

            OPCODE_LOAD: begin // add base register and I-immediate to form memory address
                reg_we     = 1;
                alu_src    = 1;     
                mem_to_reg = 1; // write memory data to register
                alu_op     = 2'b00; // always ADD for address
                imm_sel    = IMM_I;
            end

            OPCODE_STORE: begin // add base register and S-immediate to form memory address
                mem_we  = 1;
                alu_src = 1;        
                alu_op  = 2'b00; // always ADD for address
                imm_sel = IMM_S;
            end

            OPCODE_BRANCH: begin 
                branch  = 1; // signal to program counter logic to take branch if condition holds
                alu_op  = 2'b01; // subtract to compare rs1 and rs2
                imm_sel = IMM_B;
            end

            OPCODE_JAL: begin
                reg_we  = 1; // save return address (pc+4) in rd
                jump    = 1; //unconditional jump
                imm_sel = IMM_J;
            end

            OPCODE_JALR: begin
                reg_we  = 1;
                jump    = 1;
                alu_src = 1; //alu adds rs1 +i- immediate for target address
                imm_sel = IMM_I;
            end

            OPCODE_LUI: begin
                reg_we  = 1;
                alu_src = 1; // feed U-immediate into alu b input
                imm_sel = IMM_U;
            end

            OPCODE_AUIPC: begin
                reg_we  = 1;
                alu_src = 1; //feed U-immediate ito alu b input
                imm_sel = IMM_U;
            end
        endcase
    end

endmodule