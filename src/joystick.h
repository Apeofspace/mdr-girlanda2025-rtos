#ifndef __JOYSTICK_H
#define __JOYSTICK_H

typedef enum { NOKEY = 0, SEL = 1, RIGHT = 2, LEFT = 3, UP = 4, DOWN = 5, MULTIPLE = 6, NUM_KEY_CODES } KeyCode;

void init_joystick( void );
KeyCode joystick_get_key_loop( void );

#endif
