/**********************************************************************
File Name: FF_Without_ClkEn.sv

Description: Implements a D-F/F with an active low asynchronous reset
             and without a clock enable.

Author: github.com/micky-bank

Creation Date: Saturday 22 August 2020 08:56:48 PM

Last Modified: Saturday 22 August 2020 09:02:20 PM
**********************************************************************/

module FF_Without_ClkEn #(
    parameter         DATA_WIDTH   = 8,
    parameter         PIPE_LEN     = 1
)
(
    input                               I_Clk,
    input                               I_nReset,
    input         [DATA_WIDTH-1 : 0]    I_D,
    output logic  [DATA_WIDTH-1 : 0]    O_Q
);

logic          [DATA_WIDTH-1 : 0]       Reg_Q       [PIPE_LEN-1 : 0];

always_ff @(posedge I_Clk or negedge I_nReset) begin
    if (~I_nReset) begin
        Reg_Q     <= '{default : 0};
    end else begin
        for (int i = 0; i < PIPE_LEN; i++) begin
            if (i == 0)    Reg_Q [i] <= I_D;
            else           Reg_Q [i] <= Reg_Q [i-1];
        end
    end
end

assign O_Q = Reg_Q [PIPE_LEN-1];

endmodule : FF_Without_ClkEn

