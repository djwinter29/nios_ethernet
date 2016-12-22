/*
 * main.c
 *
 *  Created on: 9 Dec 2016
 *      Author: ji.dong
 */

#include <stdio.h>

#include <priv/alt_busy_sleep.h>
#include <sys/alt_irq.h>
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

int main()
{
//    printf("Hello from Main!\n");


    CreateStaticTask(0, Task1, NULL);
    CreateStaticTask(1, Task2, NULL);

    alt_irq_context status = alt_irq_disable_all ();
    StartSchedTimer();
    alt_irq_enable_all(status);

    StartScheduler();

    return 0;
}
