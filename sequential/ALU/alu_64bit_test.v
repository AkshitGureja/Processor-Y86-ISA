module test_alu_64();

reg [1:0] control;
reg signed [63:0] a;
reg signed [63:0] b;

wire signed [63:0] out;
wire OF;

ALU_64bit alu(control, a, b, out, OF);

initial 
    begin
        $dumpfile("ALU_64bit_test.vcd");
        $dumpvars(0, test_alu_64);
        control = 2'b00;
        a = 64'd256;
        b = 64'd255;
        #10

        $monitor("time=%0d  control=%d  a=%d  b=%d  output=%d  overflow=%d\n", $time, control, a, b, out, OF);

        #5 a=-64'd543; b=-64'd464;
        #5 a = 64'b0111111111111111111111111111111111111111111111111111111111111111; b = 64'd1;
        #5 a = -64'd9223372036854775000; b=-64'd6000;

        
        #5 control = 2'b01; a=-64'd7478; b=-64'd46474;
        #5 a = 64'd9223372036854775000; b = 64'd6000;

        #5 control = 2'b10; a = 64'd1092835; b = -64'd1020;

        $monitor("time=%0d  control=%d\n a:      %d\n b:      %d\n output: %d\n overflow=%d\n", $time, control, a, b, out, OF);

        #5 a = 64'd7890678653; b = 64'd4238598110567;

        #5 control = 2'b11; a = 64'd1092835; b = -64'd1020;
        #5 a = 64'd7890678653; b = 64'd4238598110567;

        #5 control = 2'b10; a = 64'd1092835; b = -64'd1020;
        #5 a = 64'd7890678653; b = 64'd4238598110567;

    end
endmodule