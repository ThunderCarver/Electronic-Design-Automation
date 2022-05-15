module top(
  input            clk,
  input            rst,
  input      [3:0] a,
  input      [3:0] b,
  output reg [3:0] c
);

  always @(posedge clk, negedge rst) begin
    if (!rst) begin
        c <= 'b0;
    end else begin
        c <= a + b;
    end
  end

endmodule
