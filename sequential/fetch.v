module fetch(clk, PC, icode, ifun, rA, rB, valC, valP,
             memory_error, halt, invalid_instr);

input clk;
input [63:0] PC; //program counter
reg [0:7] reg_AB;

output reg [3:0] icode, ifun, rA, rB;
output reg [63:0] valC, valP;
// output [63:0] updated_PC;
reg [0:7] instruction;


reg [7:0] instruction_memory [0:127];
// [][][][][][][][] 0
// [][][][][][][][] 1
// [][][][][][][][] 2
// [][][][][][][][] 3
// [][][][][][][][] 4
//so on
output reg memory_error, halt,invalid_instr;


initial begin
    halt = 0;
    instruction_memory[0]  = 8'b00010000; // nop instruction PC = PC +1 = 1
    instruction_memory[1]  = 8'b01100000; // Opq add
    instruction_memory[2]  = 8'b00000001; // rA = 0, rB = 1; PC = PC + 2 = 3

    instruction_memory[3]  = 8'b00110000; // irmovq instruction PC = PC + 10 = 13
    instruction_memory[4]  = 8'b11110010; // F, rB = 2;
    instruction_memory[5]  = 8'b11111111; // 1st byte of V = 255, rest all bytes will be zero
    instruction_memory[6]  = 8'b00000000; // 2nd byte
    instruction_memory[7]  = 8'b00000000; // 3rd byte
    instruction_memory[8]  = 8'b00000000; // 4th byte
    instruction_memory[9]  = 8'b00000000; // 5th byte
    instruction_memory[10] = 8'b00000000; // 6th byte
    instruction_memory[11] = 8'b00000000; // 7th byte
    instruction_memory[12] = 8'b00000000; // 8th byte (This completes irmovq)

    instruction_memory[13] = 8'b00110000; // irmovq instruction PC = PC + 10 = 23
    instruction_memory[14] = 8'b11110011; // F, rB = 3;
    instruction_memory[15] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    instruction_memory[16] = 8'b00000000; // 2nd byte
    instruction_memory[17] = 8'b00000000; // 3rd byte
    instruction_memory[18] = 8'b00000000; // 4th byte
    instruction_memory[19] = 8'b00000000; // 5th byte
    instruction_memory[20] = 8'b00000000; // 6th byte
    instruction_memory[21] = 8'b00000000; // 7th byte
    instruction_memory[22] = 8'b00000000; // 8th byte (This completes irmovq)

    instruction_memory[23] = 8'b00110000; // irmovq instruction PC = PC + 10 = 33
    instruction_memory[24] = 8'b11110100; // F, rB = 4;
    instruction_memory[25] = 8'b00000101; // 1st byte of V = 5, rest all bytes will be zero
    instruction_memory[26] = 8'b00000000; // 2nd byte
    instruction_memory[27] = 8'b00000000; // 3rd byte
    instruction_memory[28] = 8'b00000000; // 4th byte
    instruction_memory[29] = 8'b00000000; // 5th byte
    instruction_memory[30] = 8'b00000000; // 6th byte
    instruction_memory[31] = 8'b00000000; // 7th byte
    instruction_memory[32] = 8'b00000000; // 8th byte (This completes irmovq)

    instruction_memory[33] = 8'b00100000; // rrmovq // PC = PC + 2 = 35
    instruction_memory[34] = 8'b01000101; // rA = 4; rB = 5; 

    instruction_memory[35] = 8'b01100000; // Opq add // PC = PC + 2 = 37
    instruction_memory[36] = 8'b00110100; // rA = 3 and rB = 4, final value in rB(4) = 10;

    instruction_memory[37] = 8'b00100101; // cmovge // PC = PC + 2 = 39
    instruction_memory[38] = 8'b01010110; // rA = 5; rB = 6;

    instruction_memory[39] = 8'b01100001; // Opq subq // PC = PC + 2 = 41
    instruction_memory[40] = 8'b00110101; // rA = 3, rB = 5; both are equal

    instruction_memory[41] = 8'b01110011; //je // PC = PC + 9 = 50
    instruction_memory[42] = 8'b00110100; // Dest = 52; 1st byte
    instruction_memory[43] = 8'b00000000; // 2nd byte
    instruction_memory[44] = 8'b00000000; // 3rd byte
    instruction_memory[45] = 8'b00000000; // 4th byte
    instruction_memory[46] = 8'b00000000; // 5th byte
    instruction_memory[47] = 8'b00000000; // 6th byte
    instruction_memory[48] = 8'b00000000; // 7th byte
    instruction_memory[49] = 8'b00000000; // 8th byte

    instruction_memory[50] = 8'b00010000; // nop 
    instruction_memory[51] = 8'b00010000; // nop

    instruction_memory[52] = 8'b01100000; // Opq add
    instruction_memory[53] = 8'b00110101; // rA = 3; rB = 5;

    instruction_memory[54] = 8'b00000000; // halt
end

