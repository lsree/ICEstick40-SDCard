`timescale 1ns/1ns
module spi_slave_tb;

parameter MAIN_CLK_DELAY = 2;
parameter SCK_DELAY = 3;


reg r_clk;
reg r_sck;

reg r_MOSI, r_tx_rdy;
reg r_cs;
wire w_MISO, w_rx_rdy;
wire [7:0] w_rx_byte, w_tx_byte;


spi_slave slave1(
    //Sys signals
    .i_clk(r_clk), 
    .i_sys_rst(r_rst),

    //SPI Signals 
    .i_sck(r_sck), 
    .i_MOSI(r_MOSI),
    .i_cs(r_cs) 
    .o_MISO(w_MISO)

    //Data Signals
    .o_rx_byte(w_rx_byte)
    .o_rx_rdy(w_rx_rdy)
    .i_tx_byte(w_tx_byte)
    .i_tx_rdy(r_tx_rdy)
);
reg [7:0] r_master_rx_data;
SPI_RX_Master spi_master1(
    .i_sck(r_sck)
    .i_cs(r_cs), 
    .i_MISO(w_MISO), 
    .reg o_rx_data(r_master_rx_data);
)

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

task loadByte(input [7:0] data);
begin
    @(posedge r_clk)
    begin
        w_tx_byte = data;
        r_tx_rdy = 1;
    end
    @(posedge r_clk)
        r_tx_rdy = 0;
end
endtask

//CLK Generator
always #(MAIN_CLK_DELAY) r_clk = !r_clk;

reg [7:0] test_bytes;
initial
    begin
    	r_clk = 0;
    	r_cs = 1;
    	r_MOSI = 0;
        r_sck = 1;
        //Simulate Receiving bytes from 0-255
        for(test_bytes = 0; test_bytes < 8'hFF; test_bytes = test_bytes + 1)
        begin
            sendSingleByte(test_bytes);
            @(posedge r_clk)
            begin
                //Check for notification
                if (w_rx_rdy != 0)
                    $display("Failed to notify that byte was received")
                //Check for correct value
                if (test_bytes != w_rx_byte)
                    $display("Failed receive correct value")
            end
            #10;
        end

        //Simulate sending bytes from 0-255
        for(test_bytes = 0; test_bytes < 8'hFF; test_bytes = test_bytes + 1)
        begin
            loadByte(test_bytes);
            repeat(8) @(posedge r_sck);     //Wait for byte to get clocked out
            //Check if value was sent correctly
            if (test_bytes != r_master_rx_data)
                $display("Failed to properly send data")
            #10;
        end

    end

endmodule


module SPI_RX_Master (
    input i_sck, 
    input i_cs, 
    input i_MISO, 
    output reg o_rx_data[7:0];
)

    always @ (posedge i_sck or posedge i_cs) begin
        if (i_cs)
            o_rx_data <=0;
        else begin
            o_rx_data <= {i_MISO, o_rx_data[7:1]};
        end
    end
endmodule