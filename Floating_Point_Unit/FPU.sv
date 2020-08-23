/**********************************************************************
File Name: FPU.sv

Description:

Creation Date: 16-Aug-20 11:24:42 AM

Last Modified: Sunday 23 August 2020 06:27:39 PM

Author: github.com/micky-bank
**********************************************************************/

module FPU #(
    parameter               PRECISION       = 32,
    localparam              DATA_WIDTH      = 32
)
(
    input                                           I_Clk,
    input                                           I_nReset,

    input                                           I_Opearnd1_Sign,
    input           [DATA_WIDTH-1 : 0]              I_Operand1_Int,
    input           [DATA_WIDTH-1 : 0]              I_Operand1_Fract,

    input                                           I_Opearnd2_Sign,
    input           [DATA_WIDTH-1 : 0]              I_Operand2_Int,
    input           [DATA_WIDTH-1 : 0]              I_Operand2_Fract,
    input           [ 2 : 0]                        I_Operation,
    input                                           I_Operation_Valid,

    output logic                                    O_Valid,
    output logic    [PRECISION-1 : 0]               O_Op1_Norm,
    output logic                                    O_Op1_Is_Zero,
    output logic    [PRECISION-1 : 0]               O_Op2_Norm,
    output logic                                    O_Op2_Is_Zero
);

logic           [PRECISION-1 : 0]           PO_Op1_Norm;
logic                                       PO_Op1_Is_Zero;
logic           [PRECISION-1 : 0]           PO_Op2_Norm;
logic                                       PO_Op2_Is_Zero;

Normalize_To_IEEE754 #(
    .PRECISION                          (PRECISION),
    .DATA_WIDTH                         (DATA_WIDTH)
)
U_Normalize_Op1 (
//    .I_Clk                              ,
//    .I_nReset                           ,

    .I_Operand_Sign                     (I_Operand1_Sign),
    .I_Operand_Int                      (I_Operand1_Int),
    .I_Operand_Fract                    (I_Operand1_Fract),

    .O_Op                               (PO_Op1_Norm),
    .O_Op_Is_Zero                       (PO_Op1_Is_Zero)
);

Normalize_To_IEEE754 #(
    .PRECISION                          (PRECISION),
    .DATA_WIDTH                         (DATA_WIDTH)
)
U_Normalize_Op2 (
//    .I_Clk                              ,
//    .I_nReset                           ,

    .I_Operand_Sign                     (I_Operand2_Sign),
    .I_Operand_Int                      (I_Operand2_Int),
    .I_Operand_Fract                    (I_Operand2_Fract),

    .O_Op                               (PO_Op2_Norm),
    .O_Op_Is_Zero                       (PO_Op2_Is_Zero)
);

logic           [PRECISION-1 : 0]           P_Op1_Norm_Q;
logic           [PRECISION-1 : 0]           P_Op2_Norm_Q;
logic                                       P_Op1_Is_Zero_Q;
logic                                       P_Op2_Is_Zero_Q;
logic                                       P_Valid_Q;

FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op1_Norm (.I_Clk, .I_nReset, .I_D (PO_Op1_Norm), .I_En (I_Operation_Valid), .O_Q (P_Op1_Norm_Q) );
FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op2_Norm (.I_Clk, .I_nReset, .I_D (PO_Op2_Norm), .I_En (I_Operation_Valid), .O_Q (P_Op2_Norm_Q) );

FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op1_Is_Zero (.I_Clk, .I_nReset, .I_D (PO_Op1_Is_Zero), .I_En (I_Operation_Valid), .O_Q (P_Op1_Is_Zero_Q) );
FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op2_Is_Zero (.I_Clk, .I_nReset, .I_D (PO_Op2_Is_Zero), .I_En (I_Operation_Valid), .O_Q (P_Op2_Is_Zero_Q) );

FF_Without_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (2)) u_Delay_Valid (.I_Clk, .I_nReset, .I_D (I_Operation_Valid), .O_Q (P_Valid_Q) );

localparam      EXPONENT_WIDTH = PRECISION == 32 ?  8 : PRECISION == 64 ? 11 :  8;
localparam      MANTISSA_WIDTH = PRECISION == 32 ? 23 : PRECISION == 64 ? 52 : 23;

