/**********************************************************************
File Name: Normalize_To_IEEE754.sv

Description:

Author: github.com/micky-bank

Creation Date: Saturday 15 August 2020 05:27:41 PM

Last Modified:
**********************************************************************/

module Normalize_To_IEEE754 #(
    parameter               PRECISION          = 32,
    parameter               DATA_WIDTH         = 32
)
(
    input                                           I_Clk,
    input                                           I_nReset,

    input                                           I_Operand_Sign,
    input               [DATA_WIDTH-1 : 0]          I_Operand_Int,
    input               [DATA_WIDTH-1 : 0]          I_Operand_Fract,

    output   logic      [PRECISION-1 : 0]           O_Operand
);

logic           [DATA_WIDTH-1 : 0]                  Int_1st_1_From_MSB_C;
logic           [DATA_WIDTH-1 : 0]                  Fract_1st_1_From_LSB_C;
logic                                               Operand_Is_Zero_Q;
logic           [ 7 : 0]                            Exponent_Q;
logic           [22 : 0]                            Mantissa_Q;

always_comb begin
    for (int i = 0; i<DATA_WIDTH; i++) begin
        if (i == DATA_WIDTH-1) begin
            Int_1st_1_From_MSB_C [i] = (I_Operand_Int [i] == 1'b1) ? 1'b1 : 1'b0;
        end else begin
            Int_1st_1_From_MSB_C [i] = (I_Operand_Int [i] == 1'b1 && (| I_Operand_Int [DATA_WIDTH-1 : i+1] == 1'b0)) ? 1'b1 : 1'b0;
        end
    end

    for (int j = 0; j<DATA_WIDTH; j++) begin
        if (j == DATA_WIDTH-1) begin
            Fract_1st_1_From_LSB_C [j] = (I_Operand_Fract [j] == 1'b1) ? 1'b1 : 1'b0;
        end else begin
            Fract_1st_1_From_LSB_C [j] = (I_Operand_Fract [j] == 1'b1 && (| I_Operand_Fract [DATA_WIDTH-1 : j+1] == 1'b0)) ? 1'b1 : 1'b0;
        end
    end
end

