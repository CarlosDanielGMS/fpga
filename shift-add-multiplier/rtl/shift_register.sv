module shift_register #(parameter PARALLEL_IN = 8)
(
    input logic clk, rst, ser_in,
    input logic [1:0] ctrl,
    input logic [PARALLEL_IN-1:0] parallel_in,

    output logic [PARALLEL_IN-1:0] parallel_out,
    output logic ser_out
);

logic [PARALLEL_IN-1:0] tmp;

always_ff @(posedge clk, posedge rst)
begin
    if (rst)
    begin
        tmp <= 0;
    end
    else
    begin
        case (ctrl)
            2'b00: tmp <= tmp;
            2'b01: tmp <= {ser_in, tmp[PARALLEL_IN-1:1]};
            2'b10: tmp <= {tmp[PARALLEL_IN-2:0], ser_in};
            2'b11: tmp <= parallel_in;
            default: tmp <= tmp;
        endcase
    end
end

assign parallel_out = tmp;

always_comb
begin
    case (ctrl)
        2'b01: ser_out = tmp[0];
        2'b10: ser_out = tmp[PARALLEL_IN-1];
        default: ser_out = 0;
    endcase
end
endmodule