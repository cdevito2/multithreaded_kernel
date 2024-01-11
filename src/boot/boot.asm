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
    dw 0xffff ;Segment legment 0-15 bits
    dw 0       ; base first 8-15 bits
    dw 0       ; base 16-23 bits
    db 0x9a     ; access byte 
    db 11001111b ; high 4 bit flags and low 4 bit flags
    db 0        ; base 24-31 bits
;offset 0x10
gdt_data:      ; DS,SS,ES,FS,GS
    dw 0xffff ;Segment legment 0-15 bits
    dw 0       ; base first 8-15 bits
    dw 0       ; base 16-23 bits
    db 0x92    ; access byte 
    db 11001111b ; high 4 bit flags and low 4 bit flags
    db 0        ; base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start -1 ;this is how we get the size
    dd gdt_start

[BITS 32]
load32:
    ;load kernel into memory and jump to is
    mov eax,1 ;starting sector to load from (0 is boat sector)
    mov ecx,100 ;writing 100 secotrs of null - contains total sectors to load
    mov edi,0x0100000 ;equiv of 1 MB - address to load them into
    call ata_lba_read ;this will talk with the driver and load sectors into memory
    jmp CODE_SEG:0x0100000

ata_lba_read:
    mov ebx, eax ; backup LBA
    ; send highest 8 bits of lba to hard disk controller
    shr eax, 24 ; shift eax reg 24 bits to the right meaning that eax contains 
                ; highest 8 bits
    or eax, 0xE0; sekect the master drive
    mov dx, 0x1F6
    out dx, al  ; al contains highest 8 bits of lba so its finished

    ; send total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx,al
    ; finished sending total sectors to read

    ;send more bits of the lba
    mov eax, ebx ; restors the backup LBA
    mov dx, 0x1F3
    out dx,al
    ; finished sending more bits of the LBA

    ; send more bits of the lba
    mov dx, 0x1F4
    mov eax, ebx ; restore backup LBA
    shr eax, 8
    out dx,al
    ;finished sending more bits of the LBA

    ;send uper 16 bits of lba
    mov dx, 0x1F5
    mov eax, ebx
    shr eax, 16
    out dx,al

    mov dx, 0x1f7
    mov al,0x20
    out dx,al

    ;read all sectors into memory

.next_sector:
    push ecx

;checking if we need to read

.try_again:
    mov dx, 0x1f7
    in al,dx
    test al, 8
    jz .try_again

; we need to read 256 words at a time
    mov ecx, 256
    mov dx, 0x1F0
    rep insw ;reads word from io port specified in dx into mem loc specified
             ; this is stored into edi 
             ; this reads one sector
    pop ecx
    loop .next_sector
    ;end of reading sectors into memory 
    ret 


times 510-($ - $$) db 0
dw 0xAA55 
