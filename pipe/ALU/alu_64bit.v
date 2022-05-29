`include "./ADD_SUB/add_sub_64bit.v"
`include "./ADD_SUB/add_1bit.v"
`include "./XOR_64bit/xor_64bit.v"
`include "./AND_64bit/and_64bit.v"

module ALU_64bit(control, a, b, out, OF);

input [1:0] control;
input signed [63:0] a;
input signed [63:0] b;
output signed [63:0] out;
output OF;

wire signed [63:0] sum1, sum2, sum3;
reg [63:0] sum;
reg overflow;

add_sub_64bit adder64(a,b, sum1, control[0], OF);
and_64bit and64(a,b,sum2);
xor_64bit xor64(a,b,sum3);

always@(*)
begin
    case(control)
    2'b00, 2'b01: begin 
        sum=sum1; 
    end
    2'b10: begin sum=sum2; end
    2'b11: begin sum=sum3; end
    endcase
end

assign out=sum;

endmodule

