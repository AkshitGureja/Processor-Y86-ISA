`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"
`include "pc_update.v"

module processor();

reg clk;
reg [63:0] PC;

wire [3:0] icode, ifun, rA, rB;
wire [63:0] valC, valP;
wire [63:0] valA, valB, valE;
wire [63:0] valM;

wire cnd, ZF, SF, OF;

wire memory_error, halt, invalid_instr;
wire [63:0] PC_new;

reg [63:0] reg_file [0:14];
wire [63:0] reg_wire [0:14];

reg status[0:3];

fetch F1(clk, PC, icode, ifun, rA, rB, valC, valP, memory_error, halt, invalid_instr);
decode_seq D1(clk, icode, rA, rB, valA, valB, reg_file[0], reg_file[1], reg_file[2], reg_file[3], reg_file[4], reg_file[5], reg_file[6], reg_file[7], reg_file[8], reg_file[9], reg_file[10], reg_file[11], reg_file[12], reg_file[13], reg_file[14]);
exec_seq E1(clk, icode, ifun, valA, valB, valC, valE, cnd, ZF, SF, OF);
memory_seq M1(clk, icode, valA, valB, valP, valE, valM);
wb_seq w1(clk, icode, rA, rB, valE, valM, reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], reg_wire[4], reg_wire[5], reg_wire[6], reg_wire[7], reg_wire[8], reg_wire[9], reg_wire[10], reg_wire[11], reg_wire[12], reg_wire[13], reg_wire[14]);
pc_update P1(clk, icode, cnd, valC, valM, valP, PC_new);

initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0, processor);

    PC = 64'd0;
    status[0] = 1;
    status[1] = 0;
    status[2] = 0;
    status[3] = 0;

    $monitor("time=%0d  clk=%0d  PC=%0d icode=%0h  ifun=%0d  rA=%0d  rB=%0d  valC=%0d  valP=%0d  memory_error=%0d, halt=%0d, 0=%0d  1=%0d  2=%0d  3=%0d  4=%0d  5=%0d  6=%0d  7=%0d  8=%0d  9=%0d  10=%0d  11=%0d  12=%0d  13=%0d  14=%0d valA=%0d, valB=%0d", $time, clk, PC, icode, ifun, rA, rB, valC, valP, memory_error, halt, reg_file[0], reg_file[1], reg_file[2], reg_file[3], reg_file[4], reg_file[5], reg_file[6], reg_file[7], reg_file[8], reg_file[9], reg_file[10], reg_file[11], reg_file[12], reg_file[13], reg_file[14], valA, valB);
    clk = 1;
    #5 clk = ~clk;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;
    #5 clk = ~clk; //PC = PC_new;    
    #5 clk = ~clk;
    #5 clk = ~clk;
    #5 clk = ~clk;


end

always @(posedge clk) begin
    
    PC = PC_new;
end

always@(*)
    begin
        if(halt == 1)
            begin
                status[0] = 0;
                status[1] = 1;
                status[2] = 0;
                status[3] = 0;
                $finish;
            end
        
        else if(memory_error == 1)
            begin
                status[0] = 0;
                status[1] = 0;
                status[2] = 1;
                status[3] = 0;
                $finish;
            end
        else if(invalid_instr == 1)
            begin
                status[0] = 0;
                status[1] = 0;
                status[2] = 0;
                status[3] = 1;
                $finish;
            end
        else
            begin
                status[0] = 1;
                status[1] = 0;
                status[2] = 0;
                status[3] = 0;
            end
    end

always@(*)
    begin
        reg_file[0] = reg_wire[0];
        reg_file[1] = reg_wire[1];
        reg_file[2] = reg_wire[2];
        reg_file[3] = reg_wire[3];
        reg_file[4] = reg_wire[4];
        reg_file[5] = reg_wire[5];
        reg_file[6] = reg_wire[6];
        reg_file[7] = reg_wire[7];
        reg_file[8] = reg_wire[8];
        reg_file[9] = reg_wire[9];
        reg_file[10] = reg_wire[10];
        reg_file[11] = reg_wire[11];
        reg_file[12] = reg_wire[12];
        reg_file[13] = reg_wire[13];
        reg_file[14] = reg_wire[14];

    end

endmodule
