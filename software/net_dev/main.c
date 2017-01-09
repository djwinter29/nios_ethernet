/*
 * main.c
 *
 *  Created on: 9 Dec 2016
 *      Author: ji.dong
 */

#include <stdio.h>
#include <string.h>
#include <io.h>
#include <priv/alt_busy_sleep.h>
#include <sys/alt_irq.h>
#include <sys/alt_cache.h>
#include "sched.h"

static volatile int taskedcount1 = 0;
static volatile int taskedcount2 = 0;

int Task1(void * test)
{
    while (1)
    {
        alt_busy_sleep(1000000);
        printf("Hello from Task1  %d!\n",  taskedcount1++);
    }

    return 0;
}

int Task2(void * test)
{
    while (1)
    {
        alt_busy_sleep(1000000);
        printf("Hello from Task2  %d!\n",  taskedcount2++);
    }

    return 0;
}


volatile alt_u16 * from = (volatile alt_u16 *) (ENET_ENET_DMA_BASE);
volatile alt_u16 * to = (volatile alt_u16 *) (ENET_ENET_DMA_BASE + 8);

int main()
{
    //IOWR_16DIRECT(ENET_ENET_DMA_BASE, 0, 1000);
    //IOWR_16DIRECT(ENET_ENET_DMA_BASE, 1, 1001);
    //*((volatile alt_u16 *) (ENET_ENET_DMA_BASE)) = 1000;

    //alt_dcache_flush_all();
    //*(from+1) = 2;

    //*(to++) = *(from++);
    //*(to++) = *(from++);


    /*
    alt_u32 r32;
    alt_u16 r16;
    alt_u8 r8;
//    printf("Hello from Main!\n");
    r32 = IORD_32DIRECT(ENET_ENET_DMA_BASE, 0);
    r32 = IORD_32DIRECT(ENET_ENET_DMA_BASE, 4);
    IOWR_32DIRECT(ENET_ENET_DMA_BASE, 0, r32);
    IOWR_32DIRECT(ENET_ENET_DMA_BASE, 4, r32);

    r16 = IORD_16DIRECT(ENET_ENET_DMA_BASE, 0);
    r16 = IORD_16DIRECT(ENET_ENET_DMA_BASE, 1);
    IOWR_16DIRECT(ENET_ENET_DMA_BASE, 0, r16);
    IOWR_16DIRECT(ENET_ENET_DMA_BASE, 1, r16);

    r8 = IORD_8DIRECT(ENET_ENET_DMA_BASE, 0);
    r8 = IORD_8DIRECT(ENET_ENET_DMA_BASE, 1);
    IOWR_8DIRECT(ENET_ENET_DMA_BASE, 0, r8);
    IOWR_8DIRECT(ENET_ENET_DMA_BASE, 1, r8);
    */
    memcpy((void*)(ENET_ENET_DMA_BASE+9), (void*)(ENET_ENET_DMA_BASE), 4);

    memcpy((void*)(ENET_ENET_DMA_BASE+8), (void*)(ENET_ENET_DMA_BASE), 2);

    memcpy((void*)(ENET_ENET_DMA_BASE+8), (void*)(ENET_ENET_DMA_BASE), 4);



    memcpy((void*)(ENET_ENET_DMA_BASE+1), (void*)(ENET_ENET_DMA_BASE+8), 4);
    memcpy((void*)(ENET_ENET_DMA_BASE+1), (void*)(ENET_ENET_DMA_BASE+8), 4);


    /*

    CreateStaticTask(0, Task1, NULL);
    CreateStaticTask(1, Task2, NULL);

    alt_irq_context status = alt_irq_disable_all ();
    StartSchedTimer();
    alt_irq_enable_all(status);

    StartScheduler();
    */
    return 0;
}
