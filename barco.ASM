; (C) 2022 Assembler Game - Stephan Herrera
;
;
; https://github.com/stephan-hp
;_______________________________________________________________
format binary as 'img'
use16
org 0x7C00

    mov ah,0x00
    mov dl,0
    int 0x13

    mov ah,0x02
    mov al,0x35
    mov dl,0
    mov ch,0
    mov dh,0
    mov cl,2
    mov bx,inicio
    int 0x13
    jmp inicio

    times ((0x200 - 2) - ($ - $$)) db 0x00
    dw 0xAA55
;_____________________________________________________________________________
inicio:
   mov	   al,20h
   out	   20h,al

    mov ax,cs
    mov ds,ax
    mov [nave_X],160 ; posicion de inicio del BARCO
    mov [nave_Y],320*80-320*20
    mov [nave_oldX],160
    mov [nave_oldY],-320*60
    mov ax,0A000h
    mov fs,ax

    xor ax,ax
    mov es,ax

    mov ax,timer
    mov [es:4*8],ax
    mov [es:4*8+2],cs
    sti

    mov ax,keyboard
    mov [es:4*9], ax
    mov [es:4*9+2], cs

    LEFT	  equ  4bh
    DOWN	  equ  50h
    RIGHT	  equ  4dh
    UP		  equ  48h
    SPACE	  equ  57d

    mov ax,13h	   ; modo video
    int 10h

;
main:
    xor dx,dx
    ;-------------------------------------------
      mov edi,0
	     mov     ecx,80
     .fila:  mov     ebx,320
.siguiente:  mov     al,0x66
	     mov     [0xa0000+edi],al
	     dec     ebx
	     inc     edi
	     cmp     ebx,0
	     jne     .siguiente
	     loop    .fila
     ;---------------------------------------------
    call  fondo
    mov   [puntos],0
    mov   [tiempo_hor],0
    mov   [tiempo_ver],0
    call  Drawbugs
    call  Mover_objetos
    call  PutObject
    jmp Fin


; esta funcion mueve los diferentes objetos por la pantalla
;
Mover_objetos:
	mov bp,0
mover:
	cmp [tiempo_hor],10	 ; esto es la velocidad del timer
	jne mover
	call fondo
	;Esto mueve los objetos
	add [malo1_posX], 10
	cmp [malo1_posX], 320-30
	ja pon0
	jmp cont
  pon0: mov [malo1_posX], 0
  cont: mov ax, [malo1_posX]
	add ax, [malo1_posY]
	mov [malo1_pos], ax

	sub [malo2_posX], 20
	cmp [malo2_posX], 0
	jb pon01
	jmp cont1
  pon01: mov [malo2_posX], 72
  cont1: mov ax, [malo2_posX]
	 add ax, [malo2_posY]
	 mov [malo2_pos], ax

	sub [malo3_posX], 10
	cmp [malo3_posX], 0
	jb pon02
	jmp cont2
  pon02: mov [malo3_posX], 72
  cont2: mov ax, [malo3_posX]
	 add ax, [malo3_posY]
	 mov [malo3_pos], ax

	add [bueno1_posX], 10
	cmp [bueno1_posX], 320-30
	ja pon03
	jmp cont3
  pon03: mov [bueno1_posX], 0
  cont3: mov ax, [bueno1_posX]
	add ax, [bueno1_posY]
	mov [bueno1_pos], ax

	sub [bueno2_posX], 15
	cmp [bueno2_posX], 0
	jb pon04
	jmp cont4
  pon04: mov [bueno2_posX], 72
  cont4: mov ax, [bueno2_posX]
	 add ax, [bueno2_posY]
	 mov [bueno2_pos], ax
	call Drawbugs
	mov [tiempo_hor],0
	jmp Mover_objetos
  ret

Drawbugs:
	xor edx,edx
	xor edi,edi
	xor eax,eax
    mov     edx,  bote_bueno
    mov     esi, edx
    mov     es,[0a000h]
    mov     di,  [bueno1_pos]
    call    Drawsprite
    mov     edx,  bote_bueno
    mov     esi, edx
    mov     di,  [bueno2_pos]
    call    Drawsprite

    mov     edx,  bote_malo
    mov     esi, edx
	mov	es,[0a000h]
    mov     di,  [malo1_pos]
    call    Drawsprite

    mov     edx,  bote_malo
    mov     esi, edx
    mov     di,[malo2_pos]
    call    Drawsprite

    mov     edx,  bote_malo
    mov     esi, edx
    mov     di,[malo3_pos]
    call    Drawsprite
ret


fondo:
 xor edx,edx
 call	 Poner_puntos
mov edi,320*80
	     mov    ecx,200-80
     .sfila: mov    ebx,320
