# ICEstick40-SDCard
USB-SD Card interface using the Lattic ICEStick40 FPGA dev board. 

## Timeline
* Build SPI driver that makes LEDs blink - 2 Weeks
  * Linux SPI driver
  * Verilog code
* Build Linux driver with FPGA configured to pass-through signals - 1 month
* Build verilog code that will seperate SD Card commands from the data. 

## Relevant Links
* Using SPI interface to interact with FPGA (not just flas) https://github.com/julian1/ice40-spi-usb-controller. 
* USB Linux Driver example?? http://www.embeddedlinux.org.cn/EssentialLinuxDeviceDrivers/final/ch11lev1sec6.html
* How to write USB Drivers https://www.kernel.org/doc/html/next/driver-api/usb/writing_usb_driver.html


## Random Notes
* Need to store VID and PID in EEPROM. This will allow the linux kernel to load the correct driver
  * There already exists an EEPROM device (93LC56-SO8/U2) on the ICEStick
    |FTDI Pin | Description |
    |-|-|
    | 63 | Chip Select |
    | 62 | CLK |
    | 61 | Data|
* Looks like the D2xx drivers need to be used instead of the VCP/COM drivers to attain the correct speeds
* At the kernel side / driver use the SCSI (Small Computer Systems Interface). There is a layer called SCSI Disk than could be used. 
* It looks like programming it using MTD (Memory Technology Device) is a another option. 


