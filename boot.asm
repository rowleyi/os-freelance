org 0x7c00
bits 16

_start:
 jmp 0:_glEntryHandle
 .DriveNumber

align 16, db 0

_lcGDTStart:
  .null: dd 0, 0
  .kernel_code:
  .kernel_data:
  .user_code:
  .user_data:
  .tss:
_lcGDTEnd:

_glGDTHandle:
  dw (_lcGDTEnd - _lcGDTStart) - 1
  dd _lcGDTStart

_glEntryHandle:
  cli
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, _start
  mov bp, sp
  sti

  mov byte [_start.DriveNumber], dl

  mov ah, 0x41
  mov bx, 0x55aa
  clc
  int 0x13
  jc _lcErrorHandle

  cmp bx, word [_glLegacyBootSignature]
  jne _lcErrorHandle

  mov si, 0x0500
  mov word [si+0x00], 0x0042
  mov word [si+0x02], 0
  mov ah, 0x48
  mov dl, byte [_start.DriveNumber]
  clc
  int 0x13
  jc _lcErrorHandle

  

_lcErrorHandle:
  cli
  hlt
  jmp _lcErrorHandle

times 510-($-$$) db 0
_glLegacyBootSignature: dw 0xaa55
