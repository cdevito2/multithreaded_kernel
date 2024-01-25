#include "idt.h"
#include "config.h"
#include "kernel.h"
#include "../memory/memory.h"

struct idt_desc idt_descriptors[PEACHOS_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;

extern void idt_load(struct idtr_desc *ptr);

void idt_zero()
{
    print("Divide by zero error\n");
}


void idt_set(int interrupt_no, void *address)
{
    struct idt_desc *desc = &idt_descriptors[interrupt_no];

    desc->offset_1 = (uint32_t) address & 0x0000ffff; //bits 0->15
    desc->selector = KERNEL_CODE_SELECTOR; //bits 16..31
    desc->zero = 0x00; //bits 32..39
    desc->type_attr = 0xEE;    //first 4 bits are for gate, second 4 bits are for the other sections to set
    desc->offset_2 = (uint32_t) address >> 16;
}

void idt_init()
{
    memset(idt_descriptors, 0, sizeof(idt_descriptors));

    //idtr descript contains limit and base so init those
    idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
    //base is the base address of the idt_descriptors table
    idtr_descriptor.base = (uint32_t)idt_descriptors;

    idt_set(0, idt_zero);

    //load the interrupt descriptor table
    idt_load(&idtr_descriptor);
}