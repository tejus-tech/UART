`include "uart_tx.v"
`include "uart_rx.v"
module uart_top #(
  parameter CLK_FREQ = 1000000,
  parameter BAUD_RATE = 9600
)(
  input clk,
  input rst,
  input tx_start,
  input [7:0] tx_data,
  output tx,
  output tx_busy,
  output [7:0] rx_data,
  output rx_ready
);

  wire internal_tx;

  // Transmitter Instance
  uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) tx_inst (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(internal_tx),
    .tx_busy(tx_busy)
  );

  // Receiver Instance
  uart_rx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) rx_inst (
    .clk(clk),
    .rst(rst),
    .rx(internal_tx),      
    .rx_data(rx_data),
    .rx_ready(rx_ready)
  );

  // Output tx for observation
  assign tx = internal_tx;

endmodule
