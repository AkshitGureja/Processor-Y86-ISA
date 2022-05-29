module add_sub_64bit(a,b,sum,m, OF);

input signed [63:0] a;
input signed [63:0] b;
input m;
output signed [63:0] sum;
output OF;

// declaring carry as a wire
// note we need to take 65 bits for the carry
wire [64:0] carry;

// the input carry is 0 for addition and 1 for subtraction
assign carry[0] = m;

wire [63:0] b_xor_m;

// defining the variable for the generate block
genvar i;

// implementing the binary adder subtractor by using generate block
// We use generate block because it gives us multiple instances of the module
generate for(i = 0; i < 64; i = i + 1)
begin
    xor X11(b_xor_m[i], b[i], m);
end
endgenerate

genvar j;
generate for(j = 0; j < 64; j = j + 1)
begin
    add_1bit A11(a[j], b_xor_m[j], carry[j], sum[j], carry[j+1]);
end
endgenerate

// now the final output carry bit will give us the information if an overflow has happened or not
// as we are dealing with signed numbers, the overflow will be detected by the xor of the last 2 carries
 
xor X2(OF, carry[64], carry[63]);

endmodule


