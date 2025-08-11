module ula_74181
(
    input logic [3:0] a, b, s,
    input logic m, c_in,

    output logic [3:0] f,
    output logic a_eq_b, c_out
);

logic [4:0] full_calc;

always @(*)
    begin
        if (m)
            begin
                case (s)
                    4'b0000: f = ~a;
                    4'b0001: f = ~(a | b);
                    4'b0010: f = ~a & b;
                    4'b0011: f = 4'b0000;
                    4'b0100: f = ~a & ~b;
                    4'b0101: f = ~b;
                    4'b0110: f = a ^ b;
                    4'b0111: f = a & ~b;
                    4'b1000: f = ~a | b;
                    4'b1001: f = ~(a ^ b);
                    4'b1010: f = b;
                    4'b1011: f = a & b;
                    4'b1100: f = 4'b1111;
                    4'b1101: f = a | ~b;
                    4'b1110: f = a | b;
                    4'b1111: f = a;
                    default: f = 4'b0000;
                endcase
                
                full_calc = f;
                c_out = full_calc[4];
            end
        else if (c_in)
            begin
                case (s)
                    4'b0000: full_calc = a;
                    4'b0001: full_calc = a | b;
                    4'b0010: full_calc = a | ~b;
                    4'b0011: full_calc = 5'b11111;
                    4'b0100: full_calc = a + a & ~b;
                    4'b0101: full_calc = (a | b) + (a & ~b);
                    4'b0110: full_calc = a - b - 1;
                    4'b0111: full_calc = (a & (~b)) - 1;
                    4'b1000: full_calc = a + (a & b);
                    4'b1001: full_calc = a + b;
                    4'b1010: full_calc = a | ~b + (a & b);
                    4'b1011: full_calc = (a & b) - 1;
                    4'b1100: full_calc = a + a;
                    4'b1101: full_calc = (a | b) + a;
                    4'b1110: full_calc = (a | ~b) + a;
                    4'b1111: full_calc = a - 1;
                    default: full_calc = 5'b00000;
                endcase

                f = full_calc[3:0];
                c_out = full_calc[4];
            end
        else
            begin
                case (s)
                    4'b0000: full_calc = a + 1;
                    4'b0001: full_calc = (a | b) + 1;
                    4'b0010: full_calc = (a | ~b) + 1;
                    4'b0011: full_calc = 5'b00000;
                    4'b0100: full_calc = (a + (a & ~b)) + 1;
                    4'b0101: full_calc = ((a | b) + (a & ~b)) + 1;
                    4'b0110: full_calc = (a - b);
                    4'b0111: full_calc = (a & ~b);
                    4'b1000: full_calc = (a + (a & b)) + 1;
                    4'b1001: full_calc = (a + b) + 1;
                    4'b1010: full_calc = ((a | ~b) + (a & b)) + 1;
                    4'b1011: full_calc = (a & b);
                    4'b1100: full_calc = (a + a) + 1;
                    4'b1101: full_calc = ((a | b) + a) + 1;
                    4'b1110: full_calc = ((a | ~b) + a) + 1;
                    4'b1111: full_calc = a;
                    default: full_calc = 5'b00000;
                endcase

                f = full_calc[3:0];
                c_out = full_calc[4];
            end

        a_eq_b = (a == b) ? 1'b1 : 1'b0;
    end
endmodule