`include "./ALU/alu_64bit.v" // correct this before testing

module exec_pipe(clk, E_icode, E_ifun, E_valA, E_valB, E_valC, e_valE, e_dstE, E_dstE, e_cnd, ZF, SF, OF, e_icode, e_valA, e_dstM);

input clk;
input [3:0] E_icode, E_ifun, E_dstE, E_dstM;
input [63:0] E_valA, E_valB, E_valC;

output reg [63:0] e_valE;
output reg [3:0] e_dstE;
output reg [3:0] e_icode, e_dstM;
output reg [63:0] e_valA;
output reg e_cnd, ZF, SF, OF;

reg [1:0] control;
reg signed [63:0] aluA;
reg signed [63:0] aluB;
reg signed [63:0] ans;

wire signed [63:0] out;
wire overflow;

ALU_64bit alu(control, aluA, aluB, out, overflow);

always @(*)
    begin
        e_cnd = 0;
        // ZF = 0; OF = 0; SF=0; not sure right now

        case(E_icode)
        // halt (not sure if we have to include)
        4'b0000: begin end

        // nop
        4'b0001: begin end

        // cmovXX rA, rB
        4'b0010:
        begin            
            case(E_ifun)
            // rrmovq
            4'b0000: 
            begin 
                e_cnd = 1; // unconditional move instr              
            end
                
            // cmovle
            4'b0001: 
            begin
                cndA = SF; cndB = OF;
                cndA = xor_out; cndB = ZF;
                if(or_out)
                    e_cnd = 1;
            end

            // cmovl
            4'b0010: 
            begin 
                cndA = SF; cndB = OF;
                if(xor_out)
                    e_cnd = 1;
            end

            // cmove
            4'b0011: 
            begin 
                if(ZF)
                    e_cnd = 1;
            end

            // cmovne
            4'b0100: 
            begin 
                cndA = ZF;
                if(not_out)
                    e_cnd = 1;
            end

            // cmovge
            4'b0101: 
            begin 
                cndA = SF;
                cndB = OF;
                cndA = xor_out;
                if(not_out)
                    e_cnd = 1;
            end

            // cmovg
            4'b0110: 
            begin 
                cndA = SF; cndB = OF;
                cndA = xor_out;
                if(not_out)
                    begin
                        cndA = ZF;
                        if(not_out)
                            e_cnd = 1;
                    end
            end
            endcase
            aluA = E_valA;
            aluB = 64'd0;
            control = 2'b00; // valE = valA + 0
        end

        // irmovq V, rB
        4'b0011: 
        begin 
            // valE = 0 + valC
            aluA = E_valC;
            aluB = 64'd0;
            control = 2'b00;
        end

        // rmmovq rA, D(rB)
        4'b0100: 
        begin 
            // valE = valB + valC
            aluA = E_valC;
            aluB = E_valB;
            control = 2'b00;
        end

        // mrmovq D(rB), rA
        4'b0101: 
        begin 
            // valE = valB + valC
            aluA = E_valC;
            aluB = E_valB;
            control = 2'b00;
        end

        // Opq rA, rB
        4'b0110: 
        begin
            aluA = E_valA;
            aluB = E_valB;

            case(E_ifun)
            // addq
            4'b0000: 
            begin 
                control = 2'b00; // valE = valA + valB;
            end

            // subq
            4'b0001: 
            begin 
                control = 2'b01; // valE = valA - valB;
            end

            // andq
            4'b0010: 
            begin 
                control = 2'b10; // valE = valA & valB;
            end

            // xorq
            4'b0011: 
            begin 
                control = 2'b11; // valE = valA ^ valB;
            end
            endcase
        end

        // jXX Dest
        4'b0111:
        begin
            case(E_ifun)
            // jmp
            4'b0000: 
            begin 
                e_cnd = 1; // unconditional jump
            end

            // jle
            4'b0001: 
            begin 
                cndA = SF; cndB = OF;
                cndA = xor_out; cndB = ZF;
                if(or_out)
                    e_cnd = 1;
            end

            // jl
            4'b0010: 
            begin 
                cndA = SF; cndB = OF;
                if(xor_out)
                    e_cnd = 1;
            end

            // je
            4'b0011:
            begin 
                if(ZF)
                    e_cnd = 1;
            end

            // jne
            4'b0100: 
            begin 
                cndA = ZF;
                if(not_out)
                    e_cnd = 1;
            end

            // jge
            4'b0101: 
            begin 
                cndA = SF;
                cndB = OF;
                cndA = xor_out;
                if(not_out)
                    e_cnd = 1;
            end

            // jg
            4'b0110: 
            begin 
                cndA = SF; cndB = OF;
                cndA = xor_out;
                cndA = not_out;
                if(not_out)
                    begin
                        cndA = ZF;
                        if(not_out)
                            e_cnd = 1;
                    end
            end
            endcase
        end 

        // call Dest
        4'b1000: 
        begin 
            // valE = valB - 8
            aluA = -64'd8;
            aluB = E_valB;
            control = 2'b00; // to decrement the stack pointer by 8 on call
        end

        // ret
        4'b1001: 
        begin 
            // valE = valB + 8
            aluA = 64'd8;
            aluB = E_valB;
            control = 2'b00; // to increment the stack pointer by 8 on ret
        end

        // pushq rA
        4'b1010: 
        begin 
            // valE = valB - 8
            aluA = -64'd8;
            aluB = E_valB;
            control = 2'b00; // to decrement the stack pointer by 8 on pushq
        end

        // popq rA
        4'b1011: 
        begin 
            // valE = valB + 8
            aluA = 64'd8;
            aluB = E_valB;
            control = 2'b00; // to increment the stack pointer by 8 on popq
        end
        endcase
        ans = out;
        e_valE = ans;
    end

always @(out or aluA or aluB)
    begin
        ZF = (out == 64'b0); // output of ALU is zero
        SF = (out < 64'b0); // output of ALU is negative
        OF = (aluA < 1'b0 == aluB < 1'b0) && (out < 64'b0 != aluA < 1'b0); // signed overflow flag
    end

reg cndA;
reg cndB;
reg xor_out;
reg and_out;
reg or_out;
reg not_out;

always @(cndA or cndB)
    begin
        // and A1(and_out, cndA, cndB);
        // or O1(or_out, cndA, cndB);
        // xor X1(xor_out, cndA, cndB);
        // not N1(not_out, cndA);
        and_out = cndA & cndB;
        or_out = cndA | cndB;
        xor_out = cndA ^ cndB;
        not_out = ~cndA;
    end

always@(*)
    begin
        if((E_icode == 2) && (!e_cnd))
            e_dstE = 4'b1111;
        else
            e_dstE = E_dstE;
    end

always@(*)
    begin
       e_icode = E_icode;
       e_dstM = E_dstM;
       e_valA = E_valA;
    end

endmodule
