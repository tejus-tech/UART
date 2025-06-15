module uart_rx #(
  parameter CLK_FREQ = 1000000,
  parameter BAUD_RATE = 9600
)(
  input clk,
  input rst,
  input rx,
  output reg [7:0] rx_data,
  output reg rx_ready
);

  localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;
  localparam HALF_BAUD = BAUD_DIV / 2;

  localparam IDLE  = 2'b00;
  localparam START = 2'b01;
  localparam DATA  = 2'b10;
  localparam STOP  = 2'b11;

  reg [15:0] clk_cnt;
  reg [3:0] bit_cnt;
  reg [7:0] rx_shift;
  reg [1:0] state;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      clk_cnt <= 0;
      bit_cnt <= 0;
      rx_data <= 0;
      rx_ready <= 0;
      rx_shift <= 0;
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          rx_ready <= 0;
          if (!rx) begin  
            clk_cnt <= 0;
            state <= START;
          end
        end

        START: begin
          if (clk_cnt == HALF_BAUD) begin
            clk_cnt <= 0;
            bit_cnt <= 0;
            state <= DATA;
          end else begin
            clk_cnt <= clk_cnt + 1;
          end
        end

        DATA: begin
          if (clk_cnt < BAUD_DIV - 1) begin
            clk_cnt <= clk_cnt + 1;
          end else begin
            clk_cnt <= 0;
            rx_shift[bit_cnt] <= rx;
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 7) state <= STOP;
          end
        end

        STOP: begin
          if (clk_cnt < BAUD_DIV - 1) begin
            clk_cnt <= clk_cnt + 1;
          end else begin
            clk_cnt <= 0;
            rx_data <= rx_shift;
            rx_ready <= 1;
            state <= IDLE;
          end
        end
      endcase
    end
  end
endmodule
