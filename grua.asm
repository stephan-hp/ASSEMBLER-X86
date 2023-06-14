;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (C) 2022 Assembler Game - Stephan Herrera
;
;
; https://github.com/stephan-hp
;_______________________________________________________________
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

format binary as 'img'
use16
org 0x7C00
 ;                  MASTER BOOT RECORD
    mov ah,0x00
    mov dl,0
    int 0x13
    mov ah,0x02
    mov al,0x20
    mov dl,0
    mov ch,0
    mov dh,0
    mov cl,2
    mov bx,inicio
    int 0x13
    jmp inicio
    times ((0x200 - 2) - ($ - $$)) db 0x00
    dw 0xAA55
;___________________________________________________________________________

inicio:
   mov	   al,20h
   out	   20h,al

    mov ax,cs
    mov ds,ax

    mov [gancho_pos_X],16*4-8
    mov [gancho_pos_Y],320*29
    mov [gancho_pos_oldX],16*4-8
    mov [gancho_pos_oldY],320*29
    mov [cajas_ahora_izq],10
    mov [cajas_no_agarradas],10
    mov [pos_down_izq],320*100-320*20+320*1*16
    mov [pos_down_der],320*100-320*20+320*4*16
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
    LEFT    equ  4bh
    DOWN    equ  50h
    RIGHT   equ  4dh
    UP	    equ  48h
call pla
     jmp ende
pla: mov ax,13h
    int 10h
    mov eax,0x0B0B0B0B
    mov edi, 0
    mov ecx, 320*15
 Pintar_fondo :
	    mov     [0xa0000+edi],eax
	    mov     [0xa0000+edi+4],eax
	    mov     [0xa0000+edi+8],eax
	    mov     [0xa0000+edi+12],eax
	    add     edi,16
    loop    Pintar_fondo
ret
ende:
;                            PROGRAMA PRINICPAL DEL JUEGO

main:
    call  PintarEstructura
    xor edx,edx
    xor ebx,ebx
    xor ecx,ecx
    xor eax,eax
    mov   [tiempo],0
    call  PutObject
    call  dibujar
   jmp Fin

PintarEstructura:
			; PINTAR ESTRUCTURAS Y COMPONENTES
    mov     esi, biga0
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20
    call    DrawBiga0
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*2
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*3
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*4
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*5
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*6
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*7
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*8
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*9
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*10
    mov     esi, biga1
    call    DrawBiga1
    mov     edi, 320*200-16*320*3-320*14-320*109-320*20+21+26*10+19
    mov     esi, fin_biga
    call    DrawBigaFin
    mov     esi, bloque30x30
    mov     edi, 320*200+0-16*320*3-320*14
    call    DrawBloque
    mov     esi, bloque30x30
    mov     edi, 320*200+0-16*320*3-320*14+320-30
    call    DrawBloque
    mov     esi,bloque
    mov     edi,  320*200+0-16*320
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*2
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*3
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*4
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*5
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*6
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*2
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*3
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*4
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*5
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*6
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*2+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*3+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*4+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*5+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320+16*6+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*2+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*3+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*4+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*5+208
    call    DrawCaja
    mov     esi,bloque
    mov     edi,  320*200+0-16*320*2+16*6+208
    call    DrawCaja
    mov     esi,agua
    mov     edi,  320*200+0-16*320+16*6+16
    call    DrawCaja
    mov     esi,agua
    mov     edi,  320*200+0-16*320+16*6+16*2
    call    DrawCaja
    mov     esi,agua
    mov     edi,  320*200+0-16*320+16*6+16*3
    call    DrawCaja
    mov     esi,agua
    mov     edi,  320*200+0-16*320+16*6+16*4
    call    DrawCaja
    mov     esi,agua
    mov     edi,  320*200+0-16*320+16*6+16*5
    call    DrawCaja
    mov     esi,agua
    mov     edi,  320*200+0-16*320+16*6+16*6
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*1+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*2+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*3+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*4+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*1+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*2+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*3+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*4+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*5+16*3+16
    call    DrawCaja
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*5+16*2+16
    call    DrawCaja
    mov     esi, columna
    mov     edi, 320*200+0-16*320*3-320*14-320*109
    call    DrawColumna
    mov     esi, columna
    mov     edi, 320*200+0-16*320*3-320*14+320-30-320*109
    call    DrawColumna
