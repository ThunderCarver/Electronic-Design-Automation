`timescale 1ns / 1ps


// copied from Samir Palnitkar's book

// Module 4-to-1 multiplexer
module mux4_to_1 (out, i0, i1, i2, i3, s1, s0);

output out;
input i0, i1, i2, i3;
input s1, s0;


wire w0, w1;
 mux2_to_1 m0 (w0, i0, i1, s0);
 mux2_to_1 m1 (w1, i2, i3, s0);
 mux2_to_1 m2 (out, w0, w1, s1);

endmodule