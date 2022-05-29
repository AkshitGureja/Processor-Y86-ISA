module control_logic_pipe(D_icode, d_rA, d_rB, E_icode, E_dstM, e_cnd, M_icode,
F_bubble, F_stall, D_bubble, D_stall, E_bubble, E_stall);

input e_cnd;
input [3:0] D_icode, d_rA, d_rB, E_icode, E_dstM, M_icode;

output F_bubble, F_stall, D_bubble, D_stall, E_bubble, E_stall;
// F_bubble = 0;
// F_stall = 0;
// D_bubble = 0;
// D_stall = 0;
// E_bubble = 0;
// E_stall = 0;


//F_stall
always @(*)
    begin
        if( (E_icode==5 || E_icode==11) && (E_dstM==d_rA || E_dstM==d_rB)
            || (D_icode==9 || E_icode==9 || M_icode==9) )
        begin
            F_stall = 1;
        end
        else
        begin
            F_stall = 0;
        end
    end

//F_bubble
always @(*)
begin
    F_bubble = 0;
end

//D_stall
always @(*)
    begin
        if( (E_icode==5 || E_icode==11) && (E_dstM==d_rA || E_dstM==d_rB) )
        begin
            D_stall = 1;
        end
        else
        begin
            D_stall = 0;
        end

//D_bubble
always @(*)
    begin
        if( (E_icode==7 && !e_cnd) || (D_icode==9 || E_icode==9 || M_icode==9) )
        begin
            D_bubble = 1;
        end
        else
        begin
            D_bubble = 0;
        end

//E_stall
always @(*)
    begin
        E_stall = 0;
    end

//E_bubble
always @(*)
    begin
        if( (E_icode==7 && !e_cnd) || (E_icode==5 || E_icode==11) && (E_dstM==d_rA || E_dstM==d_rB) )
        begin
            E_bubble = 1;
        end
        else
        begin
            E_bubble = 0;
        end


endmodule






//F bubble : 0
//F stall  : E_icode, E_dstM, d_rA, d_rB, D_icode, M_icode
//D bubble : E_icode, E_dstM, d_rA, d_rB, D_icode, M_icode, e_cnd
//D stall  : E_icode, E_dstM, d_rA, d_rB
//E bubble : E_icode, E_dstM, d_rA, d_rB, e_cnd
//E stall  : 0
//M bubble : m_stat, W_stat
//M stall  : 0
//W bubble : 0
//W stall  : W_stat