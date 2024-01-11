ENTRY(_start) /* this is the program entry point*/
OUTPUT_FORMAT(binary) /*our kernel is basic and will output as binary file */
SECTIONS
{
    . = 1M; /* kernel will be loaded at 1MByte address in mem*/
    .text :
    {
        *(.text)
    }

    .rodata :
    {
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss : 
    {
        *(COMMMON)
        *(.bss)
    }
}