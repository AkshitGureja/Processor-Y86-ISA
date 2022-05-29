module test_add_1bit();

reg a,b,c_in;
wire signed sum;
wire c_out;
integer i;

add_1bit Adder(a,b,c_in,sum,c_out);

initial 
    begin
        $dumpfile("add_1bit_test.vcd");
        $dumpvars(0, test_add_1bit);
        {a,b,c_in} = 0;

        $monitor($time, ": a=%b, b=%b, c_in=%b, sum=%b, cout=%b\n", a,b,c_in, sum, c_out);
            for(i = 0; i < 8; i = i + 1) begin
                #5 {a,b,c_in} = i;
            end
    end
endmodule
