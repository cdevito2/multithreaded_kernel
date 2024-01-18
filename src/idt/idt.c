#include "idt.h"
#include "config.h"


struct idt_desc idt_descriptors[PEACHOS_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;


void idt_init()
{

}