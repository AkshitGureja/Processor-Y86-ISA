module select_PC_pipe(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_cnd, PC_new);

input clk;
input [63:0] F_predPC, W_valM, M_valA;
input [3:0] M_icode, W_icode;
input M_cnd;

output reg [63:0] PC_new;

always @(*)
    begin
        if(M_icode==7 && !M_cnd)
        begin
            PC_new <= M_valA;
        end
        else if(W_icode==9)
        begin
            PC_new <= W_valM;
        end
        else
        begin
            PC_new <= F_predPC;
        end
    end

endmodule
