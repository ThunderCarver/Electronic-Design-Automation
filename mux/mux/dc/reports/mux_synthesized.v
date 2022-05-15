/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Sun May 15 01:10:07 2022
/////////////////////////////////////////////////////////////


module mux2_to_1_0 ( out, i0, i1, s0 );
  input i0, i1, s0;
  output out;


  MX2X1 U1 ( .A(i0), .B(i1), .S0(s0), .Y(out) );
endmodule


module mux2_to_1_1 ( out, i0, i1, s0 );
  input i0, i1, s0;
  output out;


  MX2X1 U1 ( .A(i0), .B(i1), .S0(s0), .Y(out) );
endmodule


module mux2_to_1_2 ( out, i0, i1, s0 );
  input i0, i1, s0;
  output out;


  MX2X1 U1 ( .A(i0), .B(i1), .S0(s0), .Y(out) );
endmodule


module mux4_to_1 ( out, i0, i1, i2, i3, s1, s0 );
  input i0, i1, i2, i3, s1, s0;
  output out;
  wire   w0, w1;

  mux2_to_1_0 m0 ( .out(w0), .i0(i0), .i1(i1), .s0(s0) );
  mux2_to_1_2 m1 ( .out(w1), .i0(i2), .i1(i3), .s0(s0) );
  mux2_to_1_1 m2 ( .out(out), .i0(w0), .i1(w1), .s0(s1) );
endmodule

