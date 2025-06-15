module uart_tx #(
  parameter CLK_FREQ = 1000000,
  parameter BAUD_RATE = 9600
)(
  input clk,
  input rst,
  input tx_start,
  input [7:0] tx_data,
  output reg tx,
  output reg tx_busy
);

  localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;

  localparam IDLE  = 2'b00;
  localparam START = 2'b01;
  localparam DATA  = 2'b10;
  localparam STOP  = 2'b11;

  reg [15:0] clk_cnt;
  reg [3:0] bit_cnt;
  reg [9:0] tx_shift;
  reg [1:0] state;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      tx <= 1'b1;
      tx_busy <= 1'b0;
      clk_cnt <= 0;
      bit_cnt <= 0;
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          tx <= 1'b1;
          clk_cnt <= 0;
          bit_cnt <= 0;
          tx_busy <= 1'b0;
          if (tx_start) begin
            tx_shift <= {1'b1, tx_data, 1'b0};  
            tx_busy <= 1'b1;
            state <= START;
          end
        end

        START: begin
          tx <= 1'b0; 
          if (clk_cnt < BAUD_DIV - 1)
            clk_cnt <= clk_cnt + 1;
          else begin
            clk_cnt <= 0;
            state <= DATA;
          end
        end

        DATA: begin
          tx <= data_buf[bit_cnt];
          if (clk_cnt < BAUD_DIV - 1)
            clk_cnt <= clk_cnt + 1;
          else begin
            clk_cnt <= 0;
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 7)
              state <= STOP;
          end
        end

        STOP: begin
          tx <= 1'b1;
          if (clk_cnt < BAUD_DIV - 1)
            clk_cnt <= clk_cnt + 1;
          else begin
            clk_cnt <= 0;
            state <= IDLE;
            tx_busy <= 1'b0;
          end
        end
      endcase
    end
  end
endmodule
