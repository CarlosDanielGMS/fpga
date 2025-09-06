module alu_8_bit
(
    input logic [7:0] a, b,
    input logic [3:0] s,
    input logic m, c_in,

    output logic [7:0] f,
    output logic a_eq_b, c_out
);

logic [3:0] f_lowest, f_highest;
logic c_out_lowest, c_out_highest;

alu_74181 alu_lowest
(
    .a(a[3:0]),
    .b(b[3:0]),
    .s(s),
    .m(m),
    .c_in(c_in),
    .f(f_lowest),
    .a_eq_b(),
    .c_out(c_out_lowest)
);

alu_74181 alu_highest
(
    .a(a[7:4]),
    .b(b[7:4]),
    .s(s),
    .m(m),
    .c_in(c_out_lowest),
    .f(f_highest),
    .a_eq_b(),
    .c_out(c_out_highest)
);

assign f = {f_highest, f_lowest};
assign c_out = c_out_highest;
assign a_eq_b = (a == b);
endmodule