wire                              W_Sign_Op1        = P_Op1_Norm_Q [PRECISION-1];
wire                              W_Sign_Op2        = P_Op2_Norm_Q [PRECISION-1];
wire    [EXPONENT_WIDTH-1 : 0]    W_Exp_Op1         = P_Op1_Norm_Q [PRECISION-2 : PRECISION-EXPONENT_WIDTH-1];
wire    [EXPONENT_WIDTH-1 : 0]    W_Exp_Op2         = P_Op2_Norm_Q [PRECISION-2 : PRECISION-EXPONENT_WIDTH-1];
wire    [MANTISSA_WIDTH   : 0]    W_Mantissa_Op1    = {1'b1, P_Op1_Norm_Q [MANTISSA_WIDTH-1 : 0]};
wire    [MANTISSA_WIDTH   : 0]    W_Mantissa_Op2    = {1'b1, P_Op2_Norm_Q [MANTISSA_WIDTH-1 : 0]};

logic                             P_PreNorm_Valid;
logic                             P_PreNorm_Sign_Op1;
logic                             P_PreNorm_Sign_Op2;
logic   [EXPONENT_WIDTH-1 : 0]    P_PreNorm_Exp;
logic   [MANTISSA_WIDTH   : 0]    P_PreNorm_Mantissa_Op1;
logic   [MANTISSA_WIDTH   : 0]    P_PreNorm_Mantissa_Op2;

Pre_Normalize #(
    .PRECISION                     (PRECISION)
)
U_Pre_Normalize (
    .I_Clk                         ,
    .I_nReset                      ,
    .I_Valid                       (P_Valid_Q),
    .I_Sign_Op1                    (W_Sign_Op1),
    .I_Exp_Op1                     (W_Exp_Op1               ),
    .I_Mantissa_Op1                (W_Mantissa_Op1          ),
    .I_Sign_Op2                    (W_Sign_Op2),
    .I_Exp_Op2                     (W_Exp_Op2               ),
    .I_Mantissa_Op2                (W_Mantissa_Op2          ),
    .O_PreNorm_Valid               (P_PreNorm_Valid         ),
    .O_PreNorm_Exp                 (P_PreNorm_Exp           ),
    .O_PreNorm_Sign_Op1            (P_PreNorm_Sign_Op1      ),
    .O_PreNorm_Mantissa_Op1        (P_PreNorm_Mantissa_Op1  ),
    .O_PreNorm_Sign_Op2            (P_PreNorm_Sign_Op2      ),
    .O_PreNorm_Mantissa_Op2        (P_PreNorm_Mantissa_Op2  )
);

logic                               P_Add_Valid;
logic                               P_Add_Sign;
logic    [EXPONENT_WIDTH-1 : 0]     P_Add_Exp;
logic    [MANTISSA_WIDTH+1 : 0]     P_Add_Mant;

Add_Sub #(
    .PRECISION                     (PRECISION)
)
U_Add_Sub (
    .I_Clk                         ,
    .I_nReset                      ,
    .I_PreNorm_Valid               (P_PreNorm_Valid         ),
    .I_PreNorm_Exp                 (P_PreNorm_Exp           ),
    .I_PreNorm_Sign_Op1            (P_PreNorm_Sign_Op1      ),
    .I_PreNorm_Mantissa_Op1        (P_PreNorm_Mantissa_Op1  ),
    .I_PreNorm_Sign_Op2            (P_PreNorm_Sign_Op2      ),
    .I_PreNorm_Mantissa_Op         (P_PreNorm_Mantissa_Op2  ),
    .O_Add_Valid                   (P_Add_Valid),
    .O_Add_Sign                    (P_Add_Sign),
    .O_Add_Exp                     (P_Add_Exp),
    .O_Add_Mant                    (P_Add_Mant)
);

// Latency matching will have to be done later when more blocks are added later.
// FFs without resets can be used for these signals.
FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op1_Norm (.I_Clk, .I_nReset, .I_D (PO_Op1_Norm), .I_En (I_Operation_Valid), .O_Q (O_Op1_Norm) );
FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op2_Norm (.I_Clk, .I_nReset, .I_D (PO_Op2_Norm), .I_En (I_Operation_Valid), .O_Q (O_Op2_Norm) );

FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op1_Is_Zero (.I_Clk, .I_nReset, .I_D (PO_Op1_Is_Zero), .I_En (I_Operation_Valid), .O_Q (O_Op1_Is_Zero) );
FF_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Op2_Is_Zero (.I_Clk, .I_nReset, .I_D (PO_Op2_Is_Zero), .I_En (I_Operation_Valid), .O_Q (O_Op2_Is_Zero) );

// Added initially just for testing. Can be removed later since it'll be better to use the valid coming from the pipelined blocks rather than pipelining here.
FF_Without_ClkEn #(.DATA_WIDTH (PRECISION), .PIPE_LEN (1)) u_Delay_Valid (.I_Clk, .I_nReset, .I_D (I_Operation_Valid), .O_Q (O_Valid) );

endmodule : FPU
