module shift_add_multiplier
(
    input logic clk, rst,
    input logic [7:0] aMultiplying, bMultiplier,

    output logic endMultiplication,
    output logic [15:0] result
);

typedef enum logic [2:0]
{
    IDLE = 3'b000,
    LOAD = 3'b001,
    CHECK = 3'b010,
    SUM = 3'b011,
    SHIFT = 3'b100,
    DONE = 3'b101
} state_t;

state_t currentState, nextState;

logic [1:0] ctrlRegA, ctrlRegB, ctrlRegQ;
logic [7:0] sum, parallelOutRegA, parallelOutRegB, parallelOutRegQ, dataOutCounter;
logic serInReg, loadCounter, enableCounter, endCountdown, cOutALU;

shift_register #(8) registerA
(
    .clk(clk),
    .rst(rst),
    .ser_in(1'b0),
    .ctrl(ctrlRegA),
    .parallel_in(sum),
    .parallel_out(parallelOutRegA),
    .ser_out(serInReg)
);

shift_register #(8) registerB
(
    .clk(clk),
    .rst(rst),
    .ser_in(1'b0),
    .ctrl(ctrlRegB),
    .parallel_in(aMultiplying),
    .parallel_out(parallelOutRegB),
    .ser_out()
);

shift_register #(8) registerQ
(
    .clk(clk),
    .rst(rst),
    .ser_in(serInReg),
    .ctrl(ctrlRegQ),
    .parallel_in(bMultiplier),
    .parallel_out(parallelOutRegQ),
    .ser_out()
);

counter #(8) counterRepeat
(
    .clk(clk),
    .rst(rst),
    .load(loadCounter),
    .en(enableCounter),
    .up_down(1'b0),
    .data_in(8'b00001000),
    .endCountdown(endCountdown),
    .data_out(dataOutCounter)
);

alu_8_bit alu
(
    .a(parallelOutRegA),
    .b(parallelOutRegB),
    .s(4'b1001),
    .m(1'b0),
    .c_in(1'b0),
    .f(sum),
    .a_eq_b(),
    .c_out(cOutALU)
);

always_ff @(posedge clk, posedge rst)
begin
    if (rst)
    begin
        currentState <= IDLE;
    end
    else
        currentState <= nextState;
end

always_comb begin
    ctrlRegA = 2'b00;
    ctrlRegB = 2'b00;
    ctrlRegQ = 2'b00;
    loadCounter = 1'b0;
    enableCounter = 1'b0;
    endMultiplication = 1'b0;
    nextState = currentState;

    case (currentState)
        IDLE:
        begin
            nextState = LOAD;
        end
        LOAD:
        begin
            ctrlRegA = 2'b11;
            ctrlRegB = 2'b11;
            ctrlRegQ = 2'b11;
            loadCounter = 1'b1;
            nextState = CHECK;
        end
        CHECK:
        begin
            enableCounter = 1'b1;
            if (parallelOutRegQ[0])
            begin
                nextState = SUM;
            end
            else
                nextState = SHIFT;
        end
        SUM:
        begin
            ctrlRegA = 2'b11;
            nextState = SHIFT;
        end
        SHIFT:
        begin
            ctrlRegA = 2'b01;
            ctrlRegQ = 2'b01;
            if (endCountdown)
            begin
                nextState = DONE;
            end
            else
                nextState = CHECK;
        end
        DONE:
        begin
            endMultiplication = 1'b1;
            nextState = DONE;
        end
    endcase
end

assign result = {parallelOutRegA, parallelOutRegQ};
endmodule