ORG 100H
JMP START
%include "constant.inc"
%include "data.asm"
%include "graphics.asm"
%include "keyboard.asm"
%include "speed.asm"
%include "vertical.asm"
START:
    CALL make_segment
    MOV AX, 0013H
    INT 10H
    CALL sky_palette
    CALL map_reset
    CALL INSTALL_KEYBOARD

GAME_LOOP:
    CALL wait_tick
    CMP BYTE [ESC_KEY], 1
    JE EXIT_GAME
    ; UPDATE PLAYER
    CALL UPDATE_PLAYER_FRAME
    ; CLEAR OFFSCREEN BUFFER
    MOV AX, [frame_segment]
    MOV ES, AX
    XOR DI, DI
    MOV CX, 32000
    MOV AH, 250
    MOV AL, 250
    CLD
    REP STOSW
    ; DRAW MAP
    PUSH WORD [cam_col]
    CALL draw_map
    ADD SP, 2
    ; DRAW MARIO
    MOV SI, mario
    ; GET MARIO PIXEL POSITION
    MOV BX, [MARIO_X]
    MOV DX, [MARIO_Y]

    CALL draw_16x16

    ; COPY OFFSCREEN BUFFER TO VIDEO MEMORY
    PUSH DS

    MOV AX, [frame_segment]
    MOV DS, AX

    XOR SI, SI

    MOV AX, 0A000H
    MOV ES, AX

    XOR DI, DI
    MOV CX, 32000

    CLD
    REP MOVSW

    POP DS

    JMP GAME_LOOP

EXIT_GAME:

    CALL UNINSTALL_KEYBOARD

    MOV AX, 0003H
    INT 10H

    MOV AX, 4C00H
    INT 21H