always_comb begin
    Operand_Is_Zero_Q = 1'b0;

    case (1'b1) begin
        Int_1st_1_From_MSB_C [ 0] : begin
                                            Exponent_Q          = 8'd0 + 8'd127;
                                            Mantissa_Q          = I_Operand_Fract [22 : 0];
                                  end

        Int_1st_1_From_MSB_C [ 1] : begin
                                            Exponent_Q          = 8'd1 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [0], I_Operand_Fract [21 : 0]};
                                  end

        Int_1st_1_From_MSB_C [ 2] : begin
                                            Exponent_Q          = 8'd2 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [1 : 0], I_Operand_Fract [20 : 0]};
                                  end

        Int_1st_1_From_MSB_C [ 3] : begin
                                            Exponent_Q          = 8'd3 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [2 : 0], I_Operand_Fract [19 : 0]};
                                  end

        Int_1st_1_From_MSB_C [ 4] : begin
                                            Exponent_Q          = 8'd4 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [3 : 0], I_Operand_Fract [18 : 0]};
                                  end

        Int_1st_1_From_MSB_C [ 5] : begin
                                            Exponent_Q          = 8'd5 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [4 : 0], I_Operand_Fract [17 : 0]};
                                  end

        Int_1st_1_From_MSB_C [ 6] : begin
                                            Exponent_Q          = 8'd6 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [5 : 0], I_Operand_Fract [16 : 0]};
                                  end

        Int_1st_1_From_MSB_C [ 7] : begin
                                            Exponent_Q          = 8'd7 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [6 : 0], I_Operand_Fract [15 : 0];
                                  end

        Int_1st_1_From_MSB_C [ 8] : begin
                                            Exponent_Q          = 8'd8 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [7 : 0], I_Operand_Fract [14 : 0];
                                  end

        Int_1st_1_From_MSB_C [ 9] : begin
                                            Exponent_Q          = 8'd9 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [8 : 0], I_Operand_Fract [13 : 0];
                                  end

        Int_1st_1_From_MSB_C [10] : begin
                                            Exponent_Q          = 8'd10 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [9 : 0], I_Operand_Fract [12 : 0];
                                  end

        Int_1st_1_From_MSB_C [11] : begin
                                            Exponent_Q          = 8'd11 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [10 : 0], I_Operand_Fract [11 : 0];
                                  end

        Int_1st_1_From_MSB_C [12] : begin
                                            Exponent_Q          = 8'd12 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [11 : 0], I_Operand_Fract [10 : 0];
                                  end

        Int_1st_1_From_MSB_C [13] : begin
                                            Exponent_Q          = 8'd13 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [12 : 0], I_Operand_Fract [ 9 : 0];
                                  end

        Int_1st_1_From_MSB_C [14] : begin
                                            Exponent_Q          = 8'd14 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [13 : 0], I_Operand_Fract [ 8 : 0];
                                  end

        Int_1st_1_From_MSB_C [15] : begin
                                            Exponent_Q          = 8'd15 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [14 : 0], I_Operand_Fract [ 7 : 0];
                                  end

        Int_1st_1_From_MSB_C [16] : begin
                                            Exponent_Q          = 8'd16 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [15 : 0], I_Operand_Fract [ 6 : 0];
                                  end

        Int_1st_1_From_MSB_C [17] : begin
                                            Exponent_Q          = 8'd17 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [16 : 0], I_Operand_Fract [ 5 : 0];
                                  end

        Int_1st_1_From_MSB_C [18] : begin
                                            Exponent_Q          = 8'd18 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [17 : 0], I_Operand_Fract [ 4 : 0];
                                  end

        Int_1st_1_From_MSB_C [19] : begin
                                            Exponent_Q          = 8'd19 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [18 : 0], I_Operand_Fract [ 3 : 0];
                                  end

        Int_1st_1_From_MSB_C [20] : begin
                                            Exponent_Q          = 8'd20 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [19 : 0], I_Operand_Fract [ 2 : 0];
                                  end

        Int_1st_1_From_MSB_C [21] : begin
                                            Exponent_Q          = 8'd21 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [20 : 0], I_Operand_Fract [ 1 : 0];
                                  end

        Int_1st_1_From_MSB_C [22] : begin
                                            Exponent_Q          = 8'd22 + 8'd127;
                                            Mantissa_Q          = {I_Operand_Int [21 : 0], I_Operand_Fract [ 0 : 0];
                                  end

        Int_1st_1_From_MSB_C [23] : begin
                                            Exponent_Q          = 8'd23 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        Int_1st_1_From_MSB_C [24] : begin
                                            Exponent_Q          = 8'd24 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        Int_1st_1_From_MSB_C [25] : begin
                                            Exponent_Q          = 8'd25 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        Int_1st_1_From_MSB_C [26] : begin
                                            Exponent_Q          = 8'd26 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        Int_1st_1_From_MSB_C [27] : begin
                                            Exponent_Q          = 8'd27 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        Int_1st_1_From_MSB_C [28] : begin
                                            Exponent_Q          = 8'd28 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        Int_1st_1_From_MSB_C [29] : begin
                                            Exponent_Q          = 8'd29 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        Int_1st_1_From_MSB_C [30] : begin
                                            Exponent_Q          = 8'd30 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end


        Int_1st_1_From_MSB_C [31] : begin
                                            Exponent_Q          = 8'd31 + 8'd127;
                                            Mantissa_Q          = I_Operand_Int [22 : 0];
                                    end

        default                 : begin
                                        case (1'b1) begin
                                            Fract_1st_1_From_LSB_C [ 0] : begin
                                                                                    Exponent_Q          = -8'd1 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 1 : 23];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 1] : begin
                                                                                    Exponent_Q          = -8'd2 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 2 : 24];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 2] : begin
                                                                                    Exponent_Q          = -8'd3 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 3 : 25];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 3] : begin
                                                                                    Exponent_Q          = -8'd4 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 4 : 26];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 4] : begin
                                                                                    Exponent_Q          = -8'd5 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 5 : 27];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 5] : begin
                                                                                    Exponent_Q          = -8'd6 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 6 : 28];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 6] : begin
                                                                                    Exponent_Q          = -8'd7 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 7 : 29];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 7] : begin
                                                                                    Exponent_Q          = -8'd8 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 8 : 30];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 8] : begin
                                                                                    Exponent_Q          = -8'd9 + 8'd127;
                                                                                    Mantissa_Q          = I_Operand_Fract [ 9 : 31];
                                                                          end

                                            Fract_1st_1_From_LSB_C [ 9] : begin
                                                                                    Exponent_Q          = -8'd10 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [10 : 31], 1'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [10] : begin
                                                                                    Exponent_Q          = -8'd11 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [11 : 31], 2'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [11] : begin
                                                                                    Exponent_Q          = -8'd12 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [12 : 31], 3'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [12] : begin
                                                                                    Exponent_Q          = -8'd13 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [13 : 31], 4'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [13] : begin
                                                                                    Exponent_Q          = -8'd14 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [14 : 31], 5'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [14] : begin
                                                                                    Exponent_Q          = -8'd15 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [15 : 31], 6'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [15] : begin
                                                                                    Exponent_Q          = -8'd16 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [16 : 31], 7'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [16] : begin
                                                                                    Exponent_Q          = -8'd17 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [17 : 31], 8'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [17] : begin
                                                                                    Exponent_Q          = -8'd18 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [18 : 31], 9'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [18] : begin
                                                                                    Exponent_Q          = -8'd19 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [19 : 31], 10'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [19] : begin
                                                                                    Exponent_Q          = -8'd20 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [20 : 31], 11'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [20] : begin
                                                                                    Exponent_Q          = -8'd21 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [21 : 31], 12'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [21] : begin
                                                                                    Exponent_Q          = -8'd22 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [22 : 31], 13'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [22] : begin
                                                                                    Exponent_Q          = -8'd23 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [23 : 31], 14'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [23] : begin
                                                                                    Exponent_Q          = -8'd24 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [24 : 31], 15'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [24] : begin
                                                                                    Exponent_Q          = -8'd25 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [25 : 31], 16'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [25] : begin
                                                                                    Exponent_Q          = -8'd26 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [26 : 31], 17'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [26] : begin
                                                                                    Exponent_Q          = -8'd27 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [27 : 31], 18'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [27] : begin
                                                                                    Exponent_Q          = -8'd28 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [28 : 31], 19'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [28] : begin
                                                                                    Exponent_Q          = -8'd29 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [29 : 31], 20'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [29] : begin
                                                                                    Exponent_Q          = -8'd30 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [30 : 31], 21'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [30] : begin
                                                                                    Exponent_Q          = -8'd31 + 8'd127;
                                                                                    Mantissa_Q          = {I_Operand_Fract [31 : 31], 22'b0};
                                                                          end

                                            Fract_1st_1_From_LSB_C [31] : begin
                                                                                    Exponent_Q          = -8'd32 + 8'd127;
                                                                                    Mantissa_Q          = 23'b0;
                                                                          end

                                            default                     : begin
                                                                                    Operand_Is_Zero_Q   = 1'b1;
                                                                                    Exponent_Q          = 8'b0
                                                                                    Mantissa_Q          = 23'b0;
                                                                          end
                                        endcase
                                  end

    endcase
end

assign O_Operand = {I_Operand_Sign, Exponent_Q, Mantissa_Q};

endmodule : Normalize_To_IEEE754