.ssiguiente: mov    al,0x09
	     mov     [0xa0000+edi],al
	     dec     ebx
	     inc     edi
	     cmp     ebx,0
	     jne     .ssiguiente
	     loop    .sfila
ret

    SPEED	  equ 16
    keyboard:	  in  al,60h
	 cmp	 al,LEFT
	 je	 .left
	 cmp	 al,DOWN
	 je	 .down
	 cmp	 al,RIGHT
	 je	 .right
	 cmp	 al,UP
	 je	 .up
	 cmp	 al,SPACE
	 je	 .space

	 jmp	 .exit

 .espera: mov	 ebx, [nave_oldX]
  mov	 [nave_X], ebx
  mov	 ebx, [nave_oldY]
  mov	 [nave_Y], ebx
 jmp	 .update

  .space: call	 lanzar_bomba
  jmp	 .update
 .left:  sub	 [nave_X],SPEED
	 cmp	 [nave_X],3
  jb	.espera

	jmp	.update
 .down:
     ja      .espera
     jmp     .exit

 .right: add	 [nave_X],SPEED
	 cmp	 [nave_X],320-20
	 ja	 .espera
	 jmp	 .update

  .up:
		jb Fin
  .update: call    PutObject

  .exit: mov	 al,20h
	 out	 20h,al
   iret


PutObject:  xor edx,edx
	    xor ebx,ebx
	   mov	   ebx,[nave_oldY]
	   add	   ebx,[nave_oldX]
	   mov	   edi,ebx
	   call    EraseObject
	   mov	   ebx,[nave_Y]
	   add	   ebx,[nave_X]
	   mov	   edi,ebx

	   mov	   ebx, [nave_Y]
	   mov	   [nave_oldY], ebx
	   mov	   ebx, [nave_X]
	   mov	   [nave_oldX], ebx

	   call    DrawObject
  ret


EraseObject: mov     eax,0x66666666
	     mov     ecx,20
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     mov     [0xa0000+edi+12],eax
	     mov     [0xa0000+edi+12+4],eax
	     mov     [0xa0000+edi+12+4+4],eax
	     mov     [0xa0000+edi+12+4+4+4],eax
	     mov     [0xa0000+edi+12+4+4+4+4],eax
	     add     edi,320
	     loop    @b
	     ret

DrawObject: mov     esi,barco
	    mov     ecx,20
     .fila: mov     ebx,32
.siguiente: mov     al,[esi]
	    cmp     al,0
	    je	    @f
	    mov     [0xa0000+edi],al
	@@: inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-32
	    loop    .fila
   ret

Drawsprite:
	    mov     ecx,16
     .fila: mov     ebx,30
.siguiente: mov     al,[esi]
	    cmp     al,0
	    je	    @f
	    mov     [0xa0000+edi],al
	@@: inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-30
	    loop    .fila
	    ret
ret

Poner_puntos:
	call	PutObject
	xor	edi,edi
	cmp	[puntos],10
	ja	 pon
	mov edi,name1
	xor cx,cx
	mov cx,13
	ciclo:
		push cx
		mov ah,09h
		mov al,[edi]
		cmp cx, 9
		je .h
		jmp .s
	     .h:
		 cmp [puntos],10
		 jb .s
		 add al,1
	     .s:
		cmp cx, 10
		je .h2
		jmp .s2
	     .h2:
		 cmp [puntos],10
		 jae .s2
		 add al,[puntos]
	     .s2:
		mov bh,0
		mov bl,66h
		inc edi
		int 10h
		pop cx
	loop ciclo
ret

pon:
	mov edi,name2
	xor cx,cx
	mov cx,7+6
	.ciclo:
		push cx
		mov ah,09h
		mov al,[edi]
		mov bh,0
		mov bl,66h
		inc edi
		int 10h
		pop cx
	loop .ciclo
	mov  [nave_Y],-320*30
	call PutObject
jmp $

lanzar_bomba:
	   mov	   ebx, [nave_X]
	   add	   ebx, 5
	   mov	   [bomba_X], ebx
	   mov	   [bomba_Y], 320*80
	   mov	   ebx, [bomba_Y]
	   mov	   [bomba_oldY], ebx
	   mov	   ebx, [bomba_X]
	   mov	   [bomba_oldX], ebx

.Mover_bomba:

