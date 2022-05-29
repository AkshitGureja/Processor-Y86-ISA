module test_pc_update_seq();

reg cnd;
reg [3:0] icode;
reg [63:0] valC, valM, valP;
wire [63:0] PC_new;

pc_update PC1(icode, cnd, valC, valM, valP, PC_new);

initial
    begin   
        $dumpfile("test_pc_update.vcd");
        $dumpvars(0, test_pc_update_seq);

        valP = 1;
        valC = 2;
        valM = 80;  
        cnd = 0;
        icode = 4'b001; // nop 
        $monitor("time=%0d  icode=%0h  cnd=%0d  valP=%0d  valC=%0d  valM=%0d  new_PC=%0d",$time, icode, cnd, valP, valC, valM, PC_new);
        #5;

        // PC is right now 1 (PC= 1) because of the nop instruction

        // OPq (On fetching at address 1, we got an Opq instruction and valP was incremented by 2)
        icode = 4'b0110;
        valP = 3; // PC = PC+2;
        #5;

        // cmovXX (Fetching at address 3, we have a cmovxx instruction and valP was hence incremented by 2)
        icode = 4'b0010;
        valP = 5; // PC = PC+2;
        #5;

        // irmovq (We fetched 10 bytes starting from address 5, which was decoded to be irmovq and PC = PC + 10)
        icode = 4'b0011;
        valP = 15; #5; // PC = PC + 10;

        // rmmovq (We fetch 10 bytes, we get rmmvoq instr, so PC = PC + 10)
        icode = 4'b0100;
        valP = 25; #5; // PC = PC + 10;

        // mrmovq (We fetch 10 bytes at addr 35, we get mrmovq, so PC = PC + 10)
        icode = 4'b0101;
        valP = 35; #5; // PC = PC + 10;

        // Opq (We have an arithmetic operation instruction at address 37, so PC = PC + 2)
        icode = 4'b0110;
        valP = 37; #5; // PC = PC + 2;

        // jXX 

        // Based on the operation above, CC were set and cnd = 0, condition is not satisfied so, we don't take the jump and we follow valP
        cnd = 0; icode = 4'b0111;
        valC = 100;
        valP = 46; #5; // PC = PC + 9 (jump is not taken)

        // Opq (We again fetch an aritmetic operation at addr 46, PC = PC + 2)
        icode = 4'b0110;
        valP = 48; #5; // PC = PC + 2;

        // jXX
        // The condition is satisfied this time based on the CC codes set after previous instruction, so we take the jump and PC = valC
        icode = 4'b0111;
        cnd = 1;
        valC = 150;
        valP = 57; #5; // PC = 150 (jump will be executed)

        // call 
        // At the new location we get a call instruction so, we move to a new address given by valC;
        icode = 4'b1000;
        valP = 159; // PC = PC + 9;
        valC = 100; #5;

        // ret 
        // We now fetch at address 100 and get a return instruction, so PC = PC + 1. But we move to the previous address of 159
        valM = 159; icode = 4'b1001;
        valP = 101; // PC = PC + 1;
        #5;

        // pushq
        // The next instruction is pushq, so PC is simply PC = PC + 2
        icode = 4'b1010;
        valP = 161; // PC = PC + 2
        #5;

        // popq
        // The next instruction is popq, so PC is simply PC = PC + 2
        icode = 4'b1011;
        valP = 163; // PC = PC + 2
        #5;

        // halt
        // Now at address given by current PC, we encounter a halt instruction and PC = PC + 1 and the program terminates
        icode = 4'b0000;
        valP = 164; // PC = Pc + 1;
        #5;

    end
endmodule