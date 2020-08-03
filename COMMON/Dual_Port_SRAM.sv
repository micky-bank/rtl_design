/**********************************************************************
Filename: Dual_Port_SRAM.sv

Description: Implements a simple dual port RAM, meaning a RAM with
             different read and write ports.

Author: github.com/micky-bank

Date Modified: 3rd Aug, 2020

**********************************************************************/

module Dual_Port_SRAM #(
    parameter   DATA_WIDTH = 32,
    parameter   RAM_DEPTH  = 64,
    localparam  ADDR_WIDTH = $clog2 (RAM_DEPTH)
)
(
    input                                  I_Clk,

    input                                  I_WrEn,
    input           [ADDR_WIDTH-1 : 0]     I_WrAddr,
    input           [DATA_WIDTH-1 : 0]     I_WrData,

    input                                  I_RdEn,
    input           [ADDR_WIDTH-1 : 0]     I_RdAddr,
    output   logic  [DATA_WIDTH-1 : 0]     O_RdData
);

logic        [DATA_WIDTH-1 : 0]     RAM_Data_q    [ADDR_WIDTH-1 : 0];

always_ff @(posedge I_Clk) begin
    if (I_WrEn)      RAM_Data_q [I_WrAddr] <= I_WrData;
end

always_ff @(posedge I_Clk) begin
    if (I_RdEn)      O_RdData   <= RAM_Data_q [I_RdAddr];
end

endmodule : Dual_Port_SRAM
