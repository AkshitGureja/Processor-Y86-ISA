module memory_seq(clk, icode, valA, valB, valP, valE, valM);

input clk;
input wire [3:0] icode;
input wire [63:0] valA, valB, valP, valE;

output reg [63:0] valM;
reg [63:0] memory [0:127];

always @(*)
begin
    case(icode)

    4'b0101: //mrmovq
    begin valM = memory[valE]; end

    4'b1001: //ret
    begin valM = memory[valA]; end

    4'b1011: //popq
    begin valM = memory[valA]; end
    
    endcase
end

always @(posedge clk) begin
    case(icode)

    4'b0100: //rmmovq
    begin memory[valE] = valA; end

    4'b1000: //call
    begin memory[valE] = valP; end

    4'b1010: //pushq
    begin memory[valE] = valA; end

    endcase
end

endmodule
