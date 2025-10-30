#include "girlanda.h"

#include <string.h>

#include "MDR32F9Qx_port.h"
#include "MDR32F9Qx_rst_clk.h"
#include "MDR32F9Qx_ssp.h"
#include "definitions.h"
#include "helpers.h"

pixel_t pixels[LEDS_NUMBER];
uint8_t tx_arr[LEDS_NUMBER * 3 * 8];
global_state_t state = {
    .ms = 0,
    .last_ms = 0,
    .speed = 0.5,
    .brightness = 0.5,
    .recently_switched_algo = true,
    .algos =
        {
            .count = 0,
            .selected = 0,
        },
    .flags =
        {
            .tx_in_progress = false,
            .paused = false,
        },
};

void init_girlanda_SPI() {
  SSP_InitTypeDef SPI_init_struct;
  PORT_InitTypeDef GPIOInitStruct;
  // Включение тактирования
  RST_CLK_PCLKcmd( RST_CLK_PCLK_SSP2, ENABLE );
  RST_CLK_PCLKcmd( RST_CLK_PCLK_PORTD, ENABLE );
  // инициализация пинов
  GPIOInitStruct.PORT_PULL_UP = PORT_PULL_UP_OFF;
  GPIOInitStruct.PORT_PULL_DOWN = PORT_PULL_DOWN_ON;
  GPIOInitStruct.PORT_PD_SHM = PORT_PD_SHM_OFF;
  GPIOInitStruct.PORT_PD = PORT_PD_DRIVER;
  GPIOInitStruct.PORT_GFEN = PORT_GFEN_OFF;
  GPIOInitStruct.PORT_SPEED = PORT_SPEED_MAXFAST;
  GPIOInitStruct.PORT_MODE = PORT_MODE_DIGITAL;
  GPIOInitStruct.PORT_FUNC = PORT_FUNC_ALTER;
  GPIOInitStruct.PORT_Pin = ( PORT_Pin_5 | PORT_Pin_6 );
  PORT_Init( MDR_PORTD, &GPIOInitStruct );
  // инициализация SPI
  SSP_DeInit( MDR_SSP2 );
  SSP_BRGInit( MDR_SSP2, SSP_HCLKdiv2 );  // 40МГц
  SSP_StructInit( &SPI_init_struct );
  SPI_init_struct.SSP_SCR = 2;      // второй делитель F_SSPCLK / ( CPSDVR * (1 + SCR) )
  SPI_init_struct.SSP_CPSDVSR = 2;  // третий делитель (четное число)
  SPI_init_struct.SSP_Mode = SSP_ModeMaster;
  SPI_init_struct.SSP_WordLength = SSP_WordLength8b;
  SPI_init_struct.SSP_FRF = SSP_FRF_SPI_Motorola;  // режим ssi или spi
  SPI_init_struct.SSP_HardwareFlowControl = SSP_HardwareFlowControl_None;
  SSP_Init( MDR_SSP2, &SPI_init_struct );
  SSP_Cmd( MDR_SSP2, ENABLE );
}

static void convert_pixels_for_spi( pixel_t* pix, uint8_t* result ) {
  /* Превращаю каждый битик в отдельный байтик, который кидается на SPI.
     ноликам соответствует 0C, единицам 0F. */
  uint8_t temp;
  for ( uint16_t led_ind = 0; led_ind < LEDS_NUMBER; led_ind++ ) {
    for ( uint8_t color_ind = 0; color_ind < 3; color_ind++ ) {
      temp = *( ( (uint8_t*) ( &pix[led_ind] ) ) + color_ind );
      int j = 7;
      while ( j >= 0 ) {
        *result = ( ( temp >> j ) & 0x1 ) ? ONE : ZERO;
        result++;
        j--;
      }
    }
  }
}

void register_alg( void func( pixel_t* pix ) ) {
  if ( state.algos.count < MAX_ALGOS ) {
    state.algos.funcs[state.algos.count] = func;
    state.algos.count++;
  }
}

void send_pixels() {
  convert_pixels_for_spi( pixels, tx_arr );
  for ( uint32_t i = 0; i < LEDS_NUMBER * 24; i++ ) {
    while ( state.flags.tx_in_progress ) {
    };  // ждём, если надо
    while ( !( MDR_SSP2->SR & SSP_FLAG_TFE ) ) {
    };
    SSP_SendData( MDR_SSP2, tx_arr[i] );
    state.flags.tx_in_progress = false;
  }
}

// extern uint32_t _h_seed;
int init_girland() {
  init_girlanda_SPI();
  init_girlanda_RNG();
  // _h_seed = 123123;

  memset( pixels, 0, sizeof( pixels ) );
  state.recently_switched_algo = true;
  return 0;
}
