ORG 0
BITS 16

_start:
    jmp short start
    nop
times 33 db 0 ;create 33 bytes after short jump for bios parameterblock

start:
    jmp 0x7c0:step2 ; makes code segment become 0x7c0



step2:
    cli ; Clear interrupts - we are about to change segment regisrters so dont
         ; want hardware to interrupt
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; enable interrupts

    mov ah, 2 ; Read Sector Command
    mov al, 1 ; One sector to read
    mov ch, 0 ; Cylinder low 8 bits
    mov cl,2  ; read sector 2
    mov dh,0  ; head number
    mov bx,buffer
    int 0x13
    jc error
    mov si, buffer
    call print
    jmp $
error:
    mov si, error_message
    call print
    jmp $

print:
    mov bx,0
.loop:
    lodsb ;load char that si is pointing to into al register, then increment si register
    cmp al,0 ;if al is equal to 0 jump to done as its end of string
    je .done
    call print_char ;we arent done with string so use interrupt to print to screen
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

error_message: db 'Failed to load sector',0

times 510-($ - $$) db 0
dw 0xAA55 

buffer: