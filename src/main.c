#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/cm3/scb.h>

#include <FreeRTOS.h>
#include <task.h>

#define LED_PIN GPIO15

static void TaskBlinkLED(void* pvParameters);

static void gpio_setup(void)
{
    /* Enable GPIOD clock. */
    /* Manually: */
    // RCC_AHB1ENR |= RCC_AHB1ENR_IOPDEN;
    /* Using API functions: */
    rcc_periph_clock_enable(RCC_GPIOD);

    /* Set GPIO12 (in GPIO port D) to 'output push-pull'. */
    /* Manually: */
    // GPIOD_CRH = (GPIO_CNF_OUTPUT_PUSHPULL << (((8 - 8) * 4) + 2));
    // GPIOD_CRH |= (GPIO_MODE_OUTPUT_2_MHZ << ((8 - 8) * 4));
    /* Using API functions: */
    gpio_mode_setup(GPIOD, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, LED_PIN);
}

int main(void)
{
    scb_set_priority_grouping(0x300);

    xTaskCreate(TaskBlinkLED, "LED", 256, NULL, 1, NULL);

    vTaskStartScheduler();

    while (1) {}
    return 0;
}

static void TaskBlinkLED(void *pvParamterers)
{
    const TickType_t xDelay = 500 / portTICK_PERIOD_MS;
    gpio_setup();

    while (1)
    {
        vTaskDelay(xDelay);
        gpio_toggle(GPIOD, LED_PIN);
    }
}