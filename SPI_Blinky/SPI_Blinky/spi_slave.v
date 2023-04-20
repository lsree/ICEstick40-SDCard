module spi_slave(
    input i_clk,        //Sys clk   
    input i_sys_rst,    //sys reset
    input i_sck,        //SPI SCK
    input i_MOSI,       //Master Out Slave In
    input i_cs,         //Active low
    output o_MISO,      //Master In Slave Out
    output reg [7:0] o_rx_byte; //Stored received byte
    output reg o_rx_rdy;        //Notifies that byte is ready to be read
    input [7:0] i_tx_byte;      //Byte to send  
    input i_tx_rdy;             //Notifies that transmission is ready
)
    //Assumes CPOL=0, CPHA=0


    //RX Bytes (using SCK domain)
    reg [7:0] r_rx_byte;                // Register that stores data as it is shifted in
    reg [7:0] r_rx_sck_full_byte;     //Stores a complete byte in SCK domain
    reg [2:0] r_rx_cntr;                  //Counts # of bytes received
    reg r_sck_rx_rdy;                   //Notifies from SCK domain that 1 byte has been read

    always @ (posedge sck or posedge i_cs) begin
        if (i_cs) begin
            r_rx_byte <= 8'd0;
            r_rx_cntr <= 3'd0;
            r_sck_rx_rdy <= 0;
            r_rx_sck_full_byte <= 0;
        end
        else begin 
            rx_cntr <= rx_cntr + 3'd1;
            rx_byte_r <= {i_MOSI, rx_byte_r[7:1]};    //Rx and store MSB
            if (rx_cntr == 3'b111)                  //Received 8 bits
                r_sck_rx_rdy <= 1'b1;
                r_rx_sck_full_byte <= rx_byte_r;  //Store completed byte
            else if (rx_cntr == 3'b010)     //r_sck_rx_rdy will be asserted for 2x sck cycles. Hopefully this is enough
                r_sck_rx_rdy <= 1'b0;
        end
    end 

    //Handle clock domain crossing from SPI SCK -> SYS CLK
    reg [1:0] r_rx_rdy_r_edge;    //Used to detect when rx byte is rdy. 0 pos is current value, 1 pos is last value
    always @ (posedge clk) begin
        if (~sys_rst) begin
            rx_rdy_r_edge <= 2'd0;
        end
        else begin
            rx_rdy_r_edge <= {rx_rdy_r_edge[0], rx_rdy_r};
            if (rx_rdy_r_edge == 2'b01) begin       //Rising edge
               o_rx_rdy <= 1'b0;
               o_rx_byte <= r_rx_sck_full_byte;
            end
            else
                o_rx_rdy <= 1'b1;
        end
    end

    //TX Bytes
    reg [7:0] r_tx_byte;    //Tx byte is buffered so parent modules can modify input
    always @ (posedge clk) begin
        if (~i_sys_rst)  
           r_tx_byte <= 8'h0; 
        else begin
            if (i_tx_rdy)
                r_tx_byte <= i_tx_byte;
        end
    end

    reg [2:0] r_tx_cntr;
    
    always @ (posedge i_sck, i_cs) begin
        if (i_cs) begin
            o_MISO <= 0;
            r_tx_cntr <= 3'b111;        //Tx MSB first
        end
        else begin
            r_tx_cntr <= r_tx_cntr - 1;
            o_MISO <= r_tx_byte[r_tx_cntr];
        end
    end


endmodule