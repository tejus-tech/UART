
module uart_tb;

  // Parameters
  parameter CLK_FREQ = 1000000;
  parameter BAUD_RATE = 115200;
  parameter CLK_PERIOD = 1000_000_000 / CLK_FREQ; // in ns

  // Testbench signals
  reg clk = 0;
  reg rst = 1;
  reg tx_start = 0;
  reg [7:0] tx_data;
  wire tx;
  wire tx_busy;
  wire [7:0] rx_data;
  wire rx_ready;

  // Instantiate the top module
  uart_top #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) dut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .rx_ready(rx_ready)
  );

  // Clock generation
  always #(CLK_PERIOD / 2) clk = ~clk;

  // Task to send byte
  task send_byte(input [7:0] data);
    begin
      @(negedge clk);
      tx_data = data;
      tx_start = 1;
      @(negedge clk);
      tx_start = 0;
      wait (!tx_busy);  
    end
  endtask

  // Test sequence
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, uart_tb);

    // Reset
    #100;
    rst = 0;

    // Send test bytes
    send_byte(8'hA5); 
    #100000;          
    send_byte(8'h3C);
    #100000;

    // Monitor received data
    $display("Simulation complete.");
    $finish;
  end

  // Display received data
  always @(posedge rx_ready) begin
    $display("RX Received: %02X at time %0t", rx_data, $time);
  end

endmodule
