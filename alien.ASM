;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (C) 2022 Assembler Game - Stephan Herrera
;
;
; https://github.com/stephan-hp
;_______________________________________________________________
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

format binary as 'img'
use16		  ; Modo de 16-bit

org 0x7C00	  ; Dirección del sector de arranque

BootStageOne:
    mov ah,0x00   ; iniciar el disco
    mov dl,0	  ; numero del drive
    int 0x13	  ; llamada a la rutina de interrupción del BIOS
    ;
    ; Cargar los sectores del disco utilizando la interrupción 0x13 del BIOS
    mov ah,0x02   ; leer los sectores a memoria
    mov al,0x10   ; numero de sectores a leer (mas de lo que se necesita)
    mov dl,0	  ; numero del drive
    mov ch,0	  ; numero de cilindro
    mov dh,0	  ; numero de cabeza
    mov cl,2	  ; numero de sector de arranque
    mov bx,inicio ; dirección de memoria donde comienza el programa a cargar
    int 0x13	  ; llamada a la rutina de interrupción del BIOS
    ;
    jmp inicio	  ; programa cargado ne memoria: Comienza la pasion!
    ;

PadOutSectorOneWithZeroes:
    ; rellenar con ceros el resto del espacio en los sectores
    times ((0x200 - 2) - ($ - $$)) db 0x00

BootSectorSignature: ; firma de arranque
    dw 0xAA55 ; estos deben ser los dos ultimos bytes en el sector de arranque



; Aqui comienza el programa
;
inicio:
   mov	   al,20h	   ; Fin de interrupción hardware
   out	   20h,al

    mov ax,cs
    mov ds,ax
    mov [disparador_X],320-16-1 ; posicion de inicio de la disparador
    mov [disparador_Y],2*320
    mov [disparador_oldX],152 ; posicion antigua  de la disparador
    mov [disparador_oldY],320*100
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

    ;algunas constantes con el codigo de las teclas
    LEFT	  equ  4bh
    DOWN	  equ  50h
    RIGHT	  equ  4dh
    UP		  equ  48h
    SPACE	  equ  57d

    ;Inciar el modo grafico 320x200
    mov ax,13h	   ; modo video
    int 10h
;
main:

    xor dx,dx
    mov [vida],10

    call  Mover_objetos
    call  PutObject

   jmp Fin



Mover_objetos:
	mov bp,0
mover:
	cmp dl,8	  ; TIEMPO
	jne mover
	call fondo

	add [aster1_posX], 5
	cmp [aster1_posX], 152
	ja pon06
	jmp cont6
  pon06: mov [aster1_posX], 0
  cont6: mov ax, [aster1_posX]
	add ax, [aster1_posY]
	mov [aster1_pos], ax

	add [aster3_posX], 25
	cmp [aster3_posX], 152
	ja pon07
	jmp cont7
  pon07: mov [aster3_posX], 0
  cont7: mov ax, [aster3_posX]
	add ax, [aster3_posY]
	mov [aster3_pos], ax

	add [aster6_posX], 25
	cmp [aster6_posX], 320-25
	ja pon078
	jmp cont78
  pon078: mov [aster6_posX], 60
  cont78: mov ax, [aster6_posX]
	add ax, [aster6_posY]
	mov [aster6_pos], ax

	sub [aster5_posX], 5
	cmp [aster5_posX], 0
	jb pon08
	jmp cont8
  pon08: mov [aster5_posX], 72
  cont8: mov ax, [aster5_posX]
	 add ax, [aster5_posY]
	 mov [aster5_pos], ax

	call Drawbugs

	mov dl,0
	jmp Mover_objetos
	ret

Drawbugs:
    ;
    mov     edx, nave_alien_que_mata
    mov     esi, edx
    mov     di,[aster1_pos]
    call    pintar_objeto_func
    ;nave_alien_que_mata 3
    mov     di,[aster3_pos]
    call    pintar_objeto_func
    ;nave_alien_que_mata 5
    mov     di,[aster5_pos]
    call    pintar_objeto_func
    mov     di,[aster6_pos]
    call    pintar_objeto_func
    mov     edx, estrella
    mov     esi, edx
    mov     edi,320*200-320*50+16
    call    DrawEstrella
    ret