.mover: inc [tiempo_ver]
	cmp [tiempo_ver], 9000
	jbe .mover
	   mov	   ebx,[bomba_oldY]
	   add	   ebx,[bomba_oldX]
	   mov	   edi,ebx
	   call    Erasebomba
	   mov	   ebx,[bomba_Y]
	   add	   ebx,[bomba_X]
	   mov	   edi,ebx
	   mov	 ah,[fs:di+320*16]
		  cmp	 ah,0x09  ;hubo colision
		  jne	 .verificar
		  jmp	 .continuar
      .verificar: cmp	  ah,7	 ;hubo colision bueno
		  jne	 .colision_malo
		  cmp	 [puntos],0
		  je	.salir
		  dec	 [puntos]
		  jmp	 .salir
   .colision_malo:cmp	  ah,0eh   ;hubo colision malo
		  jne	 .continuar
		  inc	 [puntos]
		  jmp	 .salir
      .continuar:
	   mov	   ebx, [bomba_Y]
	   mov	   [bomba_oldY], ebx
	   mov	   ebx, [bomba_X]
	   mov	   [bomba_oldX], ebx
	   call    Drawbomba
	   add	   [bomba_Y],320
	   mov	   [tiempo_ver],0
	   cmp	   [bomba_Y],320*200-320*16
	   jae	   .salir
	   jmp	   .Mover_bomba
    .salir:
	   xor	   edi,edi
	   mov	   ebx,[bomba_oldY]
	   add	   ebx,[bomba_oldX]
	   mov	   edi,ebx
	   call    Erasebomba
ret

Erasebomba: mov     eax,0x09090909
	     mov     ecx,16
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     add     edi,320
	     loop    @b
	     ret

Drawbomba:  mov     esi,BOMBA
	    mov     ecx,16
     .fila: mov     ebx,13
.siguiente: mov     al,[esi]
	    mov     [0xa0000+edi],al
	    inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-13
	    loop    .fila
      .nod:
   ret

Fin:

jmp $


name1 db '   00 :sotnuP'     ; texto

name2 db '   !ETSANAG  '     ; texto

timer:	 ; codigo del timer
	cli
	inc [tiempo_hor]
	xor al,al
	mov al,20h
	out 20h,al
	xor al,al
	sti
  iret

;_________________________________________________________________________________________________

nave_X	    dd 152
nave_oldX   dd 152
nave_Y	    dd 320*182
nave_oldY   dd 320*100

puntos	    db 00

tiempo_hor  db 0
tiempo_ver  dw 0

bomba_X      dd 152
bomba_oldX   dd 152
bomba_Y      dd 320*182
bomba_oldY   dd 320*100
;barcos malos
malo1_pos dw 320*88+15 +320*20
malo2_pos dw 320*122+32  +320*20
malo3_pos dw 320*153+44

malo1_posY dw 320*88 +320*20
malo1_posX dw 15
malo2_posY dw 320*122 +320*20
malo2_posX dw 32
malo3_posY dw 320*153
malo3_posX dw 44

; barcos buenos
bueno1_pos dw 320*96+152
bueno2_pos dw 320*120+72
bueno1_posY dw 320*96
bueno1_posX dw 152
bueno2_posY dw 320*120
bueno2_posX dw 72

;_________________________________________________________________________________________
;Nave principal
barco:

db   66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h
db   66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,0,0,0,0,0,0,0,0,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h
db   66h,66h,66h,0,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h,0,8,8,8,8,8,8,0,66h,66h,66h,66h,66h,66h,66h,66h,66h,66h
db   66h,66h,66h,66h,0,66h,66h,66h,66h,0,66h,66h,66h,66h,0,8,66h,66h,66h,66h,8,0,66h,66h,66h,66h,0,0,0,66h,66h,66h
db   66h,0,66h,66h,66h,0,66h,0,0,66h,0,66h,66h,66h,0,8,66h,66h,66h,66h,8,0,66h,66h,66h,8,8,8,0,66h,66h,66h
db   66h,66h,0,66h,66h,0,66h,0,66h,66h,0,66h,66h,66h,0,8,66h,66h,66h,66h,8,0,66h,66h,8,8,8,8,0,66h,66h,66h
db   66h,66h,66h,0,66h,0,66h,0,66h,66h,0,66h,66h,66h,0,8,66h,66h,66h,66h,8,0,66h,66h,8,8,8,8,0,66h,66h,66h
db   66h,66h,66h,0,66h,0,66h,0,66h,66h,0,66h,66h,66h,0,8,66h,66h,66h,66h,8,0,66h,66h,8,8,8,8,0,66h,66h,66h
db   8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,2
db   8,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,0,0,2,8,2
db   8,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,0,0,2,8,2,0
db   8,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1dh,1bh,1bh,1bh,0,2,8,2,0,66h
db   66h,8,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,0,2,8,2,0,66h,66h
db   66h,66h,8,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,0,2,8,2,0,66h,66h,66h
db   66h,66h,8,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,0,2,8,2,0,66h,66h,66h,66h
db   66h,66h,66h,8,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,0,2,8,2,0,66h,66h,66h,66h,66h
db   66h,66h,66h,8,8,8,8,8,8,8,8,8,88,8,8,8,8,8,8,8,8,8,8,8,2,0,66h,66h,66h,66h,66h,66h
db   66h,66h,66h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,2,0,0,0,2ah,2ch,66h,66h,66h,66h,66h
db   66h,66h,66h,66h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,0,0,0,66h,66h,66h,66h,66h,66h,66h
db   66h,66h,66h,66h,66h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,2,28h,2ah,2ch,66h,66h,66h,66h,66h

