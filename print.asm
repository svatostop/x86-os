org 0x8000

;welcome_msg dw 11
;db 'Welcome to $'

mov dx, 0 
mov bx, 0 
mov cx, 0 
mov ax, 0

call welcome

jmp type_char

print_string:
    push ax
    push cx
    push si
    mov cx, word [si]
    add si, 2
        .str_loop:
            lodsb
            mov ah, 0eh
            int 10h 
        loop .str_loop
    pop si
    pop cx
    pop ax
    ret

type_char:
    xor cx, cx
    mov ah, 0x00
    int 16h 
    
    ; add char from al to the first buf position
    mov di, buffer
    mov byte [di], al
    inc di
    mov byte [di], '$'
    
    cmp ah, 0x0e
    je backspace

    cmp ah, 0x1c 
    je cursor_enter

    mov ah, 0eh
    int 10h

    ; print first char from buffer
    call print_buffer

    jmp type_char

print_buffer:
    push ax
    mov di, buffer
    mov al, [di] 
    mov ah, 0eh
    int 10h
    pop ax
    ret

backspace:
    mov ah, 0x03 ; get cursor
    int 10h 

    mov ah, 0x02 ; set cursor
    mov bh, 0
    dec dl ; dx stores row and columns from prev instruction, we erase char
    int 0x10

    mov ah, 0x0e
    mov al, ' ' 
    int 0x10

    mov ah, 0x02
    mov bh, 0
    int 0x10

    jmp type_char 

cursor_enter:
    mov ah, 0x03
    int 10h 

    mov ah, 02h 
    inc dh ; dx stores r/c from prev int, we put cursor to new line
    mov dl, 0
    int 10h
    jmp type_char

welcome:
    mov si, welcome_message
    call print_string
    ; new line
    mov ah, 0x03
    int 10h 

    mov ah, 02h 
    inc dh ; dx stores r/c from prev int, we put cursor to new line
    mov dl, 0
    int 10h

    ret

; checking key for ESC press and if yes -> prints hello world
check_key:
    mov ah, 0x00 
    int 16h 

    cmp ah, 0x01
    jne check_key
   
    ;mov si, message
    ;call print_string
    jmp check_key

; data -------------------------------
welcome_message dw 46
db 'Welcome to our OS! You can type anything here.$'

buffer db 80 dup (?)

times 512 - ( $ - $$ ) db 0 
