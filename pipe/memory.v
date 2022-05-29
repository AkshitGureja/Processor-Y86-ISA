module memory_pipe(clk, M_icode, M_valA, M_valE, M_dstE, M_dstM, m_icode, m_dstE, m_dstM, m_valM, m_valE);

input clk;
input wire [3:0] M_icode, M_dstE, M_dstM;
input wire [63:0] M_valA, M_valE;

output reg [63:0] m_valM;
output reg [63:0] m_valE;
output reg [3:0] m_icode, m_dstE, m_dstM;
reg [63:0] memory [0:127];

always @(*)
begin
    case(M_icode)

    4'b0101: //mrmovq
    begin m_valM = memory[M_valE]; end

    4'b1001: //ret
    begin m_valM = memory[M_valA]; end

    4'b1011: //popq
    begin m_valM = memory[M_valA]; end
    
    endcase
end

always @(posedge clk) begin
    case(M_icode)

    4'b0100: //rmmovq
    begin memory[M_valE] = M_valA; end

    4'b1000: //call
    begin memory[M_valE] = M_valA; end

    4'b1010: //pushq
    begin memory[M_valE] = M_valA; end

    endcase
end

always@(*)
    begin
        m_icode = M_icode;
        m_dstE = M_dstE;
        m_dstM = M_dstM;
        m_valE = M_valE;
    end

endmodule
