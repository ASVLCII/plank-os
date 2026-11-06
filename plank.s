.code16
.text
.set load_address, 0x7c00

boot:
    cli
    xorw %ax, %ax
    movw %ax, %ss
    movw $load_address, %sp
    movw %ax, %ds
    sti

clear:
    movw $0x0003, %ax            # BIOS: set 80x25 text mode and clear
    int $0x10
    movw $load_address + banner - boot, %si

print:
    cld
    lodsb
    testb %al, %al
    jz read_key
    call put_char
    jmp print

read_key:
    xorb %ah, %ah               # BIOS: wait for a key
    int $0x16
    cmpb $'?', %al
    je help
    cmpb $12, %al                # Ctrl+L
    je clear
    cmpb $27, %al                # Esc
    je halt
    cmpb $13, %al
    je newline
    cmpb $32, %al
    jb read_key
    cmpb $126, %al
    ja read_key
    call put_char
    jmp read_key

help:
    movw $load_address + help_text - boot, %si
    jmp print

newline:
    call put_char                # AL is already carriage return
    movb $10, %al
    call put_char
    jmp read_key

halt:
    cli
    hlt
    jmp halt

put_char:
    movb $0x0e, %ah             # BIOS: teletype output on page zero
    xorw %bx, %bx
    int $0x10
    ret

banner:
    .asciz "Plank OS  [?] Help\r\n"
help_text:
    .asciz "\r\nType to echo | Ctrl+L clear | Esc halt\r\n"

payload_end:
    .org 510
    .word 0xaa55
