#ifndef MPSSE_H
#define MPSSE_H

#define MSB_RISING_EDGE_CLK_BYTE_OUT  0x10
#define MSB_FALLING_EDGE_CLK_BYTE_OUT 0x11
#define MSB_RISING_EDGE_CLK_BIT_OUT   0x12
#define MSB_FALLING_EDGE_CLK_BIT_OUT  0x13
#define MSB_RISING_EDGE_CLK_BYTE_IN   0x20
#define MSB_RISING_EDGE_CLK_BIT_IN    0x22
#define MSB_FALLING_EDGE_CLK_BYTE_IN  0x24
#define MSB_FALLING_EDGE_CLK_BIT_IN   0x26

#define SET_OUTPUT_L_BYTE 0x80
#define SET_OUTPUT_H_BYTE 0x82
#define SET_INPUT_L_BYTE 0x81
#define SET_INPUT_H_BYTE 0x83
#define SET_TCK_DIV 0x86
#define CLK_DIV_5_OFF       0x8A
#define CLK_DIV_5_ON        0x8B
#define CLK_CONT_IO_H       0x94    //Clk continuously and Wait On I/O High
#define CLK_CONT_IO_L       0x95    //Clk continuously and Wait On I/O Low

#define ADAPTIVE_CLK_ON     0x96
#define ADAPTIVE_CLK_OFF    0x97

#endif //MPSSE_H