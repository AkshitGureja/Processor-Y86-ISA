module wb_seq(clk, W_icode, W_valE, W_valM, W_dstE, W_dstM, reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7, reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14);

input clk;
input [3:0] W_icode, W_dstE, W_dstM;
input [63:0] W_valE, W_valM;

output reg [63:0] reg_file0;
output reg [63:0] reg_file1;
output reg [63:0] reg_file2;
output reg [63:0] reg_file3;
output reg [63:0] reg_file4;
output reg [63:0] reg_file5;
output reg [63:0] reg_file6;
output reg [63:0] reg_file7;
output reg [63:0] reg_file8;
output reg [63:0] reg_file9;
output reg [63:0] reg_file10;
output reg [63:0] reg_file11;
output reg [63:0] reg_file12;
output reg [63:0] reg_file13;
output reg [63:0] reg_file14;

reg [63:0] reg_memory [0:14];

initial 
    begin
        reg_memory[0] = 64'd0;
        reg_memory[1] = 64'd0;
        reg_memory[2] = 64'd0;
        reg_memory[3] = 64'd0;
        reg_memory[4] = 64'd0;
        reg_memory[5] = 64'd0;
        reg_memory[6] = 64'd0;
        reg_memory[7] = 64'd0;
        reg_memory[8] = 64'd0;
        reg_memory[9] = 64'd0;
        reg_memory[10] = 64'd0;
        reg_memory[11] = 64'd0;
        reg_memory[12] = 64'd0;
        reg_memory[13] = 64'd0;
        reg_memory[14] = 64'd0;

        // $dumpvars(0, reg_memory[2], reg_memory[3], reg_memory[4]);

    end

always@(posedge clk)
    begin
        case(W_icode)
        // halt (not sure if we have to include)
        4'b0000: begin end

        // nop
        4'b0001: begin end

        // cmovxx rA, rB
        4'b0010: begin reg_memory[W_dstE] = W_valE; end

        // irmovq V, rB
        4'b0011: begin reg_memory[W_dstE] = W_valE; end

        // rmmovq rA, D(rB)
        4'b0100: begin end

        // mrmovq D(rB), rA
        4'b0101: begin reg_memory[W_dstM] = W_valM; end

        // Opq rA, rB
        4'b0110: begin reg_memory[W_dstE] = W_valE; end

        // jXX Dest
        4'b0111: begin end

        // call Dest
        4'b1000: begin reg_memory[4'b0100] = W_valE; end

        // ret
        4'b1001: begin reg_memory[4'b0100] = W_valE; end

        // pushq rA
        4'b1010: begin reg_memory[4'b0100] = W_valE; end

        // popq rA
        4'b1011: 
        begin 
            reg_memory[4'b0100] = W_valE;
            reg_memory[W_dstM] = W_valM;
        end
        endcase
    end

    always @(*) begin

        reg_file0 = reg_memory[0];
        reg_file1 = reg_memory[1];
        reg_file2 = reg_memory[2];
        reg_file3 = reg_memory[3];
        reg_file4 = reg_memory[4];
        reg_file5 = reg_memory[5];
        reg_file6 = reg_memory[6];
        reg_file7 = reg_memory[7];
        reg_file8 = reg_memory[8];
        reg_file9 = reg_memory[9];
        reg_file10 = reg_memory[10];
        reg_file11 = reg_memory[11];
        reg_file12 = reg_memory[12];
        reg_file13 = reg_memory[13];
        reg_file14 = reg_memory[14];      
    end
    
endmodule