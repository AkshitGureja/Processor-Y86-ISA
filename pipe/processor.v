`include "fetch.v"
`include "f_reg.v"
`include "decode.v"
`include "d_reg.v"
`include "execute.v"
`include "e_reg.v"
`include "memory.v"
`include "m_reg.v"
`include "write_back.v"
`include "w_reg.v"
`include "select_PC.v"

module processor();

reg clk;
reg [63:0] f_pc;

wire [63:0] f_valP, f_valC;
wire [3:0] f_icode, f_ifun, f_rA, f_rB;

wire [63:0] F_predPC, predPC;
wire [63:0] PC_new;
wire valid_instruction, memory_error, halt;


wire [3:0] D_icode, D_ifun, D_rA, D_rB;
wire [3:0] d_dstE, d_dstM, d_srcA, d_srcB, d_icode, d_ifun;
wire [63:0] D_valC, D_valP, d_valC;
wire [63:0] d_valA, d_valB;


wire [63:0] e_valE;
wire [3:0] e_dstE;
wire [3:0] e_icode, e_dstM;
wire [63:0] e_valA;
wire [3:0] E_icode, E_ifun, E_srcA, E_srcB, E_dstE, E_dstM;
wire [63:0] E_valA, E_valB, E_valC;
wire e_cnd, ZF, SF, OF;

wire [63:0] M_valA, M_valE;
wire [3:0] M_icode, M_dstE, M_dstM;
wire [3:0]  m_dstE, m_dstM, m_icode;
wire [63:0] m_valE;
wire M_cnd;
wire [63:0] m_valM;

wire [63:0] W_valM, W_valE;
wire [3:0] W_icode, W_dstM, W_dstE;


reg [63:0] reg_file [0:14];
wire [63:0] reg_wire [0:14];

f_reg_pipe FR1(clk, predPC, F_predPC);

d_reg_pipe DR1(clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP);

e_reg_pipe ER1(clk, d_icode, d_ifun, d_valA, d_valB, d_valC, d_srcA, d_srcB, d_dstE, d_dstM, E_icode, E_ifun, E_valA, E_valB, E_valC, E_srcA, E_srcB, E_dstE, E_dstM);

m_reg_pipe MR1(clk, e_cnd, e_icode, e_valA, e_valE, e_dstE, e_dstM, 
                M_cnd, M_icode, M_valE, M_valA, M_dstE, M_dstM);

w_reg_pipe WR1(clk, m_icode, m_valE, m_valM, m_dstE, m_dstM, W_icode, W_valE, W_valM, W_dstE, W_dstM);


fetch_pipe F1(clk, f_pc, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, predPC, valid_instruction, memory_error, halt);

select_PC_pipe SPC1(clk, F_predPC, W_valM, M_valA, M_icode, W_icode, M_cnd, PC_new);

decode_pipe D1(clk, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP,
        e_dstE, e_dstM, e_valE, M_dstE, M_valE, M_dstM, m_valM, W_dstM, W_valM, W_dstE, W_valE,
        reg_file[0], reg_file[1], reg_file[2], reg_file[3], reg_file[4], reg_file[5], reg_file[6], reg_file[7],
        reg_file[8], reg_file[9], reg_file[10], reg_file[11], reg_file[12], reg_file[13], reg_file[14],
        d_dstE, d_dstM, d_srcA, d_srcB, d_valA, d_valB, d_valC, d_icode, d_ifun);

exec_pipe E1(clk, E_icode, E_ifun, E_valA, E_valB, E_valC, e_valE, e_dstE, E_dstE, e_cnd, ZF, SF, OF, e_icode, e_valA, e_dstM);

memory_pipe M1(clk, M_icode, M_valA, M_valE, M_dstE, M_dstM, m_icode, m_dstE, m_dstM, m_valM, m_valE);

wb_seq WB1(clk, W_icode, W_valE, W_valM, W_dstE, W_dstM, 
            reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], reg_wire[4], reg_wire[5], reg_wire[6], reg_wire[7], 
            reg_wire[8], reg_wire[9], reg_wire[10], reg_wire[11], reg_wire[12], reg_wire[13], reg_wire[14]);

// control_logic_pipe CL1(D_icode, d_rA, d_rB, E_icode, E_dstM, e_cnd, M_icode,
// F_bubble, F_stall, D_bubble, D_stall, E_bubble, E_stall);

initial begin
    $dumpfile("pipe_processor.vcd");
    $dumpvars(0, processor);

    clk = 1;
    f_pc = 64'd0;

    $monitor("time=%0d, clk=%0d, f_pc=%0d, f_icode=%0d, f_ifun=%0d, f_rA=%0d, f_rB=%0d, f_valP=%0d, f_valC=%0d, D_icode=%0d, E_icode=%0d, M_icode=%0d, W_icode=%0d, mem_err=%0d, halt=%0d, 0=%0d, 1=%0d, 2=%0d, 3=%0d, 4=%0d, 5=%0d, 6=%0d, 7=%0d, 8=%0d, 9=%0d, 10=%0d, 11=%0d, 12=%0d, 13=%0d, 14=%0d", 
            $time, clk, f_pc, f_icode, f_ifun, f_rA, f_rB, f_valP, f_valC, D_icode, E_icode, M_icode, W_icode, memory_error, halt, 
            reg_file[0], reg_file[1], reg_file[2], reg_file[3], reg_file[4], reg_file[5], reg_file[6], reg_file[7], reg_file[8],
            reg_file[9], reg_file[10], reg_file[11], reg_file[12], reg_file[13], reg_file[14]);
end

always #5 clk = ~clk;

always@(*)
    begin
        if(halt == 1)
            $finish;
    end

always @(*)
    begin
        f_pc <= PC_new;
    end

always @(*)
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



