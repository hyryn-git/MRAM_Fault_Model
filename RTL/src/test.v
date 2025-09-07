module vending_machine(
    input clk,
    input rst,
    input [1:0] coin, // 00: 无投币, 01: 5元, 10: 10元
    output dispense,   // 1: 出货
    output change // 0: 无找零, 1: 5元
);

    // 状态定义
    parameter S0 = 2'b00; // 0元
    parameter S5 = 2'b01; // 5元
    parameter S10 = 2'b10; // 10元


    reg [1:0] current_state; 
    wire[1:0] next_state;

    // 状态转换逻辑
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
            case (current_state)
                S0: begin
                    if (coin == 2'b01) next_state = S5;
                    else if (coin == 2'b10) next_state = S10;
                    else next_state = S0;
                end
                S5: begin
                    if (coin == 2'b01) next_state = S10;
                    else if (coin == 2'b10) next_state = S0;
                    else next_state = S5;
                end
                S10: begin
                    if (coin == 2'b01) next_state = S0;
                    else if (coin == 2'b10) next_state = S0;
                    else next_state = S10;
                end
                default: next_state = S0;
            endcase
    end 

    always @(*) begin
        case(current_state)
            S0: begin
                dispense = 0;
                change = 0;
            end
            S5: begin
                if (coin == 2'b10) begin
                    dispense = 1;
                    change = 0;
                end
                else begin
                    dispense = 0;
                    change = 0;
                end
            end
            S10: begin
                if (coin == 2'b01) begin
                    dispense = 1;
                    change = 0;
                end 
                else if (coin == 2'b10) begin
                    dispense = 1;
                    change = 1; // 找5元
                end
                else begin
                    dispense = 0;
                    change = 0;
                end
            end
            default: begin
                dispense = 0;
                change = 0;
            end
        endcase
    end

endmodule