Poner_vida:
	call	PutObject
	xor	edi,edi
	cmp	[vida],0
	jbe	 Fin
	mov edi,name2

	xor cx,cx
	mov cx,9
	ciclo:
		push cx
		mov ah,09h
		mov al,[edi]
		cmp cx, 8
		je .h
		jmp .s
	     .h:
		 cmp [vida],10
		 jb .s
		 add al,1
	     .s:
		cmp cx, 9
		je .h2
		jmp .s2
	     .h2:
		 cmp [vida],10
		 jae .s2
		 add al,[vida]
	     .s2:
		mov bh,0
		mov bl,0fh
		inc edi
		int 10h
		pop cx
	loop ciclo
ret

fondo:
    mov ax,13h
    int 10h
    xor dx,dx
    ;call draw
    call PutObject
    call Poner_vida
    ret
			     ;TECLADO
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

	 .espera: mov	 ebx, [disparador_oldX]
		  mov	 [disparador_X], ebx
		  mov	 ebx, [disparador_oldY]
		  mov	 [disparador_Y], ebx
		 jmp	 .update

       .space:	call	 tiro
		jmp	.update

	 .left: sub	[disparador_X],SPEED
		cmp	[disparador_X],16
		jb	.espera
		jmp	.update

	 .down: add	[disparador_Y],320*SPEED
		cmp	[disparador_Y],320*190
		ja	.espera
		jmp	.update

	.right: add	[disparador_X],SPEED
		cmp	[disparador_X],320-16
		ja	.espera
		jmp	.update

	   .up: 	cmp	[disparador_Y],320*2
			jbe .espera
			sub	[disparador_Y],320*SPEED

       .update: call	PutObject

	 .exit: mov	al,20h
		out	20h,al
   iret

					  ;PONER NAVE
PutObject: mov	   ebx,[disparador_oldY]
	   add	   ebx,[disparador_oldX]
	   mov	   edi,ebx
	   call EraseObject
	   mov	   ebx,[disparador_Y]
	   add	   ebx,[disparador_X]
	   mov	   edi,ebx
	   mov	   ebx, [disparador_Y]
	   mov	   [disparador_oldY], ebx
	   mov	   ebx, [disparador_X]
	   mov	   [disparador_oldX], ebx
	   call    DrawObject
	   ret

					 ;BORRAR LA NAVE VIEJA
EraseObject: mov     eax,0
	     mov     ecx,16
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     mov     [0xa0000+edi+12],eax
	     add     edi,320
	     loop    @b
	     ret


DrawObject: mov     esi,mainship       ;DIBUJAR NAVE
	    mov     ecx,16
     .fila: mov     ebx,16
.siguiente: mov     al,[esi]
	    cmp     al,0
	    je	    @f
	    mov     [0xa0000+edi],al
	@@: inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-16
	    loop    .fila
	    ret

DrawEstrella:
	    mov     ecx,30
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

pintar_objeto_func:

    pintar_objeto_func8:  mov	  cx,16
    siguiente8:   mov	  bl,16
    fila8:	  mov	  al,[esi]
		  cmp	  al,0
		  je	  abc8

		  mov	  ah,[fs:di]
		  cmp	  ah,0
		  jne	  inicio
		  mov	  [fs:di],al
		  mov	  ah,[fs:di+152]
		  cmp	  ah,0
		  jne	  inicio

		  mov	  [fs:di+152],al
    abc8:	  inc	  esi
		  inc	  di
		  dec	  bl
		  cmp	  bl,0
		  jne	  fila8
		  add	  di,320-16
		  loop	  siguiente8
		  mov	  esi, edx
	     ret


tiro:
	   mov	   ebx, [disparador_X]
	   sub	   ebx,16
	   mov	   [bomba_X], ebx
	   mov	   ebx, [disparador_Y]
	   mov	   [bomba_Y], ebx
	   mov	   [bomba_oldY], ebx
	   mov	   ebx, [bomba_X]
	   mov	   [bomba_oldX], ebx

