module decode_seq(clk, icode, rA, rB, valA, valB, reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14);

input clk;
input [3:0] icode;
input [3:0] rA;
input [3:0] rB;
// input [959:0] reg_file;

output reg [63:0] valA;
output reg [63:0] valB;

input [63:0] reg_file0;
input [63:0] reg_file1;
input [63:0] reg_file2;
input [63:0] reg_file3;
input [63:0] reg_file4;
input [63:0] reg_file5;
input [63:0] reg_file6;
input [63:0] reg_file7;
input [63:0] reg_file8;
input [63:0] reg_file9;
input [63:0] reg_file10;
input [63:0] reg_file11;
input [63:0] reg_file12;
input [63:0] reg_file13;
input [63:0] reg_file14;

reg [63:0] reg_memory [0:14];

always @ (*)  
    begin
        reg_memory[0] = reg_file0;
        reg_memory[1] = reg_file1;
        reg_memory[2] = reg_file2;
        reg_memory[3] = reg_file3;
        reg_memory[4] = reg_file4;
        reg_memory[5] = reg_file5;
        reg_memory[6] = reg_file6;
        reg_memory[7] = reg_file7;
        reg_memory[8] = reg_file8;
        reg_memory[9] = reg_file9;
        reg_memory[10] = reg_file10;
        reg_memory[11] = reg_file11;
        reg_memory[12] = reg_file12;
        reg_memory[13] = reg_file13;
        reg_memory[14] = reg_file14;

        case(icode)
        // halt (not sure to include or not)
        4'b0000: begin end

        // nop
        4'b0001: begin end

        // cmovxx rA, rB
        4'b0010: 
        begin 
            valA = reg_memory[rA];
        end

        // irmovq V, rB
        4'b0011: begin end

        // rmmovq rA, D(rB)
        4'b0100: 
        begin 
            valA = reg_memory[rA];
            valB = reg_memory[rB];
        end
            
        // mrmovq D(rB), rA
        4'b0101: 
        begin 
            valB = reg_memory[rB];
        end

        // Opq rA, rB
        4'b0110: 
        begin 
            valA = reg_memory[rA];
            valB = reg_memory[rB];
        end

        // jXX Dest
        4'b0111: begin end

        // call Dest
        4'b1000: 
        begin 
            valB = reg_memory[4'b0100];
        end

        // ret
        4'b1001: 
        begin 
            valA = reg_memory[4'b0100];
            valB = reg_memory[4'b0100];
        end

        // pushq rA
        4'b1010: 
        begin 
            valA = reg_memory[rA];
            valB = reg_memory[4'b0100];
        end

        // popq rA
        4'b1011: 
        begin 
            valA = reg_memory[4'b0100];
            valB = reg_memory[4'b0100];
        end
        endcase
    end
endmodule