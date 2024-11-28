#include "main.h"

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
}

int main() {
// задержка для того, чтобы контроллер успел войти в режим отладки, если вдруг гдето сильный баг
  for (uint32_t del = 0 ; del < 3000000; del++) {
    __NOP();
  }
  init_CPU();
  SystemCoreClockUpdate();
  while (1) {

  }
  return 0;
}
