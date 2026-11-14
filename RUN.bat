@echo off
cd /d "%~dp0"

start "" "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe" -c "mount c c:\Users\Hp\Downloads\ASSEMBLY\mario_game_engine_assembly" -c "c:" -c "c:nasm mario.asm -o mario.com" -c "mario.com"

exit
