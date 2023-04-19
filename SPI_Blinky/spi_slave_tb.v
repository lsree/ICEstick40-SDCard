`timescale 1ns/1ns
parameter MAIN_CLK_DELAY = 1;
parameter SCK_DELAY = 2

module spi_slave_tb;
reg r_clk;
reg r_sck;

logic r_MOSI;
logic cs;
logic 

initial begin
    r_clk = 0;
    cs = 1;
    r_MOSI = 0;
    

end

spi_slave slave1(
    //Sys signals
    .i_clk(r_clk), 
    .i_sys_rst(r_rst),

    //SPI Signals 
    .i_sck(r_sck), 
    .i_MOSI(r_MOSI),
    .i_cs(cs) )

task sendSingleByte(input [7:0]data);
    begin
        cs = 0;
        for (int i = 0; i < 8; i++)
        begin 
            #(SCK_DELAY)
            r_sck = !r_sck;
            r_MOSI = data[i];
             
        end
       cs = 1; 
    end
endtask

//CLK Generator
always #(MAIN_CLK_DELAY) r_clk = !r_clk;


endmodule