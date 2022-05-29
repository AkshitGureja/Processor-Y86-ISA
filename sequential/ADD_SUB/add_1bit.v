module add_1bit(a,b,c_in,sum,c_out);

input a,b,c_in;
output sum,c_out;

//implementing a 1-bit full adder

// gate implementation for the sum
xor X1(w1, a, b);
xor X2(sum, w1, c_in);

// gate implementation for the carry bit
and A1(w2, a, b);
and A2(w3, w1, c_in);
or O1(c_out, w2, w3);

endmodule

