ORG 100H
JMP PROGRAMSS
%include "data.asm"
%include "assets.asm"
%include "graphics.asm"
%include "level.asm"
%include "keyboard.asm"
%include "timer.asm"
%include "player.asm"
%include "enemies.asm"
%include "collision.asm"
%include "game.asm"
%include "constant.inc"



PROGRAMSS:





MOV AH, 4CH
INT 21H