; 20 x 32

bote_bueno:
db 9,9,9,9,9,9,9,9,9,9,7,7,7,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
db 9,9,9,9,9,9,9,9,9,9,7,7,7,9,9,9,7,7,7,9,9,9,9,9,9,9,9,9,9,9
db 9,9,9,9,9,9,9,9,9,9,7,7,7,9,9,9,7,7,7,9,9,9,9,9,9,9,9,9,9,9
db 9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,9,9,9,9,9,9,9,9
db 9,9,9,7,7,7,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,7,7,7,7,9,9,9,9
db 9,9,7,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,7,9,9,9
db 9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,9
db 9,9,9,7,9,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,7,8,8,8,8,7
db 9,9,9,9,7,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,7,7,7,8,8,7
db 9,9,9,9,9,7,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,7,7,7,8,8,7
db 9,9,9,9,9,9,7,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,7,7,7,8,7,9
db 9,9,9,9,9,9,9,7,7,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,8,8,7,7,9,9
db 9,9,9,9,9,9,9,9,7,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,8,8,7,9,9,9
db 9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,9,9,9,9,9
db 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
db 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9

;16 x 30


bote_malo:
db 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
db 9,9,9,9,9,9,9,9,0eh,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
db 9,9,9,9,9,9,9,9,0eh,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
db 9,9,9,9,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,9,9,9,9,9,9,9
db 9,9,4,4,0eh,0eh,0eh,7,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,7,0eh,0eh,0eh,0eh,0eh,0eh,0eh,4,9,9,9
db 9,4,4,4,0eh,0eh,7,7,8,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,7,7,8,0eh,0eh,0eh,0eh,0eh,0eh,4,4,4,9
db 9,4,4,4,0eh,7,7,7,8,8,0eh,0eh,0eh,0eh,0eh,0eh,7,7,7,8,8,0eh,0eh,0eh,0eh,0eh,4,4,4,9
db 9,4,4,4,7,7,7,7,8,8,8,0eh,0eh,0eh,0eh,7,7,7,7,8,8,8,0eh,0eh,0eh,0eh,4,4,4,9
db 9,4,4,4,0eh,7,7,7,8,8,0eh,0eh,0eh,0eh,0eh,0eh,7,7,7,8,8,0eh,0eh,0eh,0eh,0eh,4,4,4,9
db 9,4,4,4,0eh,0eh,7,7,8,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,7,7,8,0eh,0eh,0eh,0eh,0eh,0eh,4,4,4,9
db 9,4,4,4,0eh,0eh,0eh,7,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,7,0eh,0eh,0eh,0eh,0eh,0eh,0eh,4,4,4,9
db 9,9,4,4,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,4,4,9,9
db 9,9,4,4,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,4,4,9,9
db 9,9,9,4,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,4,9,9,9
db 9,9,9,9,9,9,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,0eh,9,9,9,9,9,9,9,9
db 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9

;16 x 30
BOMBA:
db   09H,09H,09H,09H,09H,09H,2BH,09H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,09H,2BH,2BH,2BH,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,2BH,2BH,2BH,2BH,2BH,09H,09H,09H,09H
db   09H,09H,09H,09H,2BH,2AH,2AH,2AH,2BH,09H,09H,09H,09H
db   09H,09H,09H,09H,2BH,2AH,2AH,2AH,2BH,09H,09H,09H,09H
db   09H,09H,09H,09H,2BH,2AH,29H,2AH,2BH,09H,09H,09H,09H
db   09H,09H,09H,09H,29H,29H,29H,29H,2BH,09H,09H,09H,09H
db   09H,09H,09H,29H,29H,29H,29H,29H,29H,09H,09H,09H,09H
db   09H,09H,29H,29H,29H,29H,29H,29H,29H,29H,09H,09H,09H
db   09H,09H,29H,29H,29H,29H,29H,29H,29H,29H,09H,09H,09H
db   09H,09H,09H,29H,28H,28H,28H,28H,28H,29H,09H,09H,09H
db   09H,09H,09H,28H,28H,28H,28H,28H,29H,28H,09H,09H,09H
db   09H,09H,09H,09H,28H,28H,28H,29H,28H,28H,09H,09H,09H
db   09H,09H,09H,09H,09H,28H,28H,28H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,09H,09H,28H,09H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H

;16F X 13C

;____________________________________________________________________________________________
times(9*512)-($-$$)db 0
