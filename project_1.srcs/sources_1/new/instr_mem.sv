module instr_mem (
    input  logic [31:0] addr, //byte address from the program counter
    output logic [31:0] inst //32 bit instruction word at the given address
);
    logic [31:0] mem [0:255]; //declaring a 256-entry array for 32 bit words

    initial begin
        $readmemh("program.hex", mem); // loading instruction memory from hex file
    end

    assign inst = mem[addr[9:2]];
endmodule