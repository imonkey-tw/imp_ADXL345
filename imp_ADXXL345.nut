class Accelerometer_adxl345 {
    // Data Members
    //   i2c parameters
    i2cPort = null;
    i2cAddress = null;
     //  Minimal constants carried over from Arduino library

    ADXL345_ADDRESS          = 0x53 ;

    ADXL345_REG_DEVID        = 0x00  ; // Device ID
    ADXL345_REG_DATAX0       = 0x32 ; // X-axis data 0 (6 bytes for X/Y/Z)
    ADXL345_REG_POWER_CTL    = 0x2D  ;//  Power-saving features control

    ADXL345_DATARATE_0_10_HZ = 0x00 ;
    ADXL345_DATARATE_0_20_HZ = 0x01 ;
    ADXL345_DATARATE_0_39_HZ = 0x02 ;
    ADXL345_DATARATE_0_78_HZ = 0x03 ;
    ADXL345_DATARATE_1_56_HZ = 0x04 ;
    ADXL345_DATARATE_3_13_HZ = 0x05 ;
    ADXL345_DATARATE_6_25HZ  = 0x06 ;
    ADXL345_DATARATE_12_5_HZ = 0x07 ;
    ADXL345_DATARATE_25_HZ   = 0x08 ;
    ADXL345_DATARATE_50_HZ   = 0x09 ;
    ADXL345_DATARATE_100_HZ  = 0x0A ; // (default)
    ADXL345_DATARATE_200_HZ  = 0x0B ;
    ADXL345_DATARATE_400_HZ  = 0x0C ;
    ADXL345_DATARATE_800_HZ  = 0x0D ;
    ADXL345_DATARATE_1600_HZ = 0x0E ;
    ADXL345_DATARATE_3200_HZ = 0x0F ;

    ADXL345_RANGE_2_G        = 0x00 ; // +/-  2g (default)
    ADXL345_RANGE_4_G        = 0x01 ; // +/-  4g
    ADXL345_RANGE_8_G        = 0x02 ; // +/-  8g
    ADXL345_RANGE_16_G       = 0x03 ; // +/- 16g


    
   
    constructor( i2c_port, i2c_address7bit ) {
        // example:   local mysensor = TempDevice_BMP085(I2C_89, 0x49);
        if(i2c_port == I2C_12)
        {
            // Configure I2C bus on pins 1 & 2
            hardware.configure(I2C_12);
            hardware.i2c12.configure(CLOCK_SPEED_100_KHZ);
            i2cPort = hardware.i2c12;
        }
        else if(i2c_port == I2C_89)
        {
            // Configure I2C bus on pins 8 & 9
            hardware.configure(I2C_89);
            hardware.i2c89.configure(CLOCK_SPEED_100_KHZ);
            i2cPort = hardware.i2c89;
        }
        else
        {
            server.log("Invalid I2C port " + i2c_port + " specified in adxl345::constructor.");
        }

        // To communicate with the device, the datasheet wants the 7 bit address + 1 bit for direction,
        // which can be left at 0 since one of the forums says the I2C always sets the last bit to the 
        // appropriate value 1/0 for read/write. We accout for the 1 bit by bitshifting <<1.
        // So, specify i2c_address7bit=0x49, and the code will use: i2cAddress= 1001001 0 = 0b1001.0010 = 0x92
        i2cAddress = (i2c_address7bit << 1);
        
    }

   

    function read_accelerometer( ) {
        
        local reg_data = i2cPort.read(i2cAddress,format("%c",ADXL345_REG_DATAX0), 6) ;
        local accel ;
        accel[0] = (((reg_data[0]|reg_data[1]<<8)< 32767 ? (reg_data[0]|reg_data[1]<<8) : ((reg_data[0]|reg_data[1]<<8)-65536)))/256.0 ;
        accel[1] = (((reg_data[2]|reg_data[3]<<8)< 32767 ? (reg_data[2]|reg_data[3]<<8) : ((reg_data[2]|reg_data[3]<<8)-65536)))/256.0 ;
        accel[2] = (((reg_data[4]|reg_data[5]<<8)< 32767 ? (reg_data[4]|reg_data[5]<<8) : ((reg_data[4]|reg_data[5]<<8)-65536)))/256.0 ;
       
        return accel;
    }

 
