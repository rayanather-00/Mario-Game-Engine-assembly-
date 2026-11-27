WALK_ACCEL          EQU 0020H  ; 0.125 accelearation (pixels per frame)
MAX_WALK_SPEED      EQU 0200H  ; 2 pixels per frame (THIS IS MAX SPEED CAN'T GO UP THIS)
MAX_RUN_SPEED       EQU 0300H  ; 3 pixels per frame (SAME AS ABOVE)
FRICTION            EQU 0040H ; friction while moving
BRAKE_ACCEL         EQU 0040H  ; PRESS OPPSOTE KEY THEN THIS ACC WILL APPLY
;these for the friction while jumping
JUMP_VELOCITY  EQU 0FA80H  ; -5.5 pixels per frame
JUMP_CUTOFF    EQU 0FE00H  ; -2 pixels per frame
GRAVITY        EQU 0040H   ; 0.25 pixels per frame²
MAX_FALL_SPEED EQU 0500H   ; 5 pixels per frame

SCREEN_WIDTH EQU 320
TILE_SIZE    EQU 16