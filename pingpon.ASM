;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (C) 2022 Assembler Game - Stephan Herrera
;
; Version pong, not finished
; https://github.com/stephan-hp
;_______________________________________________________________
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
    mov [nave_X],160-3
    mov [nave_Y],320*200-320*12
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
    RIGHT	  equ  4dh

    mov ax,13h
    int 10h

;
main:
    xor dx,dx
    ;-------------------------------------------

     ;---------------------------------------------
    call  fondo
    mov   [puntos],0
    mov   [tiempo],0
    call  Drawbugs
    call  PutObject
    mov [condicion_choca_derecha] ,0
    mov [condicion_choca_izquierda] ,1
    mov [condicion_choca_arriba] ,0
    mov [condicion_choca_abajo]  ,1
    call  Mover_objetos
    jmp Fin


; esta funcion mueve los diferentes objetos por la pantalla
;
Mover_objetos:
	mov bp,0
mover:
	cmp [tiempo],1	   ; esto es la velocidad del timer
	jne mover

    cmp [condicion_choca_derecha] ,1
    jne  .prox1

     sub [pelota_X], 4
     cmp [pelota_X], 4
     ja .prox1
     mov [condicion_choca_derecha],0
     mov [condicion_choca_izquierda],1

.prox1:  cmp [condicion_choca_izquierda] ,1
     jne  .prox2

     add [pelota_X], 4
     cmp [pelota_X], 320-4
     jb .prox2
     mov [condicion_choca_derecha],1
     mov [condicion_choca_izquierda],0

.prox2:   cmp [condicion_choca_arriba] ,1
    jne  .prox3

     add [pelota_Y], 320*4



     cmp [pelota_Y], 320*200-320*4
     jb .prox3	      ; brinca a prox3 solo si choca con la paleta
  ;   mov [condicion_choca_arriba],0
 ;    mov [condicion_choca_abajo],1

     jmp main

.prox3:    cmp [condicion_choca_abajo]	,1
    jne  .salir

     sub [pelota_Y], 320*4
     cmp [pelota_Y], 320*20+320*5+320*4
     ja .salir
     mov [condicion_choca_arriba],1
     mov [condicion_choca_abajo],0

   .salir:
	call Drawbugs
	mov [tiempo],0
	jmp Mover_objetos
  ret

Drawbugs:
	   mov	   ebx,[pelota_oldY]
	   add	   ebx,[pelota_oldX]
	   mov	   edi, ebx
	   call    Erasebola
	   mov	   ebx,[pelota_Y]
	   add	   ebx,[pelota_X]
	   mov	   edi,ebx
	   mov	   ebx, [pelota_Y]
	   mov	   [pelota_oldY], ebx
	   mov	   ebx, [pelota_X]
	   mov	   [pelota_oldX], ebx
	    mov     edx,  bola
	    mov     esi, edx
	   call    Drawbola

ret


fondo:

 xor edx,edx
 call	 Poner_puntos

       mov edi,0
	     mov     ecx,200
     .fila:  mov     ebx,320
.siguiente:  mov     al,1
	     mov     [0xa0000+edi],al
	     dec     ebx
	     inc     edi
	     cmp     ebx,0
	     jne     .siguiente
	     loop    .fila

mov edi,320*20
	     mov    ecx,5
     .sfila: mov    ebx,320
.ssiguiente: mov    al,0x0f
	     mov     [0xa0000+edi],al
	     dec     ebx
	     inc     edi
	     cmp     ebx,0
	     jne     .ssiguiente
	     loop    .sfila
ret

    SPEED	  equ 24
    keyboard:	  in  al,60h
	 cmp	 al,LEFT
	 je	 .left
	 cmp	 al,RIGHT
	 je	 .right
	 jmp	 .exit

  .espera:    mov    ebx, [nave_oldX]
	      mov    [nave_X], ebx
	      mov    ebx, [nave_oldY]
	      mov    [nave_Y], ebx
	      jmp     .update

 .left:  sub	 [nave_X],SPEED
	 cmp	 [nave_X],3
	 jb    .espera

	jmp	.update

 .right: add	 [nave_X],SPEED
	 cmp	 [nave_X],320-20
	 ja	 .espera

 .update: call	  PutObject

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


EraseObject: mov     eax,0x01010101
	     mov     ecx,10
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     mov     [0xa0000+edi+12],eax
	     mov     [0xa0000+edi+12+4],eax
	     mov     [0xa0000+edi+12+4+4],eax
	     add     edi,320
	     loop    @b
	     ret

DrawObject: mov     esi,paleta
	    mov     ecx,10
     .fila: mov     ebx,24
.siguiente: mov     al,[esi]
	    cmp     al,0
	    je	    @f
	    mov     [0xa0000+edi],al
	@@: inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-24
	    loop    .fila
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
ret

Erasebola: mov	   eax,0x01010101
	     mov     ecx,4
	 @@: mov     [0xa0000+edi],eax
	     add     edi,320
	     loop    @b
	     ret

Drawbola:  mov	   esi,bola
	    mov     ecx,4
     .fila: mov     ebx,4
.siguiente: mov     al,[esi]
	    mov     [0xa0000+edi],al
	    inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-4
	    loop    .fila
      .nod:
   ret

Fin:

jmp $


name1 db '   00 : sadiV'     ; texto

name2 db '   !ETSANAG  '     ; texto

timer:	 ; codigo del timer
	cli
	inc [tiempo]
	xor al,al
	mov al,20h
	out 20h,al
	xor al,al
	sti
	iret

;_________________________________________________________________________________________________
nave_pos    dd 320*182+152
nave_X	    dd 152
nave_oldX   dd 152
nave_Y	    dd 320*182
nave_oldY   dd 320*100

condicion_choca_derecha db 10
condicion_choca_izquierda db 10
condicion_choca_arriba	db 10
condicion_choca_abajo	db 10

puntos	    db 00

tiempo	db 0

pelota_pos    dd 320*172+152+12
pelota_X      dd 152+12
pelota_oldX   dd 152+12
pelota_Y      dd 320*172
pelota_oldY   dd 320*172

;_________________________________________________________________________________________
;Nave principal

;//----------------------Bola-------------------\\
bola:
db	     9,0eh,0eh,9
db	     0eh,0eh,0eh,0eh
db	     0eh,0eh,0eh,0eh
db	     9,0eh,0eh,9
;//----------------------Paleta-------------------\\
paleta:
db	     9,9,9,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,9,9
db	     9,9,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,9
db	     9,28,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,28
db	     9,28,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,28
db	     9,28,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,28
db	     9,28,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,28
db	     9,28,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,28
db	     9,28,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,28
db	     9,9,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,28,9
db	     9,9,28,28,28,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,28,28,9,9


;____________________________________________________________________________________________
times(9*512)-($-$$)db 0
