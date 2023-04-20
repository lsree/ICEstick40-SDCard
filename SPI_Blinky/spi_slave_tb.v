`timescale 1ns/1ns
module spi_slave_tb;

parameter MAIN_CLK_DELAY = 2;
parameter SCK_DELAY = 3;


reg r_clk;
reg r_sck;

reg r_MOSI;
reg r_cs;


/*spi_slave slave1(
    //Sys signals
    .i_clk(r_clk), 
    .i_sys_rst(r_rst),

    //SPI Signals 
    .i_sck(r_sck), 
    .i_MOSI(r_MOSI),
    .i_cs(r_cs) )
*/
integer i;
task sendSingleByte(input [7:0]data);
    begin
        r_cs = 0;

        for (i = 0; i < 8; i = i + 1)
        begin 
            #(SCK_DELAY)
            r_sck = !r_sck;
            r_MOSI = data[i];
            #(SCK_DELAY)
            r_sck = !r_sck;
        end
       r_cs = 1; 
    end
endtask

//CLK Generator
always #(MAIN_CLK_DELAY) r_clk = !r_clk;

initial
    begin
    	r_clk = 0;
    	r_cs = 1;
    	r_MOSI = 0;
        r_sck = 1;
        repeat(8)
        begin
            sendSingleByte(8'h1 );
            #10;
        end
    end


endmodule