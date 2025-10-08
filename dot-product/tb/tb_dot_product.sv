module tb_dot_product;

logic clock, reset, start;
logic [31:0] a0, a1, a2, a3, a4, a5, a6, a7;
logic [31:0] b0, b1, b2, b3, b4, b5, b6, b7;

logic done;
logic [63:0] result;

logic [63:0] expected;

dot_product dut
(
    .clock(clock), .reset(reset), .start(start),
    .a0(a0), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .a5(a5), .a6(a6), .a7(a7),
    .b0(b0), .b1(b1), .b2(b2), .b3(b3), .b4(b4), .b5(b5), .b6(b6), .b7(b7),

    .done(done),
    .result(result)
);

initial clock = 0;
always #10 clock = ~clock;

initial
begin
    $dumpfile("dot_product.vcd");
    $dumpvars(0, tb_dot_product);

    $display("Inicio da simulacao");

    $display("----- Inicio do teste 1 -----");
    start = 0;
    reset = 1;
    @(posedge clock);
    reset = 0;
    a0 = 1; a1 = 3; a2 = 5; a3 = 7; a4 = 9; a5 = 11; a6 = 13; a7 = 15;
    b0 = 2; b1 = 4; b2 = 6; b3 = 8; b4 = 10; b5 = 12; b6 = 14; b7 = 16;
    $display("Entradas A: A0 = %0d, A1 = %0d, A2 = %0d, A3 = %0d, A4 = %0d, A5 = %0d, A6 = %0d, A7 = %0d", a0, a1, a2, a3, a4, a5, a6, a7);
    $display("Entradas B: B0 = %0d, B1 = %0d, B2 = %0d, B3 = %0d, B4 = %0d, B5 = %0d, B6 = %0d, B7 = %0d", b0, b1, b2, b3, b4, b5, b6, b7);
    expected = 744;
    start = 1;
    @(posedge done);
    start = 0;
    if (result == expected)
    begin
        $display("Perfeito...");
    end
    else
    begin
        $display("Errado...");
    end
    $display("Saida: %0d", result);
    $display("Esperado: %0d", expected);
    expected = 0;
    $display("----- Fim do teste 1 -----");
    
    $display("");

    $display("----- Inicio do teste 2 -----");
    start = 0;
    reset = 1;
    @(posedge clock);
    reset = 0;
    a0 = 0; a1 = 2; a2 = 4; a3 = 6; a4 = 8; a5 = 10; a6 = 12; a7 = 14;
    b0 = 3; b1 = 6; b2 = 9; b3 = 12; b4 = 15; b5 = 18; b6 = 21; b7 = 24;
    $display("Entradas A: A0 = %0d, A1 = %0d, A2 = %0d, A3 = %0d, A4 = %0d, A5 = %0d, A6 = %0d, A7 = %0d", a0, a1, a2, a3, a4, a5, a6, a7);
    $display("Entradas B: B0 = %0d, B1 = %0d, B2 = %0d, B3 = %0d, B4 = %0d, B5 = %0d, B6 = %0d, B7 = %0d", b0, b1, b2, b3, b4, b5, b6, b7);
    expected = 1008;
    start = 1;
    @(posedge done);
    start = 0;
    if (result == expected)
    begin
        $display("Perfeito...");
    end
    else
    begin
        $display("Errado...");
    end
    $display("Saida: %0d", result);
    $display("Esperado: %0d", expected);
    expected = 0;
    $display("----- Fim do teste 2 -----");

    $display("Fim da simulacao");

    $finish;
end
    
endmodule