module tb_ula_74181;

logic [3:0] a, b, s;
logic m, c_in;

logic [3:0] f;
logic a_eq_b, c_out;

ula_74181 dut
(
    .a(a),
    .b(b),
    .s(s),
    .m(m),
    .c_in(c_in),
    .f(f),
    .a_eq_b(a_eq_b),
    .c_out(c_out)
);

endmodule