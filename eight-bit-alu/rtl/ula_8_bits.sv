module ula_8_bits (
    input logic [7:0] a, b,
    input logic [3:0] s,
    input logic m, c_in,

    output logic [7:0] f,
    output logic a_eq_b, c_out
);

logic [3:0] f_highest, f_lowest;
logic c_mid;

ula_74181 ula_highest (
    .a(a[7:4]),
    .b(b[7:4]),
    .s(s),
    .m(m),
    .c_in(c_mid),
    .f(f_highest),
    .a_eq_b(),
    .c_out(c_out)
);

ula_74181 ula_lowest (
    .a(a[3:0]),
    .b(b[3:0]),
    .s(s), .m(m),
    .c_in(c_in),
    .f(f_lowest),
    .a_eq_b(),
    .c_out(c_mid)
);

assign f = {f_highest, f_lowest};
assign a_eq_b = (a == b);
endmodule