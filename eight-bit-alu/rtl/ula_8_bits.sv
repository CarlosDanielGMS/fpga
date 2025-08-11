module ula_8_bits (
    input logic [7:0] a, b,
    input logic [3:0] s,
    input logic m, c_in,

    output logic [7:0] f,
    output logic a_eq_b, c_out
);

logic [3:0] f_highest, f_lowest;
logic c_mid;
