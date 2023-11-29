ORG 0x7c00
BITS 16

start:
    mov si, message
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

message: db 'Hello World!',0
times 510-($ - $$) db 0
dw 0xAA55 