module data_mem (
    input  logic clk,
    input  logic we,
    input  logic [2:0]  funct3,
    input  logic [31:0] addr,
    input  logic [31:0] wd,
    output logic [31:0] rd
);
    logic [31:0] mem [0:255];

    // read logic
    logic [31:0] word;
    logic [1:0]  byte_off;

    assign word     = mem[addr[9:2]];
    assign byte_off = addr[1:0];

    always_comb begin
        case (funct3)
            3'b000: begin  // lb (signed byte)
                case (byte_off)
                    2'b00: rd = {{24{word[7]}},  word[7:0]};
                    2'b01: rd = {{24{word[15]}}, word[15:8]};
                    2'b10: rd = {{24{word[23]}}, word[23:16]};
                    2'b11: rd = {{24{word[31]}}, word[31:24]};
                endcase
            end
            3'b001: begin  // lh (signed halfword)
                case (byte_off[1])
                    1'b0: rd = {{16{word[15]}}, word[15:0]};
                    1'b1: rd = {{16{word[31]}}, word[31:16]};
                endcase
            end
            3'b010: rd = word;  // lw (full word)
            3'b100: begin  // lbu (unsigned byte)
                case (byte_off)
                    2'b00: rd = {24'd0, word[7:0]};
                    2'b01: rd = {24'd0, word[15:8]};
                    2'b10: rd = {24'd0, word[23:16]};
                    2'b11: rd = {24'd0, word[31:24]};
                endcase
            end
            3'b101: begin  // lhu (unsigned halfword)
                case (byte_off[1])
                    1'b0: rd = {16'd0, word[15:0]};
                    1'b1: rd = {16'd0, word[31:16]};
                endcase
            end
            default: rd = word;
        endcase
    end

    // write logic
    always_ff @(posedge clk) begin
        if (we) begin
            case (funct3)
                3'b000: begin  // sb (store byte)
                    case (byte_off)
                        2'b00: mem[addr[9:2]][7:0]   <= wd[7:0];
                        2'b01: mem[addr[9:2]][15:8]  <= wd[7:0];
                        2'b10: mem[addr[9:2]][23:16] <= wd[7:0];
                        2'b11: mem[addr[9:2]][31:24] <= wd[7:0];
                    endcase
                end
                3'b001: begin  // sh (store halfword)
                    case (byte_off[1])
                        1'b0: mem[addr[9:2]][15:0]  <= wd[15:0];
                        1'b1: mem[addr[9:2]][31:16] <= wd[15:0];
                    endcase
                end
                3'b010: mem[addr[9:2]] <= wd;  // sw (full word)
            endcase
        end
    end

endmodule