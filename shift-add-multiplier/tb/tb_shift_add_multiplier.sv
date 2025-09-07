module tb_shift_add_multiplier;

logic clk, rst, endMultiplication;
logic [7:0] aMultiplying, bMultiplier;
logic [15:0] result;

shift_add_multiplier dut
(
    .clk(clk),
    .rst(rst),
    .aMultiplying(aMultiplying),
    .bMultiplier(bMultiplier),
    .endMultiplication(endMultiplication),
    .result(result)
);

initial clk = 0;
always #100 clk = ~clk;

initial
begin
    $dumpfile("shift_add_multiplier.vcd");
    $dumpvars(0, tb_shift_add_multiplier);

    $display("Inicio da simulacao");
    
    rst = 1'b1;
    #10;
    rst = 1'b0;
    aMultiplying = 8'd3;
    bMultiplier = 8'd5;
    #10;
    wait(endMultiplication);
    $display("3 vezes 5 = %0d", result);
    
    rst = 1'b1;
    #10;
    rst = 1'b0;
    aMultiplying = 8'd10;
    bMultiplier = 8'd12;
    #10;
    wait(endMultiplication);
    $display("10 vezes 12 = %0d", result);
    
    rst = 1'b1;
    #10;
    rst = 1'b0;
    aMultiplying = 8'd127;
    bMultiplier = 8'd201;
    #10;
    wait(endMultiplication);
    $display("127 vezes 201 = %0d", result);

    $display("Fim da simulacao");

    $finish;
end
endmodule