org 0x8000

;welcome_msg dw 11
;db 'Welcome to $'

mov dx, 0 
mov bx, 0 
mov cx, 0 
mov ax, 0
mov di, 0
    
call clear_screen

start_os:
call clean_buffer
mov dx, 0 
mov bx, 0 
mov cx, 0 
mov ax, 0
mov di, 0
mov [buf_pos], ax

;call test_cmp
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

print_string_color:
    mov ah, 0x02
    mov dx, di
    int 0x10

    lodsb
    cmp al, '$'
    je welcome2
    
    mov ah, 09h 
    mov bl, RED 
    mov cx, 1
    int 10h 
    inc di 
    jmp print_string_color

type_char:

    xor ah, ah
    int 16h 

    cmp ah, 0x0e 
    je  backspace

    cmp ah, 0x1c
    je  handle_enter

    mov di, buffer
    mov bx, [buf_pos]
    add di, bx
    mov [di], al
    inc bx
    mov [buf_pos], bx

    mov ah, 0x0e
    int 10h
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
    mov ah, 0x03
    int 10h 

    mov ah, 0x02
    mov bh, 0
    dec dl
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
    inc dh 
    mov dl, 0
    int 10h
    jmp type_char

set_cursor_top_left:
    mov ah, 02h 
    mov dh, 0 
    int 10h
    ret


clean_buffer:
    push di 
    mov di, buffer
    xor cx, cx
    mov cx, 80 
    rep stosd 
    pop di 
    ret
    
welcome:
    xor si, si
    mov si, welcome_message
    add si, 2
    push si
    push ax
    push cx
    call print_string_color
    
welcome2:
    pop si 
    pop ax 
    pop cx
    call newline
    jmp start_os 

success:
    mov si, success_msg
    call print_string 
    ret

clear_screen:
    call set_cursor_top_left
   
    mov dx, 0 
    mov bx, 0 
    mov cx, 0 
    mov ax, 0
    mov di, 0

    mov ah, 09h
    mov al, ' '
    mov bl, BLACK 
    mov cx, 80 * 25 
    int 10h 

    call set_cursor_top_left
    
    call welcome

handle_enter:
    mov di, buffer
    mov bx, [buf_pos]
    add di, bx
    mov byte [di], 0

    mov si, buffer
    mov di, cmd_str
    mov cx, 8
    repe cmpsb
    jz cmd_ok

    mov si, buffer
    mov di, cmd_cls
    mov cx, 6
    repe cmpsb
    jz clear_screen   ; jmp cursor_enter 

cmd_fail:
    call newline
    call clean_buffer
    xor ax, ax
    mov [buf_pos], ax
    jmp type_char

cmd_ok:
    call newline
    mov si, ok_msg
    call print_string
    call newline
    call clean_buffer
    xor ax, ax
    mov [buf_pos], ax
    jmp type_char
newline:
    mov ah, 0x03
    int 10h

    mov ah, 02h 
    inc dh 
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

welcome_message  dw 18
                 db 'Welcome to our OS!$'

success_msg      dw 7
                 db 'success$'

ok_msg           dw 4
                 db 'okay$'

cmd_str db 'command',0
cmd_cls db 'clear',0

buffer    db 80 dup (0)
buf_pos   dw 0   

RED = 4
BLACK = 7

times 512 - ( $ - $$ ) db 0 
