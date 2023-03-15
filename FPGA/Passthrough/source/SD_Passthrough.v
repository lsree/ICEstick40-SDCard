module SD_Passthrough(
    input FTDI_BDBUS0, 
    input FTDI_BDBUS1, 
    input FTDI_BDBUS2, 
    input FTDI_BDBUS3, 
    input FTDI_BDBUS4, 
    input FTDI_BDBUS5, 
    input FTDI_BDBUS6, 
    input FTDI_BDBUS7, 
    output SD_Card0,
    output SD_Card1,
    output SD_Card2,
    output SD_Card3,
    output SD_Card4,
    output SD_Card5,
    output SD_Card6,
    output SD_Card7
);

    assign PIO1_02 = FTDI_BDBUS0;
    assign PIO1_03 = FTDI_BDBUS1;
    assign PIO1_04 = FTDI_BDBUS2;
    assign PIO1_05 = FTDI_BDBUS3;
    assign PIO1_06 = FTDI_BDBUS4;
    assign PIO1_07 = FTDI_BDBUS5;
    assign PIO1_08 = FTDI_BDBUS6;
    assign PIO1_09 = FTDI_BDBUS7;
endmodule