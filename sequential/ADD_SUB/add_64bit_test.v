module test_add_64bit();

reg signed [63:0] a;
reg signed [63:0] b;
reg m;

wire signed [63:0] sum;
wire OF;

add_sub_64bit Adder64(a,b,sum,m,OF);

initial
    begin
        $dumpfile("add_64_bit_test.vcd");
        $dumpvars(0, test_add_64bit);
        a = 64'b0;
        b = 64'b0;
        m = 0;
        
        //$monitor($time, "a=%b\t%d\n b=%b\t%d\n sum=%b\t%d\n, overflow=%b\n", a,a,b,b,sum, sum, OF);
        $monitor("time: %0d\n a  : %b\t%d\n b  : %b\t%d\n sum: %b\t%d\n overflow=%b\n ", $time, a,a,b,b,sum,sum, OF);


        #5 a=64'd2811; b= 64'd1012;
        #5 a=-64'd1243; b= 64'd1234;
        #5 a=-64'd7478; b=-64'd46474;
        #5 a = 64'd1092835; b = -64'd1020;
        #5 a = 64'd7890678653; b = 64'd4238598110567;

        #5 a = 64'b0111111111111111111111111111111111111111111111111111111111111111; b = 64'd1;
        
        #5 a = -64'd9223372036854770000; b=-64'd6000;

        

    end
endmodule

