module blinky (
        input clk, 
        output LED1, 
        output LED2, 
        output LED3, 
        output LED4, 
        output LED5
    );

    parameter half_sec_psc = 41'd256;
    parameter one_sec_psc = 41'd512;

    reg [40:0] half_sec_cntr = 41'd0;
    reg half_sec_pulse;
    reg [40:0] one_sec_cntr = 41'd0;
    reg one_sec_pulse;

    always@(posedge clk) 
    begin
        half_sec_cntr <= half_sec_cntr + 1;
        if (half_sec_cntr == half_sec_psc)
        begin
            half_sec_pulse <= !half_sec_pulse;
            half_sec_cntr <= 0;
        end

        one_sec_cntr <= one_sec_cntr + 1;
        if (one_sec_cntr == one_sec_psc)
        begin
            one_sec_pulse <= !one_sec_pulse;
            one_sec_cntr <= 0;
        end
    end

    assign LED5 = one_sec_pulse;
    assign {LED2, LED4} = {2{half_sec_pulse}};
    assign {LED1, LED3} = {2{!half_sec_pulse}};

endmodule