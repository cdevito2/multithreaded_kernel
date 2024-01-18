ENTRY(_start) /* this is the program entry point*/
OUTPUT_FORMAT(binary) /*our kernel is basic and will output as binary file */
SECTIONS
{
    . = 1M; /* kernel will be loaded at 1MByte address in mem*/
    .text : ALIGN(4096) /* everything in text section alligned by 16 bytes*/
    {
        *(.text)
    }

    .rodata : ALIGN(4096)
    {
        *(.rodata)
    }

    .data : ALIGN(4096)
    {
        *(.data)
    }

    .bss : ALIGN(4096)
    {
        *(COMMMON)
        *(.bss)
    }

    .asm : ALIGN(4096)
    {
        *(.asm)
    }
}