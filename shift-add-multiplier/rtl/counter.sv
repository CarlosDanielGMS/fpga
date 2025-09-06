module counter #(parameter SIZE = 4)
(
    input logic clk, rst, load, en, up_down,
    input logic [SIZE-1:0] data_in,

    output logic endCountdown,
    output logic [SIZE-1:0] data_out
);

logic [SIZE-1:0] tmp;

always_ff @(posedge clk, posedge rst)
begin
    if (rst)
    begin
        tmp <= 0;
    end
    else if (load)
    begin
        tmp <= data_in;
    end
    else if (en)
    begin
        if (up_down)
        begin
            tmp <= tmp + 1;
        end
        else
            tmp <= tmp - 1;
    end
end

assign data_out = tmp;
assign endCountdown = (tmp == 0);
endmodule