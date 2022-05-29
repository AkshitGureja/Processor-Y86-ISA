
module testbench;

reg signed [63:0] a, b;
wire signed [63:0] c;
integer i;

and_64bit dut(.a(a), .b(b), .c(c));

initial begin
    $dumpfile("and_64bit.vcd");
    $dumpvars(0, testbench);

    a = 64'b0; b = 64'b0;

    $monitor("a = %b\nb = %b\nc = %b\n\n" , a, b, c);

    #10
    a = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    b = 64'b1111111111111111111111111111111111111111111111111111111111111111;

    #10 a = 64'd1134; b = 64'd8238;
    #10 a = -64'd7478; b = -64'd46474;
    #10 a = 64'd1092835; b = -64'd1020;
    #10 a = 64'd7890678653; b = 64'd4238598110567;

end
endmodule
