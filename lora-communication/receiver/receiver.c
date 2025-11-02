#include <stdio.h>
#include "pico/stdlib.h"
#include "pico/bootrom.h"
#include "hardware/spi.h"
#include "hardware/i2c.h"
#include "hardware/pio.h"
#include "hardware/uart.h"
#include "include/ssd1306.h"
#include "include/rfm96.h"
#include "math.h"

#define RESET_BUTTON_PIN 5
#define DIO0_PIN 8
#define DISPLAY_SDA_PIN 14
#define DISPLAY_SCL_PIN 15
#define MISO_PIN 16
#define CS_PIN 17
#define SCK_PIN 18
#define MOSI_PIN 19
#define RST_PIN 20

#define IN 0
#define OUT 1
#define PRESSED 0
#define NOT_PRESSED 1

#define LORA_FREQUENCY 915E6

bool resetButtonStatus = NOT_PRESSED;

struct render_area frame_area = {
    start_column : 0,
    end_column : ssd1306_width - 1,
    start_page : 0,
    end_page : ssd1306_n_pages - 1
};

typedef struct {
    int16_t temperature;
    int16_t humidity;
} sensorData;

void initializeComponents();
void readButtons();
void resetIntoBootselMode();
void setDisplay(char *message);
void setDisplayData(float receivedTemperature, float receivedHumidity);

int main()
{
    initializeComponents();

    setDisplay("Inicializado");

    sensorData receivedData;
    
    while (true) {
        readButtons();
        int receivedBytes = lora_receive_bytes((uint8_t *)&receivedData, sizeof(receivedData));

        if (resetButtonStatus == PRESSED)
        {
            resetIntoBootselMode();
        }
        else if (receivedBytes == sizeof(receivedData))
        {
            setDisplayData(receivedData.temperature / 100.0f, receivedData.humidity / 100.0f);
        }
    }
}

void initializeComponents()
{
    stdio_init_all();

    gpio_init(RESET_BUTTON_PIN);
    gpio_set_dir(RESET_BUTTON_PIN, IN);
    gpio_pull_up(RESET_BUTTON_PIN);
    
    i2c_init(i2c1, ssd1306_i2c_clock * 1000);
    gpio_set_function(DISPLAY_SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(DISPLAY_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(DISPLAY_SDA_PIN);
    gpio_pull_up(DISPLAY_SCL_PIN);
    ssd1306_init();
    calculate_render_area_buffer_length(&frame_area);
    setDisplay("Inicializando");

    rfm96_config_t lora_configuration =
    {
        .spi_instance = spi0,
        .pin_miso = MISO_PIN,
        .pin_cs = CS_PIN,
        .pin_sck = SCK_PIN,
        .pin_mosi = MOSI_PIN,
        .pin_rst = RST_PIN,
        .pin_dio0 = DIO0_PIN,
        .frequency = LORA_FREQUENCY
    };
    if (!lora_init(lora_configuration))
    {
        setDisplay("LoRa falhou");
        while (1);
    }
    setDisplay("LoRa inicializado");
    lora_start_rx_continuous();
}

void readButtons()
{
    resetButtonStatus = gpio_get(RESET_BUTTON_PIN);
}

void resetIntoBootselMode()
{
    reset_usb_boot(0, 0);
}

void setDisplay(char *message)
{
    uint8_t ssd[ssd1306_buffer_length];
    memset(ssd, 0, ssd1306_buffer_length);
    
    ssd1306_draw_string(ssd, 0, 8, message);
    
    render_on_display(ssd, &frame_area);
}

void setDisplayData(float receivedTemperature, float receivedHumidity)
{
    int wholeTemperature = (int)receivedTemperature;
    int fractionTemperature = (int)((fabsf(receivedTemperature) - abs(wholeTemperature)) * 100 + 0.5f);
    int wholeHumidity = (int)receivedHumidity;
    int fractionHumidity = (int)((fabsf(receivedHumidity) - abs(wholeHumidity)) * 100 + 0.5f);

    char temperatureString[32];
    char humidityString[32];
    sprintf(temperatureString, "Tmp: %d.%02dC", wholeTemperature, fractionTemperature);
    sprintf(humidityString,  "Umd: %d.%02d%%", wholeHumidity, fractionHumidity);

    uint8_t ssd[ssd1306_buffer_length];
    memset(ssd, 0, ssd1306_buffer_length);
    ssd1306_draw_string(ssd, 0, 8, temperatureString);
    ssd1306_draw_string(ssd, 0, 24, humidityString);
    render_on_display(ssd, &frame_area);
}