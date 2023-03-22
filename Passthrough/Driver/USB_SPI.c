//This program sends a single byte counter value over SPI using the FTDI233H device. 



#include <stdio.h>
#include <stdint.h>
#include <ftdi.h>
#include "MPSSE.h"

#define FTDI_INTERFACE INTERFACE_B
#define PID             0x6010      //USB Product ID
#define VID             0x0403      //USB Vendor ID

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

    while (1)
    {
        for (uint8_t i = 0; i < 256; ++i)
        {
            SPI_write(ftdic, &i, 1);
        }
    }


    cleanup:
        ftdi_free(ftdic);
    return 0;
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
