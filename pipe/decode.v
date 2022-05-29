module decode_pipe(clk, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP,
        e_dstE, e_dstM, e_valE, M_dstE, M_valE, M_dstM, m_valM, W_dstM, W_valM, W_dstE, W_valE,
        reg_file0, reg_file1, reg_file2, reg_file3, reg_file4, reg_file5, reg_file6, reg_file7,
        reg_file8, reg_file9, reg_file10, reg_file11, reg_file12, reg_file13, reg_file14,
        d_dstE, d_dstM, d_srcA, d_srcB, d_valA, d_valB, d_valC, d_icode, d_ifun);

input clk;
input [3:0] D_icode;
input [3:0] D_ifun;
input [3:0] D_rA;
input [3:0] D_rB;
input [63:0] D_valC;
input [63:0] D_valP;

input [3:0] e_dstE;
input [3:0] e_dstM;
input [3:0] M_dstE;
input [3:0] M_dstM;
input [3:0] W_dstM;
input [3:0] W_dstE;

input [63:0] e_valE;
input [63:0] M_valE;
input [63:0] m_valM;
input [63:0] W_valM;
input [63:0] W_valE;

reg [63:0] rvalA;
reg [63:0] rvalB;

output reg [63:0] d_valA;
output reg [63:0] d_valB;
output reg [63:0] d_valC;
output reg [3:0] d_dstE;
output reg [3:0] d_dstM;
output reg [3:0] d_srcA;
output reg [3:0] d_srcB;
output reg [3:0] d_icode, d_ifun;

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

        // determining d_srcA
        case(D_icode)
        4'b0010, 4'b0100, 4'b0110, 4'b1010: begin d_srcA = D_rA; end
        4'b1011, 4'b1001: begin d_srcA = 4'b0100; end
        default: begin d_srcA = 4'b1111; end
        endcase

        // determining d_srcB
        case(D_icode)
        4'b0110, 4'b0100, 4'b0101: begin d_srcB = D_rB; end
        4'b1010, 4'b1011, 4'b1000, 4'b1001: begin d_srcB = 4'b0100; end
        default: begin d_srcB = 4'b1111; end
        endcase

        // determining d_dstM
        case(D_icode)
        4'b0101, 4'b1011: begin d_dstM = D_rA; end
        default: begin d_dstM = 4'b1111; end
        endcase

        //determining d_dstE
        case(D_icode)
        4'b0010, 4'b0011, 4'b0110: begin d_dstE = D_rB; end
        4'b1000, 4'b1001, 4'b1010, 4'b1011: begin d_dstE = 4'b0100; end
        default: begin d_dstE = 4'b1111; end
        endcase

        case(D_icode)
        // halt (not sure to include or not)
        4'b0000: begin end

        // nop
        4'b0001: begin end

        // cmovxx rA, rB
        4'b0010: 
        begin 
            rvalA = reg_memory[d_srcA];
        end

        // irmovq V, rB
        4'b0011: begin end

        // rmmovq rA, D(rB)
        4'b0100: 
        begin 
            rvalA = reg_memory[d_srcA];
            rvalB = reg_memory[d_srcB];
        end
            
        // mrmovq D(rB), rA
        4'b0101: 
        begin 
            rvalB = reg_memory[d_srcB];
        end

        // Opq rA, rB
        4'b0110: 
        begin 
            rvalA = reg_memory[d_srcA];
            rvalB = reg_memory[d_srcB];
        end

        // jXX Dest
        4'b0111: begin end

        // call Dest
        4'b1000: 
        begin 
            rvalB = reg_memory[4'b0100];
        end

        // ret
        4'b1001: 
        begin 
            rvalA = reg_memory[4'b0100];
            rvalB = reg_memory[4'b0100];
        end

        // pushq rA
        4'b1010: 
        begin 
            rvalA = reg_memory[d_srcA];
            rvalB = reg_memory[4'b0100];
        end

        // popq rA
        4'b1011: 
        begin 
            rvalA = reg_memory[4'b0100];
            rvalB = reg_memory[4'b0100];
        end
        endcase
    end

always@(*)
    begin
        if(D_icode == 7 || D_icode == 8)
            d_valA = D_valP;
        else if(d_srcA == e_dstM)
            d_valA = e_valE;
        else if(d_srcA == M_dstM)
            d_valA = m_valM;
        else if(d_srcA == M_dstE)
            d_valA = M_valE;
        else if(d_srcA == W_dstM)
            d_valA = W_valM;
        else if(d_srcA == W_dstE)
            d_valA = W_valE;
        else
            d_valA = rvalA;

    end

always@(*)
    begin
        if(d_srcB == e_dstE)
            d_valB = e_valE;
        else if(d_srcB == M_dstM)
            d_valB = m_valM;
        else if(d_srcB == M_dstE)
            d_valB = M_valE;
        else if(d_srcB == W_dstM)
            d_valB = W_valM;
        else if(d_srcB == W_dstE)
            d_valB = W_valE;
        else
            d_valB = rvalB;
    end

always@(*)
    begin
        d_icode = D_icode;
        d_ifun = D_ifun;
        d_valC = D_valC;
    end


endmodule
