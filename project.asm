;This programs calculates the duration, distance and velocity at the end of a horizontal throw.

IDEAL
MODEL small
STACK 100h
DATASEG
;-----------------------------------------------------------------------
welcome     db '__          __  _                           ',10,13
            db '\ \        / / | |                          ',10,13
            db ' \ \  /\  / /__| | ___ ___  _ __ ___   ___  ',10,13
            db '  \ \/  \/ / _ \ |/ __/ _ \|  _ ` _ \ / _ \    ',10,13
            db '   \  /\  /  __/ | (_| (_) | | | | | |  __/    ',10,13
            db '    \/  \/ \___|_|\___\___/|_| |_| |_|\___|   ',10,13
			db 'This programs calculates the duration, distance and velocity', 10,13, 'at the end of a horizontal throw. $'

inputh db 'Please write the height of the ball in meters.$'
inputv db 'Please write the velocity of the ball in meters per second.$'
outputt db 'The duration of the throw, in seconds is: $'
outputd db 'The distance traveled during the throw, in meters is: $'
outputv db 'The velocity at the end of the throw, in meters per second is: $'
reset db 'If you want to calculate another throw press y, if not press any key.$'
bye db 'Bye bye and see you next time :)$'
;-----------------------------------------------------------------------
height db 8 dup (?)
velocity db 8 dup (?)
Distance db 8 dup (?)
Time db 8 dup (?)
Endvel db 8 dup (?)
;-----------------------------------------------------------------------
inttime dw 0
difference dw 0
intvelocity dw 0
intheight dw 0
intdistance dw 0
vy dw 0
vx dw 0
sumv dw 0
endv dw 0
;-----------------------------------------------------------------------


CODESEG
;-----------------------------------------------------------------------
;Calculates the duration of the throw
proc TimeCalc
    xor cx, cx	
;Converts input ascii to int		
L1:
	mov ax, [intheight]
	mov bx, 0Ah
	mul bx
	mov [intheight], ax	
	xor bx,bx
	xor ax,ax	
	mov bx, offset height
	add bx, 2
	add bx,cx
	mov al,[bx]		
	sub ax,'0'		
	add [intheight], ax
	xor ax,ax
	mov al, [offset height+1]
	inc cx
	cmp cx, ax	
	jb L1

;Divide by 5 because of the formula
    mov ax,[intheight]
	mov bx,5
	div bx
	mov [inttime],ax 
	xor cx,cx

;Finds square root
somelabel:
	inc cx
	mov ax ,cx
	mul cx
	cmp [inttime], ax
	ja somelabel
	je same

;Finds the closest squared number
	sub ax,[inttime]
	mov [difference], ax
	dec cx
	mov ax,cx
	mul cx
	sub ax,[inttime]
	cmp [difference],ax
	jl first
	jmp sec

;If the first number is the same
same: 
	mov [inttime] ,cx
	jmp stop

;If the first number is closer	
first:
	inc cx
	mov [inttime] ,cx
	jmp stop

;If the second number is closer	
sec:
	mov [inttime],cx
	jmp stop

;Converts the time to a string	
stop:
	mov ax, [inttime]
	mov  bx, 10   ;DIGITS ARE EXTRACTED DIVIDING BY 10.
    mov  cx, 0      
cyclea1:  
	mov  dx, 0    ;NECESSARY TO DIVIDE BY BX.       
	div  bx       ;DX:AX / 10 = AX:QUOTIENT DX:REMAINDER.
	push dx       ;PRESERVE DIGIT EXTRACTED FOR LATER.
	inc  cx       ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED.
	cmp  ax, 0    ;IF NUMBER IS NOT YET ZERO, LOOP.
	jne  cyclea1  

;NOW RETRIEVE PUSHED DIGITS.
	mov si, offset Time
cyclea2:
	pop  dx           
	add  dl, '0'   ;CONVERT DIGIT TO CHARACTER. 48 is '0' in ASCII 
	mov  [ si ], dl
	inc  si
	loop cyclea2
	mov [byte ptr si],'$'
ret
endp TimeCalc
;-----------------------------------------------------------------------

;Calculates the distance that was traveled during the throw
proc DistanceCalc 
	xor cx, cx
;Converts input ascii to int	
L2:
	mov ax, [intvelocity]
	mov bx, 0Ah
	mul bx
	mov [intvelocity], ax	
	xor bx,bx
	xor ax,ax	
	mov bx, offset velocity
	add bx, 2
	add bx,cx
	mov al,[bx]		
	sub ax,'0'		
	add [intvelocity], ax
	xor ax,ax
	mov al, [offset velocity+1]
	inc cx
	cmp cx, ax	
	jb L2
	mov ax, [intvelocity]
	mul [inttime]
	mov [intdistance], ax

;Converts the distance to a string
    mov  bx, 10   ;DIGITS ARE EXTRACTED DIVIDING BY 10.
    mov  cx, 0      
cycleb1:  
	mov  dx, 0    ;NECESSARY TO DIVIDE BY BX.       
    div  bx       ;DX:AX / 10 = AX:QUOTIENT DX:REMAINDER.
    push dx       ;PRESERVE DIGIT EXTRACTED FOR LATER.
    inc  cx       ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED.
    cmp  ax, 0    ;IF NUMBER IS NOT YET ZERO, LOOP.
    jne  cycleb1   ; 
;NOW RETRIEVE PUSHED DIGITS.
    mov si, offset Distance
cycleb2:
    pop  dx           
    add  dl, '0'   ;CONVERT DIGIT TO CHARACTER. 48 is '0' in ASCII 
    mov  [ si ], dl
    inc  si
    loop cycleb2
	mov [byte ptr si],'$'
	ret