ret

borrarCAJAalSUBIR:
    cmp     [cajas_ahora_izq],9
    jne     .2
    mov     edi, 320*200+0-16*320*5+16*3+16
    call    EraseCaja
    jmp     .exit
 .2: cmp     [cajas_ahora_izq],8
    jne      .3
    mov     edi, 320*200+0-16*320*5+16*2+16
    call    EraseCaja
     add     [pos_down_izq],320*16
    jmp     .exit
 .3: cmp     [cajas_ahora_izq],7
    jne      .4
    mov     edi, 320*200+0-16*320*4+16*1+16
    call    EraseCaja
    jmp     .exit
 .4: cmp     [cajas_ahora_izq],6
    jne      .5
    mov     edi, 320*200+0-16*320*4+16*2+16
    call    EraseCaja
    jmp     .exit
 .5: cmp     [cajas_ahora_izq],5
    jne     .6
    mov     edi, 320*200+0-16*320*4+16*3+16
    call    EraseCaja
    jmp     .exit
 .6: cmp     [cajas_ahora_izq],4
    jne      .7
    mov     edi, 320*200+0-16*320*4+16*4+16
    call    EraseCaja
     add     [pos_down_izq],320*16
    jmp     .exit
 .7: cmp     [cajas_ahora_izq],3
    jne      .8
    mov     edi, 320*200+0-16*320*3+16*1+16
    call    EraseCaja
    jmp     .exit
 .8: cmp     [cajas_ahora_izq],2
    jne      .9
    mov     edi, 320*200+0-16*320*3+16*2+16
    call    EraseCaja
    jmp     .exit
 .9: cmp     [cajas_ahora_izq],1
    jne      .10
    mov     edi, 320*200+0-16*320*3+16*3+16
    call    EraseCaja
    jmp     .exit
 .10:cmp     [cajas_ahora_izq],0
    jne      .exit
    mov     edi, 320*200+0-16*320*3+16*4+16
     add     [pos_down_izq],320*16
    call    EraseCaja
    .exit:
 ret
ponerCAJAalSUBIR:
    cmp     [cajas_ahora_izq],10
    je	    .exit
    cmp     [cajas_ahora_izq],9
    jne     .2
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*1+16 + 16*11 + 8
    call    DrawCaja
    sub     [pos_down_der],320*16
    jmp     .exit
 .2: cmp     [cajas_ahora_izq],8
    jne      .3
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*2+16 + 16*11 + 8
    call    DrawCaja
    jmp     .exit
 .3: cmp     [cajas_ahora_izq],7
    jne      .4
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*3+16 + 16*11 + 8
    call    DrawCaja
    jmp     .exit
 .4: cmp     [cajas_ahora_izq],6
    jne      .5
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*3+16*4+16 + 16*11 + 8
    call    DrawCaja
    jmp     .exit
 .5: cmp     [cajas_ahora_izq],5
    jne      .6
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*1+16 + 16*11 + 8
    call    DrawCaja
    sub     [pos_down_der],320*16
    jmp     .exit
 .6: cmp     [cajas_ahora_izq],4
    jne      .7
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*2+16 + 16*11 + 8
    call    DrawCaja
    jmp     .exit
 .7: cmp     [cajas_ahora_izq],3
    jne      .8
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*3+16 + 16*11 + 8
    call    DrawCaja
    jmp     .exit
 .8: cmp     [cajas_ahora_izq],2
    jne      .9
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*4+16*4+16 + 16*11 + 8
    call    DrawCaja
    sub     [pos_down_der],320*16
    jmp     .exit
 .9: cmp     [cajas_ahora_izq],1
    jne      .10
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*5+16*3+16 + 16*11 + 8
    call    DrawCaja
    jmp     .exit
 .10: cmp     [cajas_ahora_izq],0
    jne      .exit
    mov     esi,cajas
    mov     edi, 320*200+0-16*320*5+16*2+16 + 16*11 + 8
    call    DrawCaja
