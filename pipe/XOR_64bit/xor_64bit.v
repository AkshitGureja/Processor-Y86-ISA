module xor_64bit(a, b, c);

input [63:0] a, b;
output [63:0] c;
genvar i;

generate
    for(i = 0; i < 64; i = i+1)
        begin
            xor x1(c[i], a[i], b[i]);
        end
endgenerate

endmodule
