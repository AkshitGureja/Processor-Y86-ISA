module m_reg_pipe (clk, e_cnd, e_icode, e_valA, e_valE, e_dstE, e_dstM, 
                M_cnd, M_icode, M_valE, M_valA, M_dstE, M_dstM);

input clk, e_cnd;
// input [2:0] e_stat;
input [3:0] e_icode, e_dstE, e_dstM;
input [63:0] e_valA, e_valE;

output reg M_cnd;
// output [2:0] M_stat;
output reg [3:0] M_icode, M_dstE, M_dstM; 
output reg [63:0] M_valE, M_valA;

always @(posedge clk)
    begin
        // M_stat <= e_stat;
        M_cnd <= e_cnd;
        M_icode <= e_icode;
        // M_ifun <= e_ifun;
        // M_rA <= e_rA;
        // M_rB <= e_rB;
        M_valA <= e_valA;
        // M_valB <= e_valB;
        // M_valC <= e_valC;
        // M_valP <= e_valP;
        M_valE <= e_valE;
        M_dstE <= e_dstE;
        M_dstM <= e_dstM;
    end
endmodule