.exit:
    ret
EraseCaja:
	      mov     ecx,16
     .fila_c: mov     ebx,16
.siguiente_c: mov     al,0bh
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-16
	      loop    .fila_c
       ret
DrawCaja:
	      mov     ecx,16
     .fila_c: mov     ebx,16
.siguiente_c: mov     al,[esi]
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-16
	      loop    .fila_c
       ret
DrawBiga1:
	      mov     ecx,20
     .fila_c: mov     ebx,26
.siguiente_c: mov     al,[esi]
	      cmp     al,0
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-26
	      loop    .fila_c
    ret
DrawBloque:
	      mov     ecx,30
     .fila_c: mov     ebx,30
.siguiente_c: mov     al,[esi]
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-30
	      loop    .fila_c
       ret

DrawColumna:
	      mov     ecx,110
     .fila_c: mov     ebx,30
.siguiente_c: mov     al,[esi]
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-30
	      loop    .fila_c
    ret
DrawBiga0:
	      mov     ecx,20
     .fila_c: mov     ebx,21
.siguiente_c: mov     al,[esi]
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-21
	      loop    .fila_c
    ret
 DrawBigaFin:
	      mov     ecx,20
     .fila_c: mov     ebx,13
.siguiente_c: mov     al,[esi]
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-13
	      loop    .fila_c
    ret
		;               INTERRUPCIONES DEL TECLADO
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
	 jmp	 .exit

	 .espera: mov	 ebx, [gancho_pos_oldX]
		  mov	 [gancho_pos_X], ebx
		  mov	 ebx, [gancho_pos_oldY]
		  mov	 [gancho_pos_Y], ebx
		  jmp	  .update

	 .left: sub	[gancho_pos_X],SPEED
		cmp	[gancho_pos_X],50-16
		jb	.espera
		cmp	[gancho_pos_Y],320*50-320*8
		ja	.espera
		jmp	.update

	 .down: add	[gancho_pos_Y],320*SPEED
		jmp	 .esperaIZQ
	 .esperaIZQ:
		cmp	[gancho_pos_X],50+16+16+16
		ja	.esperaDER
		mov	ebx,[pos_down_izq]
		cmp	[gancho_pos_Y],ebx
		jb	.updateDown
		mov	bl,[cajas_ahora_izq]
		cmp	[cajas_no_agarradas],bl
		jne	.espera
		dec	[cajas_ahora_izq]
		call	borrarCAJAalSUBIR
		jmp	.espera
	 .esperaDER:
		cmp	[gancho_pos_X],300-16-16-16-16-16
		jb	.espera
		mov	ebx,[pos_down_der]
		cmp	[gancho_pos_Y],ebx
		jb	.updateDown
		mov	bl,[cajas_ahora_izq]
		inc	bl
		cmp	[cajas_no_agarradas],bl
		jne	.espera
		dec	[cajas_no_agarradas]
		call	ponerCAJAalSUBIR
		cmp	[cajas_ahora_izq],0
		je	Fin.ganar
		jmp	.espera
	.right: add	[gancho_pos_X],SPEED
		cmp	[gancho_pos_X],300-16-16
		ja	.espera
		cmp	[gancho_pos_Y],320*50-320*8
		ja	.espera
		jmp	.update
	   .up: sub	[gancho_pos_Y],320*SPEED
		cmp	[gancho_pos_Y],320*36-320*8
		jb	.espera
		jmp	.update
       .updateDown:	call	PutObjectDown
			jmp	.exit
       .update: call	PutObject
	 .exit: mov	al,20h
		out	20h,al
  iret


PutObject: mov	   ebx,[gancho_pos_oldY]
	   add	   ebx,[gancho_pos_oldX]
	   mov	   edi,ebx
	   call EraseObject
	   mov	   ebx,[gancho_pos_Y]
	   add	   ebx,[gancho_pos_X]
	   mov	   edi,ebx
	   mov	   ebx, [gancho_pos_Y]
	   mov	   [gancho_pos_oldY], ebx
	   mov	   ebx, [gancho_pos_X]
	   mov	   [gancho_pos_oldX], ebx
	   call    DrawObject
     ret

