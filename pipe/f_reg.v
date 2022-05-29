module f_reg_pipe(clk, predPC, F_predPC);

input clk;
input [63:0] predPC;
output reg [63:0] F_predPC;

always @(posedge clk)
    begin
        F_predPC <= predPC;
    end
endmodule
