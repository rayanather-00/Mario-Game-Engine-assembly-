section .data.                                                                  ;pre defined section by assembler for data
   ;tiles
    %include "brick.inc"
    %include "brksnw.inc"
    %include "coin.inc"
    %include "ques.inc"
    %include "ques_snw.inc"
    %include "pipeTop.inc"
    %include "pipeBot.inc"
    %include "stair.inc"
    %include "grass.inc"
    %include "flagTop.inc"
    %include "flagBot.inc"
    %include "emptyQue.inc"
    %include "castleUp.inc"
    %include "castleTp.inc"


    ;characters
    %include "mario.inc"
    %include "mariospr.inc"
    %include "santa.inc"
    %include "santaspr.inc"
    %include "bat.inc"
    %include "bat_j.inc"
    %include "dino.inc"
    %include "dino_elf.inc"
    %include "dino_cry.inc"
    %include "dinoec.inc"
    %include "turtle.inc"
    %include "trtlsnw.inc"
    %include "shroom.inc"
    %include "shrmelf.inc"
    %include "shell.inc"
    %include "shellsnw.inc"




    ;maps
    %include "tileMap1.inc"

    ;data
    map_cols  equ 60          ;faster than declaring variable as constant, simply places value where in code
    map_rows equ 12
    map_size  equ 720   
    orig_map  equ tile_Map    ;duplicate map
    work_map: times 720 db 0     ;map we will be using
    frame_segment: dw 0
    last_tick: dw 0
    cam_col: dw 0
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------



functions:

;------------------------------
sky_palette:
    mov dx, 03C8h
    mov al, 250 ;index 250 is used for our sky color
    out dx, al

    color_sky:
        inc dx
        mov al, 46
        out dx, al
        mov al, 63
        out dx, al
        mov al, 60
        out dx, al
        ret

;------------------------------

draw_map:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov ax, [bp+4]
    cmp ax, map_cols-20
    jbe .valid
    mov ax, map_cols-20

.valid:
    mov si, work_map
    add si, ax

    mov di, map_rows
    mov dx, 8

.row_loop:
    xor bx, bx
    mov cx, 20

.col_loop:
    xor ah, ah
    mov al, [si]

    push dx
    push bx
    push ax
    call DrawTile
    add sp, 6

    inc si
    add bx, 16
    loop .col_loop

    add si, 40
    add dx, 16
    dec di
    jnz .row_loop

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

;------------------------------
  
make_segment:
    push ax
    push bx
    push es

    push cs
    pop es
    mov ah, 4Ah
    mov bx, 1000h
    int 21h

    mov ah, 48h
    mov bx, 1000h
    int 21h
    jnc .got_seg

    mov ax, cs
    add ax, 1000h

.got_seg:
    mov [frame_segment], ax
    pop es
    pop bx
    pop ax
    ret

    wait_tick:  
        push ax
        push es
        mov ax, 0040h
        mov es, ax

    .loop_tick:
        mov ax, [es:006Ch]
        cmp ax, [last_tick]
        je .loop_tick
        mov [last_tick], ax
        pop es
        pop ax
        ret



;------------------------------

get_tile:
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    push si

    mov ax, [bp+4]
    cmp ax, 0
    jl .oob
    cmp ax, map_rows * 16
    jge .oob
    shr ax, 4
    mov cx, ax

    mov ax, [bp+6]
    cmp ax, 0
    jl .oob
    cmp ax, map_cols * 16
    jge .oob
    shr ax, 4
    mov si, ax

    mov ax, cx
    mov dx, map_cols
    mul dx
    add si, ax

    mov bx, work_map
    mov al, [bx + si]
    jmp .done

.oob:
    xor al, al

.done:
    pop si
    pop dx
    pop cx
    pop bx
    pop bp
    ret

;------------------------------

DrawTile:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si

    mov al, [bp+4]
    mov bx, [bp+6]
    mov dx, [bp+8]

    cmp al, 0
    jne not_zero                               
    jmp near exit_draw

not_zero:
    cmp al, 1                              
    jne .chk_stair
    mov si, grass_block
    call draw_16x16
    jmp near exit_draw

.chk_stair:
    cmp al, 2                              
    jne .chk_coin
    mov si, Stair_block
    call draw_16x16
    jmp near exit_draw

.chk_coin:
    cmp al, 3                            
    jne .chk_ques
    mov si, coin
    call draw_16x16
    jmp near exit_draw

.chk_ques:
    cmp al, 4                              
    jne .chk_brick
    mov si, question
    call draw_16x16
    jmp near exit_draw

.chk_brick:
    cmp al, 5                             
    jne .chk_pipe
    mov si, brick
    call draw_16x16
    jmp near exit_draw

.chk_pipe:
    cmp al, 6                            
    jne .chk_castle_bot
    mov si, pipe_Bottom
    call draw_16x16
    jmp near exit_draw

.chk_castle_bot:
    cmp al, 7                              
    jne .chk_castle_top
    mov si, castle_Bottom
    call draw_16x16
    jmp near exit_draw

.chk_castle_top:
    cmp al, 8                               
    jne .chk_flag
    mov si, castle_Top
    call draw_16x16
    jmp near exit_draw

.chk_flag:
    cmp al, 9                              
    jne .chk_gate
    mov si, flag_Bottom
    call draw_16x16
    jmp near exit_draw

.chk_gate:
    cmp al, 10
    je .is10                             
    jmp near exit_draw
    .is10:
        push ax
        push di
        push bp
        mov ax, 320
        mul dx
        add ax, bx
        mov di, ax
        mov bp, 16
        xor al, al
        cld
.gate_row:
    mov cx, 16
    rep stosb
    add di, 320 - 16
    dec bp
    jnz .gate_row
    pop bp
    pop di
    pop ax

exit_draw:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
    

;------------------------------

map_reset:
    push ax
    push cx
    push si
    push di
    push es

    push ds
    pop es

    mov si, orig_map
    mov di, work_map
    mov cx, map_size
    cld
    rep movsb

    pop es
    pop di
    pop si
    pop cx
    pop ax
    ret

;------------------------------

draw_16x16:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    mov bp, 16
    cld
.row_loop:
    push dx
    mov ax, 320
    mul dx
    add ax, bx
    mov di, ax
    pop dx

    mov cx, 16
.col_loop:
    lodsb
    test al, al
    jz .skip_pixel
    mov [es:di], al
.skip_pixel:
    inc di
    loop .col_loop

    inc dx
    dec bp
    jnz .row_loop

    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret



;------------------------------

draw_16x32:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    mov bp, 32
    cld
.row_loop:
    push dx
    mov ax, 320
    mul dx
    add ax, bx
    mov di, ax
    pop dx

    mov cx, 16
.col_loop:
    lodsb
    test al, al
    jz .skip_pixel
    mov [es:di], al
.skip_pixel:
    inc di
    loop .col_loop

    inc dx
    dec bp
    jnz .row_loop

    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

prog_end: