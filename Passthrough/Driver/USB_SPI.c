//This program sends a single byte counter value over SPI using the FTDI233H device. 



#include <stdio.h>
#include <stdint.h>
#include <ftdi.h>

#define FTDI_INTERFACE INTERFACE_B
#define PID             0x6010      //USB Product ID
#define VID             0x0403      //USB Vendor ID

int main(int argc, char * argv[])
{
    int ret = 0;
    struct ftdi_context *ftdi = NULL;
    ftdi = ftdi_new();
    if (NULL == ftdi)
    {
        fprintf(stderr, "ftdi_new failed\n");
        return EXIT_FAILURE;
    }

    struct ftdi_device_list * device_list = NULL;
    int num_devices = ftdi_usb_find_all(ftdi, &device_list, VID, PID);
    if (num_devices < 0)
    {
        fprintf(stderr, "unable to list ftdi device: %d (%s)\n", num_devices, ftdi_get_error_string(ftdi));
    }
    printf("There are %i devices\n", num_devices);

    if ((ret = ftdi_usb_open(ftdi, VID, PID)) < 0)
    {
        fprintf(stderr, "unable to open ftdi device: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
        ftdi_free(ftdi);
        return EXIT_FAILURE;
    }
 
    ftdi_free(ftdi);
    return 0;
}


