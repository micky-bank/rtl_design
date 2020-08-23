/**********************************************************************
File Name: Pre_Normalize.sv

Description: Makes exponents of both operands equal before addition/sub
             can be performed.

Author: github.com/micky-bank

Creation Date: Saturday 22 August 2020 08:20:49 PM

Last Modified: Sunday 23 August 2020 06:27:33 PM
**********************************************************************/

module Pre_Normalize #(
    parameter       PRECISION    = 32,
    localparam      EXPONENT_WIDTH = PRECISION == 32 ?  8 : PRECISION == 64 ? 11 :  8,
    localparam      MANTISSA_WIDTH = PRECISION == 32 ? 23 : PRECISION == 64 ? 52 : 23
)
(
    input                                   I_Clk,
    input                                   I_nReset,
    input                                   I_Valid,
    input                                   I_Sign_Op1,
    input           [EXPONENT_WIDTH-1 : 0]  I_Exp_Op1,
    input           [MANTISSA_WIDTH   : 0]  I_Mantissa_Op1,
    input                                   I_Sign_Op2,
    input           [EXPONENT_WIDTH-1 : 0]  I_Exp_Op2,
    input           [MANTISSA_WIDTH   : 0]  I_Mantissa_Op2,

    output logic                            O_PreNorm_Valid,
    output logic    [EXPONENT_WIDTH-1 : 0]  O_PreNorm_Exp,
    output logic                            O_PreNorm_Sign_Op1,
    output logic    [MANTISSA_WIDTH   : 0]  O_PreNorm_Mantissa_Op1,
    output logic                            O_PreNorm_Sign_Op2,
    output logic    [MANTISSA_WIDTH   : 0]  O_PreNorm_Mantissa_Op2
);

logic   [EXPONENT_WIDTH-1 : 0]      Mf_Exp;
logic   [MANTISSA_WIDTH   : 0]      Mf_Mant_Op1;
logic   [MANTISSA_WIDTH   : 0]      Mf_Mant_Op2;

wire                                W_Exp_Op1_Eq_Op2  = I_Exp_Op1 == I_Exp_Op2;
wire                                W_Exp_Op1_Gt_Op2  = I_Exp_Op1  > I_Exp_Op2;
wire                                W_Exp_Op1_Lt_Op2  = (~W_Exp_Op1_Gt_Op2) & (~W_Exp_Op1_Eq_Op2);

always_comb begin
                                Mf_Exp      = I_Exp_Op1;
                                Mf_Mant_Op1 = I_Mantissa_Op1;
                                Mf_Mant_Op2 = I_Mantissa_Op2;

    case (1'b1)
//        Exp_Op1_Eq_Op2 : begin
//        end

        W_Exp_Op1_Gt_Op2 : begin
                                Mf_Exp      = I_Exp_Op1;
                                Mf_Mant_Op2 = I_Mantissa_Op2 >> (I_Exp_Op1 - I_Exp_Op2);
        end

        W_Exp_Op1_Lt_Op2 : begin
                                Mf_Exp      = Exp_Op2;
                                Mf_Mant_Op1 = I_Mantissa_Op1 >> (I_Exp_Op2 - I_Exp_Op1);
        end

//        default        : begin
//                                Mf_Mant_Op1 = I_Mantissa_Op1;
//                                Mf_Mant_Op2 = I_Mantissa_Op2;
//        end
    endcase
end

FF_ClkEn #(.DATA_WIDTH (1), .PIPE_LEN (1)) u_Delay_Sign1_Norm (.I_Clk, .I_nReset, .I_D (I_Sign_Op1), .I_En (I_Valid), .O_Q (O_PreNorm_Sign_Op1) );
FF_ClkEn #(.DATA_WIDTH (1), .PIPE_LEN (1)) u_Delay_Sign2_Norm (.I_Clk, .I_nReset, .I_D (I_Sign_Op2), .I_En (I_Valid), .O_Q (O_PreNorm_Sign_Op2) );
FF_ClkEn #(.DATA_WIDTH (EXPONENT_WIDTH), .PIPE_LEN (1)) u_Delay_Exp_Norm (.I_Clk, .I_nReset, .I_D (Mf_Exp), .I_En (I_Valid), .O_Q (O_PreNorm_Exp) );
FF_ClkEn #(.DATA_WIDTH (MANTISSA_WIDTH), .PIPE_LEN (1)) u_Delay_Mant1_Norm (.I_Clk, .I_nReset, .I_D (Mf_Mant_Op1), .I_En (I_Valid), .O_Q (O_PreNorm_Mantissa_Op1) );
FF_ClkEn #(.DATA_WIDTH (MANTISSA_WIDTH), .PIPE_LEN (1)) u_Delay_Mant2_Norm (.I_Clk, .I_nReset, .I_D (Mf_Mant_Op2), .I_En (I_Valid), .O_Q (O_PreNorm_Mantissa_Op2) );

FF_Without_ClkEn #(.DATA_WIDTH (1), .PIPE_LEN (1)) u_Delay_Valid (.I_Clk, .I_nReset, .I_D (I_Valid), .O_Q (O_PreNorm_Valid) );

endmodule : Pre_Normalize
