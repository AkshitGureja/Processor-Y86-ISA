module e_reg_pipe (clk, d_icode, d_ifun, d_valA, d_valB, d_valC, d_srcA, d_srcB, d_dstE, d_dstM, E_icode, E_ifun, E_valA, E_valB, E_valC, E_srcA, E_srcB, E_dstE, E_dstM);

input clk;
// input [2:0] d_stat;
input [3:0] d_icode, d_ifun, d_dstE, d_dstM, d_srcA, d_srcB;
input [63:0] d_valA, d_valB, d_valC; //, d_valP;

//output [2:0] E_stat;
output reg [3:0] E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB;
output reg [63:0] E_valA, E_valB, E_valC;//, E_valP;

always @(posedge clk)
    begin
        //E_stat <= d_stat;
        E_icode <= d_icode;
        E_ifun <= d_ifun;
        //E_rA <= d_rA;
        //E_rB <= d_rB;
        E_dstE <= d_dstE;
        E_dstM <= d_dstM;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB;
        
        E_valA <= d_valA;
        E_valB <= d_valB;
        E_valC <= d_valC;
        //E_valP <= d_valP;
        end
endmodule