EraseObject: mov     eax,0x0B0B0B0B
	     mov     ecx,16
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     mov     [0xa0000+edi+12],eax
	     add     edi,320
	     loop    @b
	 ret
EraseObjectD:	mov	esi,soga
		call	DrawCaja
  ret
PutObjectDown: mov     ebx,[gancho_pos_oldY]
	       add     ebx,[gancho_pos_oldX]
	       mov     edi,ebx
	       call    EraseObjectD
	       mov     ebx,[gancho_pos_Y]
	       add     ebx,[gancho_pos_X]
	       mov     edi,ebx
	       mov     ebx, [gancho_pos_Y]
	       mov     [gancho_pos_oldY], ebx
	       mov     ebx, [gancho_pos_X]
	       mov     [gancho_pos_oldX], ebx
	       call    DrawObject
	 ret
DrawObject: mov     esi,gancho
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
  ;                           CODIGO DEL TIEMPO DEL JUEGO
dibujar:
	xor eax,eax
	xor ebx,ebx
	      mov bp,0
	      mov edi,name1
	      xor cx,cx
	      mov cx,21
	ciclo:
	      mov ah,09h
	      mov al,[edi]
	      cmp cx,20
	      je .agr
	      cmp cx,10
	      je .agg
	      cmp cx,9
	      je .age
	      jmp .con
	.age: cmp [cajas_ahora_izq],10
	      jne .borrar
	      jmp .con
      .borrar:
	      dec al
	      jmp .con
	 .agg:
	      cmp [cajas_ahora_izq],10
	      jne .conto
	      jmp .con
      .conto: add al,[cajas_ahora_izq]
	      jmp .con
	.agr:
	 cmp [tiempo],9
	 je Fin.perder
	 sub al,[tiempo]
    .con:
	 mov bh,0xf
	 mov bl,0xb
	 inc edi
	 int 10h
	 loop ciclo

mover:
	 cmp [tiempo_c],150    ; MODIFICAR PARA AJUSTAR EL TIEMPO
	 jne mover
	 mov [tiempo_c],0
	 inc [tiempo]
      jmp dibujar
      ret
Fin:
.ganar:  call pla
	 mov bp,0
	 mov edi,name3
	 mov cx,21
.ciclo2:
	 mov ah,09h
	 mov al,[edi]
	 mov bh,0xf
	 mov bl,0xb
	 inc edi
	 int 10h
	 loop .ciclo2
	 jmp  .mover

.perder:
	mov [tiempo_c],0
	call pla
	 mov bp,0
	 mov edi,name2
	 mov cx,21
.ciclo:
	 mov ah,09h
	 mov al,[edi]
	 mov bh,0xf
	 mov bl,0xb
	 inc edi
	 int 10h
	 loop .ciclo
  .mover:
	 cmp [tiempo_c],80
	 jne .mover
	 jmp inicio

.cont:

jmp $
     ;                     FIN DEL PROGRAMA, DIBUJOS/VARIABLES

name1 db  ' 9:opmeiT  01:sotluB '
name2 db  ' !!!odatoga opmeiT   '
name3 db  '   !!!odanaG saH     '

timer:
	cli
	inc [tiempo_c]
	mov al,20h
	out 20h,al
	sti
     iret

gancho:
db	 0bh,16,16,16,16,16,16,16,16,16,16,16,16,16,08h,0bh
db	 0bh,0bh,16,15,6,6,6,6,6,6,6,6,6,08h,0bh,0bh
db	 0bh,0bh,0bh,16,15,6,6,6,6,6,6,6,08h,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,16,15,14,08,08,08,08,08,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,16,15,14,08,08,08,08,08,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,16,15,14,08,08,08,08,08,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,0bh,0bh,15,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,0bh,15,13h,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,13h,13h,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,13h,21,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,15,13h,0bh,0bh,0bh,0bh,13h,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,15,13h,0bh,0bh,0bh,15,13h,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,13h,13h,0bh,15,13h,13h,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,15,13h,13h,13h,13h,0bh,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db	 0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh

