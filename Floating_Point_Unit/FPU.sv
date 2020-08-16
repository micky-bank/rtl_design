/**********************************************************************
File Name: FPU.sv

Description:

Creation Date: 16-Aug-20 11:24:42 AM

Last Modified: 16-Aug-20 5:57:55 PM

Author: github.com/micky-bank
**********************************************************************/

module FPU #(
    parameter               PRECISION       = 32,
    localparam              DATA_WIDTH      = 32
)
(
    input                                       I_Clk,
    input                                       I_nReset,

    input                                       I_Opearnd1_Sign,
    input       [DATA_WIDTH-1 : 0]              I_Operand1_Int,
    input       [DATA_WIDTH-1 : 0]              I_Operand1_Fract,

    input                                       I_Opearnd2_Sign,
    input       [DATA_WIDTH-1 : 0]              I_Operand2_Int,
    input       [DATA_WIDTH-1 : 0]              I_Operand2_Fract,
    input       [ 2 : 0]                        I_Operation,

    output      [PRECISION-1 : 0]               O_Op1_Norm,
    output                                      O_Op1_Is_Zero,
    output      [PRECISION-1 : 0]               O_Op2_Norm,
    output                                      O_Op2_Is_Zero
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
    .I_Clk                              ,
    .I_nReset                           ,

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
    .I_Clk                              ,
    .I_nReset                           ,

    .I_Operand_Sign                     (I_Operand2_Sign),
    .I_Operand_Int                      (I_Operand2_Int),
    .I_Operand_Fract                    (I_Operand2_Fract),

    .O_Op                               (PO_Op2_Norm),
    .O_Op_Is_Zero                       (PO_Op2_Is_Zero)
);

assign O_Op1_Norm       = PO_Op1_Norm;
assign O_Op1_Is_Zero    = PO_Op1_Is_Zero;
assign O_Op2_Norm       = PO_Op2_Norm;
assign O_Op2_Is_Zero    = PO_Op2_Is_Zero;

endmodule : FPU