endp DistanceCalc
;-----------------------------------------------------------------------

;Prints new line
proc NewLine
   	mov dl, 10
	mov ah, 2
	int 21h
	mov dl, 13
	mov ah, 2
	int 21h
    ret
endp NewLine
;-----------------------------------------------------------------------

;Calculates the velocity at the end of the throw with Pythagorean theorem
proc VelocityCalc
;Sums a^2 and b^2
	mov ax, [intvelocity]
	mul ax
	mov [vx], ax
	mov ax,[inttime]
	mov bx , 10
	mul bx
	mul ax
	mov [vy], ax
	add ax, [vx]
	mov [sumv], ax
;Calculates the square root 
	xor cx,cx
L3:
	inc cx
	mov ax ,cx
	mul cx
	cmp [sumv], ax
	ja L3
	je samea
	
;Finds the closest squared number
	sub ax,[sumv]
	mov [difference], ax
	dec cx
	mov ax,cx
	mul cx
	sub ax,[sumv]
	cmp [difference],ax
	jl firsta
	jmp seca

;If the first number is the same
samea: 
	mov [endv] ,cx
	jmp stopa

;If the first number is closer	
firsta:
	inc cx
	mov [endv] ,cx
	jmp stopa

;If the second number is closer	
seca:
	mov [endv],cx
	jmp stopa

;Converts the velocity to a string
stopa:
	mov ax, [endv]
	mov  bx, 10   ;DIGITS ARE EXTRACTED DIVIDING BY 10.
    mov  cx, 0      
cyclec1:  
	mov  dx, 0    ;NECESSARY TO DIVIDE BY BX.       
	div  bx       ;DX:AX / 10 = AX:QUOTIENT DX:REMAINDER.
	push dx       ;PRESERVE DIGIT EXTRACTED FOR LATER.
	inc  cx       ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED.
	cmp  ax, 0    ;IF NUMBER IS NOT YET ZERO, LOOP.
	jne  cyclec1  

;NOW RETRIEVE PUSHED DIGITS.
	mov si, offset Endvel
cyclec2:
	pop  dx          	 
	add  dl, '0'   ;CONVERT DIGIT TO CHARACTER. 48 is '0' in ASCII 
	mov  [ si ], dl
	inc  si
	loop cyclec2
	mov [byte ptr si],'$'
ret  
endp VelocityCalc
;-----------------------------------------------------------------------

;Itializes the variables for another run 
proc Init
	mov	[inttime], 0
	mov [difference], 0
	mov [intvelocity], 0
	mov [intheight], 0
	mov [intdistance], 0
	mov [vy], 0
	mov [vx], 0
	mov [sumv], 0
	mov [endv], 0

	mov  cx, 8
    mov  di, offset height
I1: 
	mov  bl, '$'      
    mov  [di], bl
    inc  di
    loop I1

	mov  cx, 8
    mov  di, offset velocity
I2: 
	mov  bl, '$'      
    mov  [di], bl
    inc  di
    loop I2

	mov  cx, 8
    mov  di, offset Distance
I3: 
	mov  bl, '$'      
    mov  [di], bl
    inc  di
    loop I3

	mov  cx, 8
    mov  di, offset Time
I4: 
	mov  bl, '$'      
    mov  [di], bl
    inc  di
    loop I4

	mov  cx, 8
    mov  di, offset Endvel
I5: 
	mov  bl, '$'      
    mov  [di], bl
    inc  di
    loop I5

	jmp start
	ret
	
endp Init

start:
	mov ax, @data
	mov ds, ax

;Prints welcome message
	mov dx, offset welcome
	mov ah, 9h
	int 21h
	call NewLine

;Asks for height
	mov dx, offset inputh
	mov ah, 9h
	int 21h
	call NewLine
	mov dx, offset height
	mov bx, dx
	mov [byte ptr bx], 4 
	mov ah, 0Ah
	int 21h
	call NewLine

;Asks for velocity
	mov dx, offset inputv
	mov ah, 9h
	int 21h
	call NewLine
	mov dx, offset velocity
	mov bx, dx
	mov [byte ptr bx], 4 
	mov ah, 0Ah
	int 21h

;Calculates the duration of the throw
	call TimeCalc

;Calculates the distance that was traveled during the throw
	call DistanceCalc

;Calculates the velocity at the end of the throw
	call VelocityCalc

;Prints new line
    call NewLine

;Prints the duration of the throw
	mov dx, offset outputt
	mov ah, 9h
	int 21h
    mov dx, offset Time
	mov ah, 9h
	int 21h

;Prints new line   
	call NewLine

;Prints the distance that was traveled during the throw
	mov dx, offset outputd
	mov ah, 9h
	int 21h
	mov dx, offset Distance
	mov ah, 9h
	int 21h

;Prints new line
	call NewLine
	
;Prints the velocity at the end of the throw
	mov dx, offset outputv
	mov ah, 9h
	int 21h
	mov dx, offset Endvel
	mov ah, 9h
	int 21h

;Prints new line    
	call NewLine

;Asks if he wants to to another throw
	mov dx, offset reset
	mov ah, 9h
	int 21h
	call NewLine
	mov ah, 1
	int 21h
	
	cmp al, 'y'
	jne exit
	call NewLine
	call Init
	


;-----------------------------------------------------------------------   
exit:
	call NewLine
	mov dx, offset bye
	mov ah, 9h
	int 21h
	mov ax, 4c00h
	int 21h
END start