biga1:
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
db   06h,06h,06h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,06h,06h
db   0,08h,06h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,06h,06h
db   0,08h,06h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,06h,06h
db   0,06h,06h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,2bh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,06h,06h
db   2bh,08h,2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,08h,2bh
db   2bh,08h,08h,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,2bh,08h,2bh
db   2bh,08h,0bh,08h,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,08h,0bh,0bh,0bh,0bh,0bh,08h,2bh,2bh,08h,08h,2bh
db   2bh,08h,0bh,0bh,08h,2bh,2bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,08h,0bh,0bh,0bh,0bh,08h,2bh,2bh,08h,0bh,08h,2bh
db   2bh,08h,0bh,0bh,0bh,08h,2bh,2bh,0bh,0bh,0bh,0bh,08h,2bh,08h,0bh,0bh,0bh,08h,2bh,2bh,08h,0bh,0bh,08h,2bh
db   2bh,08h,0bh,0bh,0bh,0bh,08h,2bh,2bh,0bh,0bh,0bh,08h,2bh,08h,0bh,0bh,08h,2bh,2bh,08h,0bh,0bh,0bh,08h,2bh
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,08h,2bh,2bh,0bh,0bh,08h,2bh,08h,0bh,08h,2bh,2bh,08h,0bh,0bh,0bh,0bh,08h,2bh
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,2bh,0bh,08h,2bh,08h,08h,2bh,2bh,08h,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,2bh,08h,2bh,08h,2bh,2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh,2bh,2bh,2bh,2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   2bh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,2bh,2bh,2bh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,6


cajas:
db 0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b
db 0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b
db 0x06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db 0x0b,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,6,0x2b,6,0x0b
db 0x0b,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,0x2b,6,6,0x2b,0x2b,6,0x0b
db 0x0b,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,0x2b,0x2b,6,0x0b
db 0x0b,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,6,6,0x2b,0x2b,6,6,0x0b
db 0x0b,6,0x2b,0x2b,6,0x2b,0x2b,6,6,0x2b,6,0x2b,6,0x2b,6,0x0b
db 0x0b,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,0x2b,6,6,0x2b,0x2b,6,0x0b
db 0x0b,6,0x2b,0x2b,6,0x2b,6,6,0x2b,0x2b,6,0x2b,0x2b,0x2b,6,0x0b
db 0x0b,6,0x2b,0x2b,6,6,0x2b,6,0x2b,6,6,0x2b,0x2b,0x2b,6,0x0b
db 0x0b,6,0x2b,0x2b,6,0x2b,0x2b,6,6,0x2b,6,0x2b,0x2b,0x2b,6,0x0b
db 0x0b,6,0x2b,6,6,0x2b,0x2b,6,0x2b,0x2b,6,0x2b,0x2b,0x2b,6,0x0b
db 0x06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db 0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b
db 0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b,0x2b

bloque:
db  68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h
db  21h,21h,21h,68h,21h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h
db  21h,21h,21h,68h,21h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h
db  21h,21h,21h,68h,21h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h
db  68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h
db  68h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h,68h,21h,21h,21h
db  68h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h,68h,21h,21h,21h
db  68h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h,68h,21h,21h,21h
db  68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h
db  21h,21h,21h,68h,21h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h
db  21h,21h,21h,68h,21h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h
db  21h,21h,21h,68h,21h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h
db  68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h,68h
db  68h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h,68h,21h,21h,21h
db  68h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h,68h,21h,21h,21h
db  68h,21h,21h,21h,21h,21h,68h,21h,21h,21h,21h,21h,68h,21h,21h,21h

agua:

