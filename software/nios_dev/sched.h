/*
 * Copyright (c) 2016 Ji Dong < ji.dong@hotmail.co.uk >
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*
 * sched.h
 *
 *  Created on: 12 Dec 2016
 *      Author: ji.dong
 */


#ifndef SCHED_H_
#define SCHED_H_

#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
#include "sys/alt_irq.h"

/***************************************
 *  Special
 ****************************************/
/* Include the port_asm.S file where the Context saving/restoring is defined. */
//__asm__( "\n\t.globl    save_context" );

#define yield()             asm volatile ( "trap" );
#define ENTER_CRITICAL()    alt_irq_disable_all()
#define EXIT_CRITICAL()     alt_irq_enable_all( 0x01 );

/***************************************
 *  Structure and Typedefine for Task
 ****************************************/
typedef struct sTaskBlockControl sTaskBlockControl_t;
typedef int (*TaskFunction_t)(void * par);

struct sTaskBlockControl
{
    volatile uint32_t    *pTopOfStack;
    uint32_t             Stack[256];

    uint8_t              Index;
    uint8_t              Status;
    uint8_t              Reserved[2];

};
/***************************************
 *  Timer Prototype
 ****************************************/
void StartSchedTimer(void);

void TaskContextSwitch( void );

void * CreateStaticTask( uint8_t index,
                         TaskFunction_t tsk,
                         void * const Parameters);
uint32_t StartScheduler( void );

#ifdef __cplusplus
}
#endif

#endif /* SCHED_H_ */