.Mover_bomba:
.mover: inc [tiempo_ver]
	cmp [tiempo_ver], 10000   ;CICLO
	jbe .mover
	   mov	   ebx,[bomba_oldY]
	   add	   ebx,[bomba_oldX]
	   mov	   edi,ebx

	   call    Erasebomba

	   mov	   ebx,[bomba_Y]
	   add	   ebx,[bomba_X]
	   mov	   edi,ebx

	   mov	   ah,[fs:di+320*5]
		   cmp	  ah,0
		   jne	  .verificar
		   jmp	  .continuar

       .verificar: cmp	  [disparador_Y],320*120
		   jbe	  .salir
		   cmp	  [bomba_X],60
		   jae	  .salir
		   dec	  [vida]
		   jmp	  .salir

      .continuar:
	   mov	   ebx, [bomba_Y]
	   mov	   [bomba_oldY], ebx
	   mov	   ebx, [bomba_X]
	   mov	   [bomba_oldX], ebx
	   call    Drawbomba
	   dec	   [bomba_X]
	   mov	   [tiempo_ver],0
	   cmp	   [bomba_X],0
	   jbe	   .salir
	   jmp	   .Mover_bomba
    .salir:
	   xor	   edi,edi
	   mov	   ebx,[bomba_oldY]
	   add	   ebx,[bomba_oldX]
	   mov	   edi,ebx
	   call    Erasebomba
ret

Erasebomba:  mov     eax,0x00000000
	     mov     ecx,16
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     add     edi,320
	     loop    @b
	     ret

Drawbomba:  mov     esi,bomb
	    mov     ecx,16
     .fila: mov     ebx,13
.siguiente: mov     al,[esi]
	    cmp     al,0x09
	    je	    @f
	    mov     [0xa0000+edi],al
	@@: inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-13
	    loop    .fila
      .nod:
   ret


Fin:
	call	PutObject
	mov edi,name1
	mov cx,7+3
       .ciclo:
		push cx
		mov ah,09h
		mov al,[edi]
		mov bh,0
		mov bl,1111b
		inc edi
		int 10h
		pop cx
	loop .ciclo
jmp $			     ; A PARTIR DE AQUÍ ESTAN LAS VARIABLES

name1 db '  etsanaG '

name2 db '00 :adiV '

timer:	 ; codigo del timer
	cli
	inc dl
	mov al,20h
	out 20h,al
	sti
	iret

disparador_X	    dd 152
disparador_oldX   dd 152
disparador_Y	    dd 320*182
disparador_oldY   dd 320*100

vida	db 10
tiempo_ver  dw 0

bomba_X      dd 152
bomba_oldX   dd 152
bomba_Y      dd 320*182
bomba_oldY   dd 320*100

;seis asteriodes
aster1_pos dw 320*20+72
aster3_pos dw 320*60
aster5_pos dw 320*100+152
aster6_pos dw 320*160+10+30+20
aster6_posX dw 60
aster6_posY dw 320*160
aster1_posY dw 320*20
aster1_posX dw 72
aster3_posY dw 320*60
aster3_posX dw 0
aster5_posY dw 320*100
aster5_posX dw 152

;_________________________________________________________________________________________
;
mainship:
db   00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db   00,0,0,0,8,0,7,7,7,7,0,0,0,0,0,0
db   00,0,0,0,7,8,7,7,7,7,7,0,0,0,0,0
db   00,0,0,0,7,7,8,7,8,7,7,7,0,0,0,0
db   00,0,0,7,7,7,7,8,0fh,8,7,7,7,0,0,0
db   00,0,0,7,7,7,8,0fh,0fh,0fh,8,8,8,8,0,0
db   00,0,0,7,7,8,8,8,0fh,8,7,7,7,7,0,0
db   00,0,0,7,8,8,7,7,8,7,8,7,7,0,0,0
db   00,0,7,8,8,0,0,0,8,7,7,8,0,0,0,0
db   00,0,7,8,0,0,0,8,8,7,7,0,8,0,0,0
db   00,0,0,0,0,0,8,8,7,0,0,0,0,0,0,0
db   00,0,0,0,0,8,8,7,0,0,0,0,0,0,0,0
db   00,0,0,0,8,8,7,0,0,0,0,0,0,0,0,0
db   00,0,0,0,7,7,0,0,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0



nave_alien_que_mata:
db   00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db   00,0,0,7,0,0,0,0,0,0,0,0,0,0,7,0
db   00,0,0,7,0,0,0,0,7,0,0,0,0,0,7,0
db   00,0,0,7,0,0,0,7,8,7,0,0,0,0,7,0
db   00,0,0,7,0,0,7,8,8,8,7,0,0,0,7,0
db   00,0,0,7,7,7,8,8,8,8,8,7,7,7,7,0
db   00,0,0,7,7,7,8,8,8,8,8,7,7,7,7,0
db   00,0,0,7,7,7,8,8,8,8,8,7,7,7,7,0
db   00,0,0,7,0,0,7,8,8,8,7,0,0,0,7,0
db   00,0,0,7,0,0,7,8,8,7,0,0,0,0,7,0
db   00,0,0,7,0,0,0,7,7,0,0,0,0,0,7,0
db   00,0,0,7,0,0,0,0,0,0,0,0,0,0,7,0
db   00,0,0,7,0,0,0,0,0,0,0,0,0,0,7,0
db   00,0,0,7,0,0,0,0,0,0,0,0,0,0,7,0
db   00,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

