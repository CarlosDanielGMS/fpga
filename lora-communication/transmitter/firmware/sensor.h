#ifndef SENSOR_H_
#define SENSOR_H_

#include <stdint.h>
#include <stdbool.h>

typedef struct {
    int16_t temperature; 
    int16_t humidity;     
} sensorData;

void i2c_init(void);
void i2c_scan(void);
int sensor_init(void);
bool sensor_get_data(sensorData *d);

#endif