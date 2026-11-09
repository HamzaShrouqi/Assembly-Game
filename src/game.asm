
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.stack 100

.data

welcome db "Welcome...", 0ah, 0dh, "Press a if player 1 is ready ;"

error db 0ah, 0dh, "Error", 0ah, 0dh, ';' 

welcome2 db 0ah, 0dh, "press ", 024, " if player 2 is ready ;"   

health db "Health * * * * *" , 0ah, 0dh 

wallBlocks db 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 0ah, ' ', 0ah, ' ', 0ah, 219,  219, 219, 219, 219, 219, 219, 219, 219, 219



.code

mov ax, @data
mov ds, ax

mov si, 0
                         
L1:                      ;Welcome player 1
mov dl, welcome[si]      
cmp dl, ";"
je L2
mov ah, 2
int 21h
inc si
loop L1
    
L2:                       ;input (a) from plater 1
mov ah, 1
int 21h
cmp al, 'a'
mov si, 0
je L3
mov cx, 9
mov si, 0
E:                        ;error massage
mov ah, 2
mov dl, error[si]
int 21h
inc si
loop E
jmp L2


L3:                       ;Welcome player 2
mov dl, welcome2[si]      
cmp dl, ";"
je L4
mov ah, 2
int 21h
inc si
loop L3

L4:                       ;input (a) from plater 1
mov ah, 0
int 16h
cmp ah, 048h
je game                   ;game screen
mov cx, 9
mov si, 0
E2:                       ;error massage
mov ah, 2
mov dl, error[si]
int 21h
inc si
loop E2
jmp L4


game:

mov ah, 06h       ; BIOS function to scroll the screen
mov al, 0         ; Number of lines to scroll (0 = clear entire screen)
mov bh, 07h       ; Page number and attribute (07h = white text on black background)
mov cx, 0         ; Upper-left corner of the screen (row=0, col=0)
mov dx, 184Fh     ; Lower-right corner of the screen (row=24, col=79)
int 10h 

; player 1 health
mov cx, 18
mov bh, 0    ;page
mov dh, 0    ;row
mov dl, 0    ;column
mov ah, 02h
int 10h    
mov si, 0
Player1Health:
mov ah, 2
mov dl, health[si]
int 21h 
inc si

loop Player1Health

; player 2 health
mov cx, 18
mov bh, 0    ;page
mov dh, 0    ;row
mov dl, 63    ;column
mov ah, 02h
int 10h    
mov si, 0
Player2Health:
mov ah, 2
mov dl, health[si]
int 21h 
inc si

loop Player2Health

; Draw Player 1 block (left)
MOV CX, 10      ; Height of the block
MOV BH, 0       ; Page number
MOV BL, 1       ; Color attribute (blue)
MOV Dh, 8   ; Position (Row 0, Column 0)     
mov dl, 0
mov si, 0
DrawPlayer1:
    inc si
    MOV AH, 02h ; Set cursor position
    INT 10h
    MOV AH, 09h ; Write character
    MOV AL, 219 ; ASCII for block
    inc Cl      ; Repeat once
    INT 10h     
    INC DH      ; Move to the next row
    cmp si, 10
    je X     
    LOOP DrawPlayer1

; Draw Player 2 block (right)
X:
MOV CX, 10
MOV BH, 0
MOV BL, 4     ; Color attribute (red)
mov dh, 8     ; Position (Row 8, Column 69)
mov dl, 69
mov si, 0
DrawPlayer2:  
    inc si
    mov ah, 02h
    INT 10h
    MOV AH, 09h
    MOV AL, 219
    inc cl
    INT 10h
    INC DH
    cmp si, 10
    je Y
    LOOP DrawPlayer2   
    

; Draw the wall
Y:

mov si, 0

z:

mov cx, 1
mov bh, 0            ;page
mov bl, 0eh          ;color   
mov dh, 0            ;row        
mov dl, 39           ;column  
mov di, 0            ;counter
cmp si, 25           ;to make sure it doesn't go after the wallBlocks
je assign2 
inc si
 

wall:
mov ah, 02h          ;set cursor position
int 10h

h: 
cmp si, 25
je assign            ;to reset the index
mov ah, 09h
mov al, wallBlocks[si]
inc cl
int 10h
inc dh               ;next row
inc si
inc di
cmp di, 25           ;to exit the loop
je z
loop wall

assign:
mov si, 0
jmp h
assign2:
mov si, 1
jmp h


ret

m:


ret