module dot_product
(
    input logic clock, reset, start,
    input logic [31:0] a0, a1, a2, a3, a4, a5, a6, a7,
    input logic [31:0] b0, b1, b2, b3, b4, b5, b6, b7,

    output logic done,
    output logic [63:0] result
);

always_ff @(posedge clock, posedge reset)
begin
    if (reset)
    begin
        result <= 0;
        done <= 0;
    end
    else if (start)
    begin
        result <= a0 * b0 + a1 * b1 + a2 * b2 + a3 * b3 + a4 * b4 + a5 * b5 + a6 * b6 + a7 * b7;
        done <= 1;
    end
    else
    begin
        done <= 0;
    end
end

endmodule