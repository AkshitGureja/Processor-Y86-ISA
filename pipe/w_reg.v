module w_reg_pipe (clk, m_icode, m_valE, m_valM, m_dstE, m_dstM, W_icode, W_valE, W_valM, W_dstE, W_dstM);

input clk;
// input [2:0] W_stat;
input [3:0] m_icode, m_dstE, m_dstM;
input [63:0] m_valE, m_valM;

output reg m_cnd;
// output [2:0] m_stat;
output reg [3:0] W_icode, W_dstE, W_dstM;
output reg [63:0] W_valE, W_valM;

always @(posedge clk)
    begin
        // W_stat <= m_stat;
        // W_cnd <= m_cnd;
        W_icode <= m_icode;
        // W_ifun <= m_ifun;
        // W_rA <= m_rA;
        // W_rB <= m_rB;
        // W_valA <= m_valA;
        // W_valB <= m_valB;
        // W_valC <= m_valC;
        // W_valP <= m_valP;
        W_valE <= m_valE;
        W_valM <= m_valM;
        W_dstE <= m_dstE;
        W_dstM <= m_dstM;
    end
endmodule
        
