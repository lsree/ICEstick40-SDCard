module blinky (
        input clk, 
        output LED1, 
        output LED2, 
        output LED3, 
        output LED4, 
        output LED5
    );

    parameter half_sec_psc = 32'd6000000;
    //parameter one_sec_psc = 41'd512;

    reg [15:0] div_cntr1;
    reg [6:0] div_cntr2;
    reg half_sec_pulse = 0;

    always@(posedge clk) 
    begin
        div_cntr1 <= div_cntr1  + 1;
        if (div_cntr1 == 0)
            if (div_cntr2 == 91)
            begin
                half_sec_pulse <= ~half_sec_pulse;
                div_cntr2  <= 0;
            end
            else
                div_cntr2 <= div_cntr2 + 1;
   end

    assign LED5 = half_sec_pulse;
    assign {LED2, LED4} = {2{half_sec_pulse}};
    assign {LED1, LED3} = {2{!half_sec_pulse}};

endmodule