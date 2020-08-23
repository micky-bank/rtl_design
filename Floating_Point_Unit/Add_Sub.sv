/**********************************************************************
File Name: Add_Sub.sv

Description:

Author: github.com/micky-bank

Creation Date: Sunday 23 August 2020 05:47:09 PM

Last Modified: Sunday 23 August 2020 06:27:30 PM
**********************************************************************/

module Add_Sub #(
    parameter       PRECISION    = 32,
    localparam      EXPONENT_WIDTH = PRECISION == 32 ?  8 : PRECISION == 64 ? 11 :  8,
    localparam      MANTISSA_WIDTH = PRECISION == 32 ? 23 : PRECISION == 64 ? 52 : 23
)
(
    input                                       I_Clk,
    input                                       I_nReset,
    input                                       I_PreNorm_Valid,
    input           [EXPONENT_WIDTH-1 : 0]      I_PreNorm_Exp,
    input                                       I_PreNorm_Sign_Op1,
    input           [MANTISSA_WIDTH   : 0]      I_PreNorm_Mantissa_Op1,
    input                                       I_PreNorm_Sign_Op2,
    input           [MANTISSA_WIDTH   : 0]      I_PreNorm_Mantissa_Op2

    output logic                                O_Add_Valid,
    output logic                                O_Add_Sign,
    output logic    [EXPONENT_WIDTH-1 : 0]      O_Add_Exp,
    output logic    [MANTISSA_WIDTH+1 : 0]      O_Add_Mant
);

wire   signed   [MANTISSA_WIDTH+1 : 0]      W_Op1_Mantissa = {I_PreNorm_Sign_Op1, I_PreNorm_Mantissa_Op1};
wire   signed   [MANTISSA_WIDTH+1 : 0]      W_Op2_Mantissa = {I_PreNorm_Sign_Op2, I_PreNorm_Mantissa_Op2};

wire   signed   [MANTISSA_WIDTH+2 : 0]      W_Add_Mant_C   = W_Op1_Mantissa + W_Op2_Mantissa;

FF_Without_ClkEn #(.DATA_WIDTH (1), .PIPE_LEN (1)) u_Delay_Valid (.I_Clk, .I_nReset, .I_D (I_PreNorm_Valid), .O_Q (O_Add_Valid) );

FF_ClkEn #(.DATA_WIDTH (1), .PIPE_LEN (1)) u_Delay_Sign (.I_Clk, .I_nReset, .I_D (W_Add_Mant_C [MANTISSA_WIDTH+2]), .I_En (I_PreNorm_Valid), .O_Q (O_Add_Sign) );
FF_ClkEn #(.DATA_WIDTH (MANTISSA_WIDTH+2), .PIPE_LEN (1)) u_Delay_Mant (.I_Clk, .I_nReset, .I_D (W_Add_Mant_C [MANTISSA_WIDTH+1 : 0]), .I_En (I_PreNorm_Valid), .O_Q (O_Add_Mant) );

FF_ClkEn #(.DATA_WIDTH (EXPONENT_WIDTH), .PIPE_LEN (1)) u_Delay_Exp (.I_Clk, .I_nReset, .I_D (I_PreNorm_Exp), .I_En (I_PreNorm_Valid), .O_Q (O_Add_Exp) );

endmodule : Add_Sub
