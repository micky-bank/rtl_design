/**********************************************************************
File Name: FF_ClkEn_Without_Rst.sv

Description: Implements a D-F/F with a clock enable and no reset.
             It is recommended to be used only in shift-register chain
             and data-path flops. Avoid using it in control path
             signals.

Author: github.com/micky-bank

Creation Date: Saturday 22 August 2020 08:27:46 PM

Last Modified:
**********************************************************************/

module FF_ClkEn_Without_Rst #(
    parameter         DATA_WIDTH   = 8,
    parameter         PIPE_LEN     = 1
)
(
    input                               I_Clk,
    input         [DATA_WIDTH-1 : 0]    I_D,
    input                               I_En,
    output logic  [DATA_WIDTH-1 : 0]    O_Q
);

logic          [DATA_WIDTH-1 : 0]       Reg_Q       [PIPE_LEN-1 : 0];

always_ff @(posedge I_Clk) begin
    for (int i = 0; i < PIPE_LEN; i++) begin
        if (I_En) begin
            if (i == 0)    Reg_Q [i] <= I_D;
            else           Reg_Q [i] <= Reg_Q [i-1];
        end
    end
end

assign O_Q = Reg_Q [PIPE_LEN-1];

endmodule : FF_ClkEn_Without_Rst
