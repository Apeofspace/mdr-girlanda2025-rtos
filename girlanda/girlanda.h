#ifndef __GIRLANDA_H
#define __GIRLANDA_H

#include "definitions.h"

/* Публичные функции здесь */
void send_pixels();
void register_alg(void func(pixel_t *pix));
int init_girland();

/* Алгоритмы здесь */
void breath_colors(pixel_t *pix);
void breath_colors2(pixel_t *pix);
void danger_noodle(pixel_t *pix);
void two_noodles(pixel_t *pix);


#endif
