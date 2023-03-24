//This program sends a single byte counter value over SPI using the FTDI233H device. 



#include <stdio.h>
#include <stdint.h>
#include <ftdi.h>
#include "MPSSE.h"

#define FTDI_INTERFACE INTERFACE_B
#define PID             0x6010      //USB Product ID
#define VID             0x0403      //USB Vendor ID

char tx_arr[256] = {
    0,1,2,3,4,5,6,7,
    8,9,10,11,12,13,14,15,
    16,17,18,19,20,21,22,23,
    24,25,26,27,28,29,30,31,
    32,33,34,35,36,37,38,39,
    40,41,42,43,44,45,46,47,
    48,49,50,51,52,53,54,55,
    56,57,58,59,60,61,62,63,
    64,65,66,67,68,69,70,71,
    72,73,74,75,76,77,78,79,
    80,81,82,83,84,85,86,87,
    88,89,90,91,92,93,94,95,
    96,97,98,99,100,101,102,103,
    104,105,106,107,108,109,110,111,
    112,113,114,115,116,117,118,119,
    120,121,122,123,124,125,126,127,
    128,129,130,131,132,133,134,135,
    136,137,138,139,140,141,142,143,
    144,145,146,147,148,149,150,151,
    152,153,154,155,156,157,158,159,
    160,161,162,163,164,165,166,167,
    168,169,170,171,172,173,174,175,
    176,177,178,179,180,181,182,183,
    184,185,186,187,188,189,190,191,
    192,193,194,195,196,197,198,199,
    200,201,202,203,204,205,206,207,
    208,209,210,211,212,213,214,215,
    216,217,218,219,220,221,222,223,
    224,225,226,227,228,229,230,231,
    232,233,234,235,236,237,238,239,
    240,241,242,243,244,245,246,247,
    248,249,250,251,252,253,254,255};


int SPI_init(struct ftdi_context * ftdic);
int SPI_write(struct ftdi_context * ftdic, char * data, uint16_t len);

int main(int argc, char * argv[])
{
    int ret = 0;
    struct ftdi_context *ftdic = NULL;
    ftdic = ftdi_new();
    if (NULL == ftdic)
    {
        fprintf(stderr, "ftdi_new failed\n");
        return EXIT_FAILURE;
    }

    ftdi_set_interface(ftdic, INTERFACE_B);

/*    struct ftdi_device_list * device_list = NULL;
    int num_devices = ftdi_usb_find_all(ftdi, &device_list, VID, PID);
    if (num_devices < 0)
    {
        fprintf(stderr, "unable to list ftdi device: %d (%s)\n", num_devices, ftdi_get_error_string(ftdi));
    }
    printf("There are %i devices\n", num_devices);
    */

    if (ftdi_usb_open(ftdic, VID, PID) < 0)
    {
        fprintf(stderr, "unable to open ftdi device: (%s)\n", ftdi_get_error_string(ftdic));
        ftdi_free(ftdic);
        return EXIT_FAILURE;
    }

  	if (ftdi_usb_reset(ftdic)) {
		fprintf(stderr, "Failed to reset iCE FTDI USB device.\n %s\n", ftdi_get_error_string(ftdic));
        goto cleanup;
	}

	if (ftdi_usb_purge_buffers(ftdic)) {
		fprintf(stderr, "Failed to purge buffers on iCE FTDI USB device.\n%s\n", 
            ftdi_get_error_string(ftdic));
        goto cleanup;
	}

	if (ftdi_set_bitmode(ftdic, 0xff, BITMODE_MPSSE) < 0) {
		fprintf(stderr, "Failed set BITMODE_MPSSE on iCE FTDI USB device.\n%s\n", 
            ftdi_get_error_string(ftdic));
        goto cleanup;
	}

    if (SPI_init(ftdic) < 0)
    {
		fprintf(stderr, "Failed init SPI on iCE FTDI USB device.\n%s\n", 
            ftdi_get_error_string(ftdic));
 
    }

    printf("SPI_INIT\n");
    /* while (1)
    {
        SPI_write(ftdic, tx_arr, 256);

        sleep(1);
    }*/


    cleanup:
        ftdi_free(ftdic);
    return 0;
}


int SPI_init(struct ftdi_context * ftdic)
{
    char config_cmds[6] = {CLK_DIV_5_OFF, ADAPTIVE_CLK_OFF, SET_OUTPUT_L_BYTE, 
        SET_TCK_DIV, 0xFF, 0xFF};
    return ftdi_write_data(ftdic, config_cmds, sizeof(config_cmds));
}

int SPI_write(struct ftdi_context * ftdic, char * data, uint16_t len)
{
    int status = 0;
    //TX OPCODE
    uint8_t tx[3] =  {MSB_FALLING_EDGE_CLK_BYTE_OUT, (uint8_t) len, (uint8_t) (len >> 8)};
    status = ftdi_write_data(ftdic, tx, sizeof(tx));
    if (status < 0)
    {
        fprintf(stderr, "Unable to send opcode during SPI write\n%s\n", ftdi_get_error_string(ftdic));
        return status;
    }

    //TX data
    status = ftdi_write_data(ftdic, data, len);
    if (status < 0)
    {
        fprintf(stderr, "Unable to send data during SPI write\n%s\n", ftdi_get_error_string(ftdic));
    }
    return status;
 

}
