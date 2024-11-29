#ifndef __HELPERS_H
#define __HELPERS_H

#include "MDR32Fx.h"

#include "definitions.h"

#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

/* Переменные */

/* Таймер */
float get_delta_period(const uint32_t period);
float get_delta_steps(const float ms_per_step);

/* Пиксели */
void clear_pixels(pixel_t *pix);
void set_pix_color_arr(pixel_t *pix, const uint8_t *rgb);
void set_pix_color(pixel_t *pix, uint8_t r, uint8_t g, uint8_t b);
void copy_pix_color(pixel_t *pix_dest, pixel_t *pix_source );
void set_random_pixel_color(pixel_t *pix);
void glowing_sides(pixel_t *pix, uint16_t ind_left, uint16_t ind_right, uint16_t num_glowing_leds);
void glowing_gauss(pixel_t *pix, uint16_t ind_left, uint16_t ind_right, uint16_t max_leds, float dispersion);

/* RNG */
uint32_t random(uint32_t new_seed);
void init_girlanda_RNG();

#endif
