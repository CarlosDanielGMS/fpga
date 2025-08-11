module tb_ula_8_bits;

logic [7:0] a, b;
logic [3:0] s;
logic m, c_in;

logic [7:0] f;
logic a_eq_b, c_out;

ula_8_bits dut
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

initial
    begin
        $dumpfile("ula_8_bits.vcd");
        $dumpvars(0, tb_ula_8_bits);

        $display("Inicio da simulacao");

        for (int mode = 1'b0; mode <= 1'b1; mode++)
            begin
                m = mode;

                for (int cin = 1'b0; cin <= 1'b1; cin++)
                    begin
                        c_in = cin;

                        for (int selection = 4'b0000; selection <= 4'b1111; selection++)
                            begin
                                s = selection;
                                
                                a = 4'b0100;
                                b = 4'b0011;

                                #10;

                                $display("M: %b, S: %0d, A: %0d, B: %0d, C_IN: %b, F: %0d, C_OUT: %b", m, s, a, b, c_in, f, c_out);
                            end
                    end
            end

        $display("Fim da simulacao");

        $finish;
    end
endmodule