[org 0x7e00]

jmp EnterProtectedMode

%include "Sector1/includes/print.asm"
%include "Sector2+/includes/gdt.asm"

EnterProtectedMode:
    call EnableA20
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp codeseg:StartProtectedMode

EnableA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

[bits 32]

%include "Sector2+/includes/CPUID.asm"
%include "Sector2+/includes/page.asm"

StartProtectedMode:
    mov ax, dataseg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call DetectCPUID
    call DetectLongMode
    call SetupIdentityPaging
    call EditGDT
    jmp codeseg:Start64Bit

[bits 64]
[extern _start]

Start64Bit:
    mov rdi, 0xB8000
    mov rax, 0x1f201f201f201f20
    mov rcx, 500
    rep stosq

    mov [0xB8000], byte 'H'
    mov [0xB8002], byte 'e'
    mov [0xB8004], byte 'l'
    mov [0xB8006], byte 'l'
    mov [0xB8008], byte 'o'
    mov [0xB800A], byte ' '
    mov [0xB800C], byte 'a'
    mov [0xB800E], byte 'n'
    mov [0xB8010], byte 'd'
    mov [0xB8012], byte ' '
    mov [0xB8014], byte 'w'
    mov [0xB8016], byte 'e'
    mov [0xB8018], byte 'l'
    mov [0xB801A], byte 'c'
    mov [0xB801C], byte 'o'
    mov [0xB801E], byte 'm'
    mov [0xB8020], byte 'e'
    mov [0xB8022], byte ' '
    mov [0xB8024], byte 't'
    mov [0xB8026], byte 'o'
    mov [0xB8028], byte ' '
    mov [0xB802A], byte 'N'
    mov [0xB802C], byte 'e'
    mov [0xB802E], byte 'w'
    mov [0xB8030], byte ' '
    mov [0xB8032], byte 'T'
    mov [0xB8034], byte 'i'
    mov [0xB8036], byte 'm'
    mov [0xB8038], byte 'e'
    mov [0xB803A], byte 's'
    mov [0xB803C], byte ' '
    mov [0xB803E], byte 'O'
    mov [0xB8040], byte 'S'

    call _start
    jmp $

times 2048-($-$$) db 0
