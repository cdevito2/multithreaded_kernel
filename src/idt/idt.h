#ifndef __IDT_H__
#define __IDT_H__

#include <stdint.h>
/*struct for interrupt descriptor table descriptor */

struct idt_desc{
    uint16_t offset_1; //offset bits 0-15
    uint16_t selector; //selector in our GDT
    uint8_t zero; //does nothing so set to 0
    uint8_t type_attr; //descriptor type and attributes
    uint16_t offset_2; //offset bits 16-31

} __attribute__((packed));

struct idtr_desc{
    uint16_t limit; //size of descriptor table - 1
    uint32_t base; //base address at start of the IDT  

}__attribute__((packed));

void idt_init();

#endif