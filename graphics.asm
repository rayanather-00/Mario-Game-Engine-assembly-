org 0x0100

section .data.                                                                  ;pre defined section by assembler for data
    map: db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1          ;to be extended to 60 memebers, this prints the dirt and tells where gaps

section .text.                                                                  ;pre defined section by assembler for code

mov ax, 0013h                                                                   ;vga mode
int 10h

;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------

color_palettes:

    sky_palette:
        mov dx, 03C8h                
        mov al, 1                                                                ; palette index 1 reserved for our sky color
        out dx, al

        color_sky:                                                               ;this is for overwriting palette index 1 for it to be color code #BAFFEF
            inc dx                                                   
            mov al, 46                                                              
            out dx, al
            mov al, 63                   
            out dx, al
            mov al, 60                   
            out dx, al

    dirt_palette:
       mov dx, 03C8h
       mov al, 2
       out dx, al

       color_dirt:                                                               ;color #411000 
            inc dx                          
            mov al, 16                      
            out dx, al
            mov al, 4                       
            out dx, al
            mov al, 0                       
            out dx, al   

    grass_palette:
        mov dx, 03C8h
        mov al, 3
        out dx, al

        color_grass:                                                            ;color #22ff42
            inc dx
            mov al, 8                       
            out dx, al
            mov al, 63                      
            out dx, al
            mov al, 16                      
            out dx, al                            


;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------

sky:
    

    fill:
        mov ax, 0A000h
        mov es, ax                                                              ;es is segment register, pointing to vga memory which allows us to color pixel by pixel for clouds etc

        cld                          
        xor di, di                                                              ;ensures di is 0, note that its faster than mov, use it
        mov cx, 64000                
        mov al, 1                   
        rep stosb                                                               ;what this does is take the color in al and apply it cx many times using di address which is 0 and cx is the entire window hence full background colored

map_check:
    mov si, map
    mov cx, 20                                                                  ;20 columns of 16x16 blocks which will span the 320 pixel width
    xor bx, bx
    
    map_loop:                                                                   ;builds the map, 1 indicates to draw dirt while 0 indicates to skip
        mov al, [si]
        cmp al, 1
        jne dirt_skip
        mov dx, 184 
        call draw_dirt
        mov dx, 176
        call draw_grass

    dirt_skip:
        inc si
        add bx, 16
        loop map_loop 

mario:
    mov bx, 32                    
    mov dx, 160                     
    mov al, 4                       
    call draw_mario
     
terminate:
    mov ah, 00h
    int 16h

    mov ax, 0003h
    int 10h

    mov ax, 4C00h
    int 21h


;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------

functions:

    draw_dirt:    
        push ax                                                                  ;saves all initial values
        push bx
        push cx
        push dx
        push di

        mov ax, 320                                                              ;this basicaly calculates what pixel are we on and where we drawing, dx*320 +bx where bx keeps tab on how much we have done
        mul dx
        add ax, bx
        mov di, ax

        mov dx, 16
        mov al, 2                                                                ;al contains the color of dirt

        dirt_loop:
            mov cx, 16
            rep stosb
            add di, 304                                                          ;now we add 304 since we just drew 16 pixels in a row now we need to go down a row and continue that to maintain 16x16 which is done by adding the remaining distance until it goes down

            dec dx
            jnz dirt_loop

            pop di
            pop dx
            pop cx
            pop bx
            pop ax
            ret
    

    draw_mario:                                                                 ;as you can see this fucntion is the same as dirt loop except color, this is just a placeholder sicne later we actually have to make mario block
        push ax
        push bx
        push cx
        push dx
        push di

        mov ax, 320                                            
        mul dx
        add ax, bx
        mov di, ax

        mov dx, 16                                           
        mov al, 4                                               

        mario_loop:
            mov cx, 16                                              
            rep stosb                                              
            add di, 304                                           

            dec dx
            jnz mario_loop

            pop di
            pop dx
            pop cx
            pop bx
            pop ax
            ret

    draw_grass:
        push ax
        push bx
        push cx
        push dx
        push di

        mov ax, 320
        mul dx
        add ax, bx
        mov di, ax

        mov dx, 8
        mov al, 3

        grass_loop:
            mov cx, 16                                              
            rep stosb                                              
            add di, 304                                           

            dec dx
            jnz grass_loop

            pop di
            pop dx
            pop cx
            pop bx
            pop ax
            ret


