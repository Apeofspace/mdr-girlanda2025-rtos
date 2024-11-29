#include "FreeRTOS.h"
#include "task.h"
// #include "queue.h"
// #include "timers.h"
// #include "semphr.h"

#include "MDR32Fx.h"                    // Keil::Device:Startup
#include "system_MDR32F9Qx.h"
#include "MDR32F9Qx_port.h"             // Keil::Drivers:PORT
#include "MDR32F9Qx_rst_clk.h"          // Keil::Drivers:RST_CLK
#include "MDR32F9Qx_usb_CDC.h"

#include "main.h"
// #include "girlanda.h"
#include "joystick.h"

void init_CPU() {
//attempts HSE
// оисциллятор стоит 8 мГц, аккуратно с множителем
  MDR_RST_CLK->HS_CONTROL = RST_CLK_HSE_ON; //Вкл. HSE
  if (RST_CLK_HSEstatus() == SUCCESS) {
    MDR_RST_CLK->CPU_CLOCK = (2 << 0); // set HSE
    MDR_RST_CLK->CPU_CLOCK |= (0 << 4); // set c3 to c2/1
    MDR_RST_CLK->PLL_CONTROL |= (9 << 8); // 9+1 multiplier for PLL_CPU
    // NOTE make sure that HSE_Value is set up correctly
    MDR_RST_CLK->PLL_CONTROL |= (1 << 2); // enable PLL_CPU
    MDR_RST_CLK->CPU_CLOCK |= (1 << 2); // set c2 to PLL_CPU
    MDR_RST_CLK->CPU_CLOCK |= (1 << 8); // set HCLK to c3
  } else {
// HSE failed, try HSI
    MDR_RST_CLK->HS_CONTROL = 0; //HSE OFF
    MDR_RST_CLK->CPU_CLOCK = 0 << 8; //HCLK -> HSI
    MDR_RST_CLK->CPU_CLOCK |= 0 << 2; //c2 -> c1
    MDR_RST_CLK->CPU_CLOCK |= 0 << 0; //c1 -> HSI
    MDR_RST_CLK->PLL_CONTROL = 1 << 2; //CPUPLL ON
    MDR_RST_CLK->PLL_CONTROL |= 9 << 8; //PLL multiplier = 9+1
    MDR_RST_CLK->CPU_CLOCK |= 1 << 2; //c2 -> CPUPLL
    MDR_RST_CLK->CPU_CLOCK |= 0 << 4; //c3 divider = 0
    MDR_RST_CLK->CPU_CLOCK |= 1 << 8; //HCLK -> c3
  }
  SystemCoreClockUpdate(); // выставить SystemCoreClock в реальное значение
}

void init_LEDs() {
  PORT_InitTypeDef GPIO_init_struct;
  RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB, ENABLE);
  GPIO_init_struct.PORT_PULL_UP = PORT_PULL_UP_OFF;
  GPIO_init_struct.PORT_PULL_DOWN = PORT_PULL_DOWN_OFF;
  GPIO_init_struct.PORT_PD_SHM = PORT_PD_SHM_OFF;
  GPIO_init_struct.PORT_PD = PORT_PD_DRIVER;
  GPIO_init_struct.PORT_GFEN = PORT_GFEN_OFF;
  GPIO_init_struct.PORT_SPEED = PORT_SPEED_SLOW;
  GPIO_init_struct.PORT_MODE = PORT_MODE_DIGITAL;
  GPIO_init_struct.PORT_OE = PORT_OE_OUT;
  GPIO_init_struct.PORT_FUNC = PORT_FUNC_PORT;
  GPIO_init_struct.PORT_Pin = (PORT_Pin_0 | PORT_Pin_1 | PORT_Pin_2 | PORT_Pin_3);
  PORT_Init(MDR_PORTB, &GPIO_init_struct);
}


void vBlinkyTask (void * pvParameters) {
  bool pin_state = false;
  char boofrx[32];
  init_USB((uint8_t*)boofrx);
  init_LEDs();
  for ( ;; ) {
    vTaskDelay(500);
    PORT_WriteBit(MDR_PORTB, PORT_Pin_0, pin_state);
    pin_state = !pin_state;
    USB_CDC_SendData((uint8_t*)&SystemCoreClock, 4);
  }
  vTaskDelete(NULL);
}

void vJoystickTask (void * pvParameters) {
  init_joystick();
  init_LEDs();
  bool led_state[5] = {0, 0, 0, 0, 0};
  for ( ;; ) {
    vTaskDelay(1);
    switch (joystick_get_key_loop()) {
    case SEL:
      // state.flags.paused = !(state.flags.paused);
      break;
    case RIGHT:
      led_state[0] = !led_state[0];
      PORT_WriteBit(MDR_PORTB, PORT_Pin_0, led_state[0]);
      // state.algos.selected++;
      // if (state.algos.selected >= state.algos.count)
      // state.algos.selected = 0;
      // state.recently_switched_algo = true;
      break;
    case LEFT:
      led_state[1] = !led_state[1];
      PORT_WriteBit(MDR_PORTB, PORT_Pin_1, led_state[1]);
      // if (state.algos.selected == 0) {
      // state.algos.selected = state.algos.count - 1;
      // } else {
      // state.algos.selected--;
      // }
      // state.recently_switched_algo = true;
      break;
    case UP:
      led_state[2] = !led_state[2];
      PORT_WriteBit(MDR_PORTB, PORT_Pin_2, led_state[2]);
      // state.speed = (state.speed >= 0.85) ? 1 : state.speed + 0.1;
      break;
    case DOWN:
      led_state[3] = !led_state[3];
      PORT_WriteBit(MDR_PORTB, PORT_Pin_3, led_state[3]);
      // state.speed = (state.speed <= 0.25) ? 0.1 : state.speed - 0.1;
      break;
    case NOKEY:
    default:
      break;
    }
  }
  vTaskDelete(NULL);
}

int main() {
// задержка для того, чтобы контроллер успел войти в режим отладки
  for (uint32_t del = 0 ; del < 1000000; del++) {
    __NOP();
  }
  init_CPU();

  // xTaskCreate(vBlinkyTask, "blinkytask", 128, NULL, tskIDLE_PRIORITY + 1, NULL);
  xTaskCreate(vJoystickTask, "joysticktask", 128, NULL, tskIDLE_PRIORITY + 1, NULL);

  vTaskStartScheduler();
  while (1) {
  }
  return 0;
}
