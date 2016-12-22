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
 * task.c
 *
 *  Created on: 13 Dec 2016
 *      Author: ji.dong
 */
#include "sched.h"

#define MAX_TASK_COUNT      2
static sTaskBlockControl_t TaskControlBlock[MAX_TASK_COUNT];
sTaskBlockControl_t * pCurrentTCB = TaskControlBlock;


static void ReadGp( uint32_t *ulValue )
{
    asm( "stw gp, (%0)" :: "r"(ulValue) );
}

static uint32_t * InitialiseTaskStack( uint32_t * topOfStack,
                                       TaskFunction_t tsk,
                                       void * para);




void * CreateStaticTask( uint8_t index,
                         TaskFunction_t tsk,
                         void * const Parameters)
{
    if (index >= MAX_TASK_COUNT)
        return NULL;

    sTaskBlockControl_t * tcb = &TaskControlBlock[index];


    tcb->Status = 0;
    tcb->Index = index;
    tcb->pTopOfStack = InitialiseTaskStack((uint32_t *)&tcb->Stack[255],
                                           tsk,
                                           Parameters);


    return tcb;
}



uint32_t * InitialiseTaskStack( uint32_t * topOfStack,
                                TaskFunction_t tsk,
                                void * para)
{
    uint32_t *pFram = topOfStack - 1;
    uint32_t GPointer;
    ReadGp(&GPointer);

    *topOfStack = 0xdeadbeef;
    topOfStack--;

    *topOfStack = (uint32_t)pFram;
    topOfStack--;

    *topOfStack = GPointer;

    /* Space for R23 to R16. */
    topOfStack -= 9;

    *topOfStack = (uint32_t) tsk;
    topOfStack--;

    /* Interrupts are enabled */
    *topOfStack = 0x01;

    /* Space for R15 to R5. */
    topOfStack -= 12;

    *topOfStack = (uint32_t)para;

    /* Space for R3 to R1, muldiv and RA. */
    topOfStack -= 5;

    return topOfStack;
}


uint32_t StartScheduler( void )
{
    asm volatile (  " movia r2, restore_sp_from_pCurrentTCB        \n"
                    " jmp r2                                          " );
    /* Should not get here! */
    return 0;
}

void TaskContextSwitch( void )
{
    if (pCurrentTCB->Index < (MAX_TASK_COUNT - 1))
    {
        pCurrentTCB = &TaskControlBlock[pCurrentTCB->Index + 1];
    }
    else
    {
        pCurrentTCB = & TaskControlBlock[0];
    }
}