db  35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h
db  35h,35h,35h,64h,64h,35h,67h,35h,35h,35h,64h,35h,35h,35h,35h,35h
db  35h,35h,35h,67h,67h,35h,67h,67h,64h,35h,35h,35h,35h,35h,35h,35h
db  35h,35h,35h,64h,67h,35h,64h,67h,67h,35h,35h,35h,35h,35h,35h,35h
db  35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,64h,35h,35h,35h
db  35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h
db  67h,64h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,64h,64h,35h
db  35h,67h,67h,35h,35h,35h,35h,35h,64h,64h,64h,35h,35h,35h,35h,67h
db  35h,35h,35h,35h,35h,35h,35h,35h,64h,64h,35h,35h,35h,35h,35h,35h
db  35h,35h,35h,35h,35h,35h,35h,35h,67h,64h,64h,35h,35h,35h,35h,35h
db  35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h
db  35h,35h,67h,67h,35h,35h,35h,35h,35h,35h,35h,35h,64h,64h,35h,35h
db  35h,35h,35h,64h,67h,35h,35h,35h,35h,35h,35h,35h,64h,35h,35h,35h
db  35h,35h,35h,35h,35h,67h,67h,35h,35h,35h,64h,35h,64h,64h,35h,35h
db  35h,35h,35h,35h,35h,35h,64h,35h,35h,35h,35h,64h,35h,35h,35h,35h
db  35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h,35h

bloque30x30:
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h
db    72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,2ah,72h,2ah,72h

columna:
db     0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,13h,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,2bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,13h,2bh,2bh,13h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,0bh,08h,08h,08h,08h,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,08h,08h,08h,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db     0bh,0bh,08h,08h,08h,08h,08h,08h,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,08h,08h,08h,08h,08h,08h,0bh,0bh,0bh,0bh,0bh,0bh


biga0:
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,9,9,9,9,9,9
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,08h,06h,06h,06h,06h,06h
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,06h,08h,08h,06h,06h
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,1bh,06h,08h,08h,06h,06h
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,06h,06h,06h,06h,06h
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,0bh,08h,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,08h,1bh,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,08h,1ah,1bh,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,1bh,1ah,1bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,2bh
db   0bh,0bh,0bh,1bh,1ah,1ah,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,2bh
db   0bh,0bh,0bh,1bh,1bh,1ah,1bh,1bh,1bh,1bh,1bh,1bh,1bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   0bh,0bh,0bh,1bh,1bh,1ah,1bh,1bh,1bh,1bh,1bh,1bh,1bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   0bh,0bh,0bh,1bh,1bh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,6


soga:
db   0bh,0bh,0bh,0bh,0bh,0bh,72h,019,019,72h,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,00h,72h,72h,72h,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,2ah,72h,0bh,0bh,0bh,0bh,0bh,0bh,0bh

fin_biga:
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   06h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0,08h,06h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0,08h,06h,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   0,08h,08h,07h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   2bh,08h,07h,07h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   2bh,08h,08h,07h,07h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   2bh,08h,08h,07h,07h,07h,0bh,0bh,0bh,0bh,0bh,0bh,0bh
db   2bh,08h,0bh,08h,07h,07h,07h,0bh,0bh,0bh,0bh,0bh,0bh
db   2bh,08h,0bh,0bh,08h,07h,07h,07h,0bh,0bh,0bh,0bh,0bh
db   2bh,08h,0bh,0bh,0bh,08h,07h,07h,07h,0bh,0bh,0bh,0bh
db   2bh,08h,0bh,0bh,0bh,0bh,08h,07h,07h,07h,0bh,0bh,0bh
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,08h,07h,07h,07h,0bh,0bh
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,08h,07h,07h,008h,008h
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,07h,008h,008h
db   2bh,08h,0bh,0bh,0bh,0bh,0bh,0bh,0bh,0bh,08h,008h,008h
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,008h,008h
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,008h,008h
db   0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

cajas_no_agarradas db 10
cajas_ahora_izq    db 10
cant_cajas_der	   db 0
pos_down_izq	   dd 10
pos_down_der	   dd 10
tiempo		   db 10
tiempo_c	   db 10
contador	   db 10

gancho_pos_X	  dd 152
gancho_pos_oldX   dd 152
gancho_pos_Y	  dd 320*182
gancho_pos_oldY   dd 320*100

times(10*512)-($-$$)db 0x00