always @ (*)
    begin
        memory_error = 0;
        if(PC > 127) //may be changed at my/akshit's discretion
        begin
            memory_error = 1;
        end

        // instruction = {instruction_memory[PC]};
        icode = instruction_memory[PC][7:4];
        ifun =  instruction_memory[PC][3:0];
        // icode = instruction[3:0];
        // ifun = instruction[7:4];

        if(icode>=4'b0000 && icode<4'b1100)
        begin
            invalid_instr = 0;
            case(icode)

            4'b0000: //halt
            begin
                halt = 1;
                valP = PC + 64'd1;
            end

            4'b0001: //nop
            begin
                valP = PC + 64'd1;
            end

            4'b0010: //cmovXX
            begin
                reg_AB = {instruction_memory[PC+1]};
                rA = reg_AB[0:3]; //rA = {instruction_memory[PC+1]}[0:3];
                rB = reg_AB[4:7]; //rB = {instruction_memory[PC+1]}[4:7];
                valP = PC + 64'd2;
            end

            4'b0011: //irmovq
            begin
                reg_AB = {instruction_memory[PC+1]};
                rA = reg_AB[0:3]; //rA = {instruction_memory[PC+1]}[0:3];
                rB = reg_AB[4:7]; //rB = {instruction_memory[PC+1]}[4:7];
                valC = { instruction_memory[PC+9],
                                    instruction_memory[PC+8],
                                    instruction_memory[PC+7],
                                    instruction_memory[PC+6],
                                    instruction_memory[PC+5],
                                    instruction_memory[PC+4],
                                    instruction_memory[PC+3],
                                    instruction_memory[PC+2] };
                valP = PC + 64'd10;
            end
        
            4'b0100: //rmmovq
            begin
                reg_AB = {instruction_memory[PC+1]};
                rA = reg_AB[0:3]; //rA = {instruction_memory[PC+1]}[0:3];
                rB = reg_AB[4:7]; //rB = {instruction_memory[PC+1]}[4:7];
                valC = { instruction_memory[PC+9],
                                    instruction_memory[PC+8],
                                    instruction_memory[PC+7],
                                    instruction_memory[PC+6],
                                    instruction_memory[PC+5],
                                    instruction_memory[PC+4],
                                    instruction_memory[PC+3],
                                    instruction_memory[PC+2] };
                valP = PC + 64'd10;
            end
        
            4'b0101: //mrmovq
            begin
                reg_AB = {instruction_memory[PC+1]};
                rA = reg_AB[0:3]; //rA = {instruction_memory[PC+1]}[0:3];
                rB = reg_AB[4:7]; //rB = {instruction_memory[PC+1]}[4:7];
                valC = { instruction_memory[PC+9],
                                    instruction_memory[PC+8],
                                    instruction_memory[PC+7],
                                    instruction_memory[PC+6],
                                    instruction_memory[PC+5],
                                    instruction_memory[PC+4],
                                    instruction_memory[PC+3],
                                    instruction_memory[PC+2] };
                valP = PC + 64'd10;
            end

            4'b0110: //OPq
            begin
                reg_AB = {instruction_memory[PC+1]};
                rA = reg_AB[0:3]; //rA = {instruction_memory[PC+1]}[0:3];
                rB = reg_AB[4:7]; //rB = {instruction_memory[PC+1]}[4:7];
                valP = PC + 64'd2;
            end

            4'b0111: //jXX
            begin
                valC = { instruction_memory[PC+8],
                        instruction_memory[PC+7],
                        instruction_memory[PC+6],
                        instruction_memory[PC+5],
                        instruction_memory[PC+4],
                        instruction_memory[PC+3],
                        instruction_memory[PC+2],
                        instruction_memory[PC+1] };
                valP = PC + 64'd9;
            end

            4'b1000: //call
            begin
                valC = { instruction_memory[PC+8],
                        instruction_memory[PC+7],
                        instruction_memory[PC+6],
                        instruction_memory[PC+5],
                        instruction_memory[PC+4],
                        instruction_memory[PC+3],
                        instruction_memory[PC+2],
                        instruction_memory[PC+1] };
                valP = PC + 64'd9;
            end

            4'b1001: //ret
            begin
                valP = PC + 64'd1;
            end

            4'b1010: //pushq
            begin
                reg_AB = {instruction_memory[PC+1]};
                rA = reg_AB[0:3]; //rA = {instruction_memory[PC+1]}[0:3];
                rB = reg_AB[4:7]; //rB = {instruction_memory[PC+1]}[4:7];
                valP = PC + 64'd2;
            end

            4'b1011: //popq
            begin
                reg_AB = {instruction_memory[PC+1]};
                rA = reg_AB[0:3]; //rA = {instruction_memory[PC+1]}[0:3];
                rB = reg_AB[4:7]; //rB = {instruction_memory[PC+1]}[4:7];
                 valP = PC + 64'd2;
            end
            endcase
            // PC = valP;
        end
        else
        begin
            invalid_instr = 1;
        end

    end
    assign updated_PC = valP;
endmodule