bomb:
db   09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,28H,28H,28H,28H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,28H,28H,28H,2AH,2BH,2bH,09H,09H,09H
db   09H,09H,09H,28H,28H,28H,2aH,2AH,2BH,2bH,09H,09H,09H
db   09H,09H,28H,28H,28H,29H,29H,29H,2BH,2bH,29H,09H,09H
db   09H,09H,28H,29H,29H,29H,29H,29H,29H,29H,29H,29H,09H
db   09H,28H,28H,29H,29H,29H,29H,29H,29H,29H,29H,29H,09H
db   09H,28H,28H,29H,29H,29H,29H,29H,29H,29H,29H,29H,09H
db   09H,09H,28H,29H,28H,28H,28H,28H,28H,2bH,29H,29H,09H
db   09H,09H,09H,28H,28H,28H,28H,28H,29H,2bH,29H,09H,09H
db   09H,09H,09H,09H,28H,28H,28H,29H,28H,2bH,09H,09H,09H
db   09H,09H,09H,09H,09H,28H,28H,28H,28H,09H,09H,09H,09H
db   09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H
db   09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H,09H

estrella:
db   00,0,0,0,0,0,0,0,0,0,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,0,8,8,8,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,8,8,0,0,0,0,7,7,7,8,8,8,8,8,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,8,8,0,0,0,0,0,0,7,7,7,8,8,8,8,8,0,0,0,0,0,0,0
db   00,0,0,0,0,0,8,8,0,0,0,0,0,0,0,0,7,7,7,8,0,8,7,8,0,0,0,0,0,0
db   00,0,0,0,0,8,8,8,0,0,0,0,0,0,0,0,7,7,7,7,8,8,8,8,8,0,0,0,0,0
db   00,0,0,0,8,8,8,0,0,0,0,0,0,0,0,0,0,7,7,7,7,8,7,8,8,8,0,0,0,0
db   00,0,0,8,8,8,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,7,8,7,7,8,8,0,0,0
db   00,0,0,8,8,0,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,7,7,7,7,7,8,8,0,0
db   00,0,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,7,7,7,7,7,8,8,0,0
db   00,0,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,7,7,7,8,7,8,8,8,0
db   00,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,8,8,8,8,0
db   00,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,8,7,8,8,8
db   00,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,8,7,8,8,8
db   00,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,8,7,8,8,8
db   00,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,8,7,7,8,7,8
db   00,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,8,7,7,7,8,8,8
db   00,0,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,8,7,7,7,8,7,7,8
db   00,0,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,8,7,7,7,8,7,8,7,0
db   00,0,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,7,7,7,8,7,7,7,8,7,7,8,8,0
db   00,0,0,8,8,8,8,8,0,0,0,0,0,0,0,0,7,7,7,8,7,7,7,8,7,7,7,8,0,0
db   00,0,0,8,8,8,8,8,8,8,0,0,0,0,0,0,7,7,8,7,7,7,8,7,7,7,8,0,0,0
db   00,0,0,0,8,8,8,8,8,8,0,0,0,0,0,7,7,8,7,7,7,8,7,7,7,7,0,0,0,0
db   00,0,0,0,0,8,8,8,8,8,8,0,0,0,0,7,8,7,7,7,8,7,7,7,8,0,0,0,0,0
db   00,0,0,0,0,0,8,8,8,8,8,8,0,0,7,8,7,7,7,8,7,7,7,8,0,0,0,0,0,0
db   00,0,0,0,0,0,0,8,8,8,8,8,8,0,8,7,7,7,8,7,7,7,8,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,8,8,8,8,8,8,7,7,7,8,7,7,7,8,8,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,0,8,8,8,8,8,7,8,7,8,7,8,8,0,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,0,0,8,8,8,8,8,8,8,7,7,8,0,0,0,0,0,0,0,0,0,0
db   00,0,0,0,0,0,0,0,0,0,0,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0


;____________________________________________________________________________________________
times(8*512)-($-$$)db 0
