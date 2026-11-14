; these are varibbles which will be chnaging throughout the game

; mario postion tracking
MARIO_X  DW 0200H  ; x postion
MARIO_Y  DW 0A00H  ; y postion

; for the velocity
VELOCITY_X  DW 0000H ; Horizontal velocity
VELOCITY_Y  DW 0000H ; Vertical velocity
CURRENT_MAX_SPEED DW 0200H

; these are bools; keeping track on where the mario is

ON_GROUND   DB 0  ; 1 = Mario on ground, 0 = airborne
FACING_DIRECTION  DB 1  ; 0 = Left DIRECTION, 1 = Right DIRECTION
IS_RUNNING  DB 0  ; 1 = Running, 0 = Walking
LEFT_KEY   DB 0  ; 1 = Left key pressed
RIGHT_KEY  DB 0  ; 1 = Right key pressed
SHIFT_KEY  DB 0  ; 1 = Left Shift pressed
SPACE_KEY  DB 0  ; 1 = Space pressed

; to track if the mario is jumping connstaly or not...
JUMP_HELDING       DB 0            ; Tracks whether Space is being held
