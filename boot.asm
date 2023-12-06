ORG 0x7C00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start ; these will give the offset 0x08, 0x10 etc


_start:
    jmp short start
    nop
times 33 db 0 ;create 33 bytes after short jump for bios parameterblock

start:
    jmp 0:step2 ; makes code segment become 0x7c0



step2:
    cli ; Clear interrupts - we are about to change segment regisrters so dont
         ; want hardware to interrupt
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; enable interrupts

.load_protected:
    cli
    lgdt[gdt_descriptor] ;find size and offset , load gdt table
    mov eax,cr0
    or eax,0x1
    mov cr0,eax ;reset register
    jmp CODE_SEG:load32 ;switches to codes selector, jumpts to load 32 absolute address

; GDT below 
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0 ;64 bits of 0s

;offset 0x8
gdt_code:      ; CS should point to this
    dw 0xFFFF ;Segment legment 0-15 bits
    dw 0       ; base first 8-15 bits
    dw 0       ; base 16-23 bits
    db 0x9a     ; access byte 
    db 11001111b ; high 4 bit flags and low 4 bit flags
    db 0        ; base 24-31 bits
;offset 0x10
gdt_data:      ; DS,SS,ES,FS,GS
    dw 0xFFFF ;Segment legment 0-15 bits
    dw 0       ; base first 8-15 bits
    dw 0       ; base 16-23 bits
    db 0x92     ; access byte 
    db 11001111b ; high 4 bit flags and low 4 bit flags
    db 0        ; base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start -1 ;this is how we get the size
    dd gdt_start

[BITS 32] ;all code underneath seen as 32 bit code

load32:
;set our data registers
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000 ;set base pointer to point to  0x002
    mov esp, ebp 
    jmp $


times 510-($ - $$) db 0
dw 0xAA55 
