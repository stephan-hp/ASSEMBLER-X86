; (C) 2022 Assembler Game - Stephan Herrera
;
; 2536 lines of code
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
    mov al,0x30
    mov dl,0
    mov ch,0
    mov dh,0
    mov cl,2
    mov bx,inicio
    int 0x13
    jmp inicio
    times ((0x200 - 2) - ($ - $$)) db 0x00
    dw 0xAA55


inicio:
   mov	   al,20h
   out	   20h,al

    mov ax,cs
    mov ds,ax

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

		     ; CONSTANTES PARA SABER QUE TECLA SE PRESIONA
    LEFT    equ  4bh
    RIGHT   equ  4dh
    one     equ  2
    two     equ  3
    tree    equ  4
    four    equ  5
    five    equ  6
    six     equ  7
    seven   equ  8
    eight   equ  9
    nine    equ  10
    A	    equ  30
    B	    equ  48
    C	    equ  46


    mov ax,13h
    int 10h

main:
    mov   [LE_TOCA_A_BLANCAS],1
    call  PintarTablero
    call  Actualizar_fichas


PintarTablero:
   ;Poner en edi la direccion
   ;Llamar a PintarCuadroBlanco o Negro para dibujar el cuadro en pantalla

   mov	 edi,60 	   +60
   call  PintarCuadroBlanco
   mov	 edi,60+25	   +60
   call  PintarCuadroNegro
   mov	 edi,60+50	   +60
   call  PintarCuadroBlanco
   mov	 edi,60+75	   +60
   call  PintarCuadroNegro
   mov	 edi,60+100	   +60
   call  PintarCuadroBlanco
   mov	 edi,60+125	   +60
   call  PintarCuadroNegro
   mov	 edi,60+150	   +60
   call  PintarCuadroBlanco
   mov	 edi,60+175	   +60
   call  PintarCuadroNegro
;hilera 2
   mov	 edi,60+320*25	     +60
   call  PintarCuadroNegro
   mov	 edi,60+25+320*25    +60
   call  PintarCuadroBlanco
   mov	 edi,60+50+320*25    +60
   call  PintarCuadroNegro
   mov	 edi,60+75+320*25    +60
   call  PintarCuadroBlanco
   mov	 edi,60+100+320*25   +60
   call  PintarCuadroNegro
   mov	 edi,60+125+320*25   +60
   call  PintarCuadroBlanco
   mov	 edi,60+150+320*25   +60
   call  PintarCuadroNegro
   mov	 edi,60+175+320*25   +60
   call  PintarCuadroBlanco

 ; hilera 3
   mov	 edi,60+320*50	    +60
   call  PintarCuadroBlanco
   mov	 edi,60+25+320*50   +60
   call  PintarCuadroNegro
   mov	 edi,60+50+320*50   +60
   call  PintarCuadroBlanco
   mov	 edi,60+75+320*50   +60
   call  PintarCuadroNegro
   mov	 edi,60+100+320*50  +60
   call  PintarCuadroBlanco
   mov	 edi,60+125+320*50  +60
   call  PintarCuadroNegro
   mov	 edi,60+150+320*50  +60
   call  PintarCuadroBlanco
   mov	 edi,60+175+320*50  +60
   call  PintarCuadroNegro
;hilera 4
   mov	 edi,60+320*25+320*50 +60
   call  PintarCuadroNegro
   mov	 edi,60+25+320*25+320*50+60
   call  PintarCuadroBlanco
   mov	 edi,60+50+320*25+320*50 +60
   call  PintarCuadroNegro
   mov	 edi,60+75+320*25+320*50  +60
   call  PintarCuadroBlanco
   mov	 edi,60+100+320*25+320*50 +60
   call  PintarCuadroNegro
   mov	 edi,60+125+320*25+320*50 +60
   call  PintarCuadroBlanco
   mov	 edi,60+150+320*25+320*50 +60
   call  PintarCuadroNegro
   mov	 edi,60+175+320*25+320*50 +60
   call  PintarCuadroBlanco
 ;Hilera 5
   mov	 edi,60+320*100      +60
   call  PintarCuadroBlanco
   mov	 edi,60+25+320*100   +60
   call  PintarCuadroNegro
   mov	 edi,60+50+320*100   +60
   call  PintarCuadroBlanco
   mov	 edi,60+75+320*100   +60
   call  PintarCuadroNegro
   mov	 edi,60+100+320*100  +60
   call  PintarCuadroBlanco
   mov	 edi,60+125+320*100  +60
   call  PintarCuadroNegro
   mov	 edi,60+150+320*100  +60
   call  PintarCuadroBlanco
   mov	 edi,60+175+320*100  +60
   call  PintarCuadroNegro
 ;Hilera 6
   mov	 edi,60+320*25+320*100	    +60
   call  PintarCuadroNegro
   mov	 edi,60+25+320*25+320*100   +60
   call  PintarCuadroBlanco
   mov	 edi,60+50+320*25+320*100   +60
   call  PintarCuadroNegro
   mov	 edi,60+75+320*25+320*100   +60
   call  PintarCuadroBlanco
   mov	 edi,60+100+320*25+320*100  +60
   call  PintarCuadroNegro
   mov	 edi,60+125+320*25+320*100  +60
   call  PintarCuadroBlanco
   mov	 edi,60+150+320*25+320*100  +60
   call  PintarCuadroNegro
   mov	 edi,60+175+320*25+320*100  +60
   call  PintarCuadroBlanco

;Hilera 7
   mov	 edi,60+320*150 +60
   call  PintarCuadroBlanco
   mov	 edi,60+25+320*150  +60
   call  PintarCuadroNegro
   mov	 edi,60+50+320*150  +60
   call  PintarCuadroBlanco
   mov	 edi,60+75+320*150  +60
   call  PintarCuadroNegro
   mov	 edi,60+100+320*150 +60
   call  PintarCuadroBlanco
   mov	 edi,60+125+320*150 +60
   call  PintarCuadroNegro
   mov	 edi,60+150+320*150 +60
   call  PintarCuadroBlanco
   mov	 edi,60+175+320*150 +60
   call  PintarCuadroNegro
;hilera 8
   mov	 edi,60+320*25+320*150	   +60
   call  PintarCuadroNegro
   mov	 edi,60+25+320*25+320*150  +60
   call  PintarCuadroBlanco
   mov	 edi,60+50+320*25+320*150  +60
   call  PintarCuadroNegro
   mov	 edi,60+75+320*25+320*150  +60
   call  PintarCuadroBlanco
   mov	 edi,60+100+320*25+320*150 +60
   call  PintarCuadroNegro
   mov	 edi,60+125+320*25+320*150 +60
   call  PintarCuadroBlanco
   mov	 edi,60+150+320*25+320*150 +60
   call  PintarCuadroNegro
   mov	 edi,60+175+320*25+320*150 +60
   call  PintarCuadroBlanco


; PINTAR UN CUADRO BLANCO PARA INDICAR LAS BLANCAS
	     mov     edi,320*100+50
	     mov     eax,0x0F0F0F0F
	     mov     ecx,16
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     mov     [0xa0000+edi+12],eax
	     add     edi,320
	     loop    @b

   cmp	 [LE_TOCA_A_BLANCAS],1	  ;COMPARAR SI LE TOCA A LAS BLANCAS SINO
   je	 .s			  ;PINTAR UN CUADRO NEGRO
	     mov   edi,320*100+50
	     mov     eax,0x70707070
	     mov     ecx,16
	 @@: mov     [0xa0000+edi],eax
	     mov     [0xa0000+edi+4],eax
	     mov     [0xa0000+edi+8],eax
	     mov     [0xa0000+edi+12],eax
	     add     edi,320
	     loop    @b
.s:
ret
 ;  ESTE METODO BORRA LA PANTALLA Y PINTA DE NUEVO LAS FICHAS SEGUN LA VELOCIDAD
 ;  DEL TIMER QUE SE PONGA
Actualizar_fichas:

	mov bp,0
.esperar:
	cmp [tiempo],15      ; esto es la velocidad del timer
	jne .esperar

call	PintarTablero
CALL	TiempoPantalla

mov	ebx,[FICHA_BLANCA_1]
mov	edi,ebx
call	PintarFichaBlanca
mov	esi,uno
mov	ebx,[FICHA_BLANCA_1]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_BLANCA_2]
mov	edi,ebx
call	PintarFichaBlanca
mov	esi,dos
mov	ebx,[FICHA_BLANCA_2]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_BLANCA_3]
mov	edi,ebx
call	PintarFichaBlanca
mov	esi,tres
mov	ebx,[FICHA_BLANCA_3]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_BLANCA_4]
mov	edi,ebx
call	PintarFichaBlanca
mov	esi,cuatro
mov	ebx,[FICHA_BLANCA_4]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_BLANCA_5]
mov	edi,ebx
call	PintarFichaBlanca
mov	ebx,[FICHA_BLANCA_6]
mov	edi,ebx
call	PintarFichaBlanca
mov	ebx,[FICHA_BLANCA_7]
mov	edi,ebx
call	PintarFichaBlanca
mov	ebx,[FICHA_BLANCA_8]
mov	edi,ebx
call	PintarFichaBlanca
mov	ebx,[FICHA_BLANCA_9]
mov	edi,ebx
call	PintarFichaBlanca
mov	ebx,[FICHA_BLANCA_A]
mov	edi,ebx
call	PintarFichaBlanca
mov	ebx,[FICHA_BLANCA_B]
mov	edi,ebx
call	PintarFichaBlanca
mov	ebx,[FICHA_BLANCA_C]
mov	edi,ebx
call	PintarFichaBlanca


mov	ebx,[FICHA_NEGRA_1]
mov	edi,ebx
call	PintarFichaNegra
mov	esi,uno
mov	ebx,[FICHA_NEGRA_1]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_NEGRA_2]
mov	edi,ebx
call	PintarFichaNegra
mov	esi,dos
mov	ebx,[FICHA_NEGRA_2]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_NEGRA_3]
mov	edi,ebx
call	PintarFichaNegra
mov	esi,tres
mov	ebx,[FICHA_NEGRA_3]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_NEGRA_4]
mov	edi,ebx
call	PintarFichaNegra
mov	esi,cuatro
mov	ebx,[FICHA_NEGRA_4]
add	ebx,320*9+10
mov	edi,ebx
call	PintarLetra
mov	ebx,[FICHA_NEGRA_5]
mov	edi,ebx
call	PintarFichaNegra
mov	ebx,[FICHA_NEGRA_6]
mov	edi,ebx
call	PintarFichaNegra
mov	ebx,[FICHA_NEGRA_7]
mov	edi,ebx
call	PintarFichaNegra
mov	ebx,[FICHA_NEGRA_8]
mov	edi,ebx
call	PintarFichaNegra
mov	ebx,[FICHA_NEGRA_9]
mov	edi,ebx
call	PintarFichaNegra
mov	ebx,[FICHA_NEGRA_A]
mov	edi,ebx
call	PintarFichaNegra
mov	ebx,[FICHA_NEGRA_B]
mov	edi,ebx
call	PintarFichaNegra
mov	ebx,[FICHA_NEGRA_C]
mov	edi,ebx
call	PintarFichaNegra
mov	[tiempo],0

;       PEQUEÑO CONTADOR QUE FUNCIONA COMO TIMER

inc	[tiempo_l]
cmp	[tiempo_l],50	; MODIFICAR PARA AJUSTAR EL TIEMPO DE CONTEO
	jb .cont
	inc [tiempo_c]
	mov [tiempo_l],0
.cont:
jmp	Actualizar_fichas

ret
    ;      TODOS ESTOS DE ABAJO SON METODOS PARA PINTAR
PintarFichaBlanca:
	      mov     esi,ficha_blanca	;EN ESI SE PONE EL OBJETO
	      mov     ecx,25;FILAS       EN EDI LA POSICION Y LISTO
     .fila_c: mov     ebx,25;COLUMNAS
.siguiente_c: mov     al,[esi]		;PONER EN AH LO DE ESI
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al	;RELLENA LA PANTALLA CON LO QUE TENGA AH
	  @@: inc     edi		;EN LA POSICION EDI
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-25
	      loop    .fila_c
       ret
PintarLetra:
	      mov     ecx,5 ; FILAS
     .fila_c: mov     ebx,5 ; COLUMNAS
.siguiente_c: mov     al,[esi]
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-5
	      loop    .fila_c

ret

PintarFichaNegra:
	      mov     esi,ficha_negra
	      mov     ecx,25; FILAS
     .fila_c: mov     ebx,25; COLUMNAS
.siguiente_c: mov     al,[esi]
	      cmp     al,0b
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-25
	      loop    .fila_c
       ret

PintarCuadroBlanco:
	      mov     esi,cuadro_blanco
	      mov     ecx,25 ; FILAS
     .fila_c: mov     ebx,25 ; COLUMNAS
.siguiente_c: mov     al,[esi]
	      cmp     al,0
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-25
	      loop    .fila_c
ret

PintarCuadroNegro:
	      mov     esi,cuadro_negro
	      mov     ecx,25; FILAS
     .fila_c: mov     ebx,25; COLUMNAS
.siguiente_c: mov     al,[esi]
	      cmp     al,0
	      je      @f
	      mov     [0xa0000+edi],al
	  @@: inc     edi
	      inc     esi
	      dec     ebx
	      cmp     ebx,0
	      jne     .siguiente_c
	      add     edi,320-25
	      loop    .fila_c
ret
;--------------------------------------------------------------------------
;               TECLADO
;               TODO LO QUE HACE
;--------------------------------------------------------------------------

    SPEED	  equ 16
    keyboard:	  in  al,60h
	 cmp	 al,LEFT
	 je	 .left
	 cmp	 al,RIGHT
	 je	 .right
	 cmp	 al,one
	 je	 .one
	 cmp	 al,two
	 je	 .two		;CADA UNA DE LAS TECLAS PARA DONDE SALTA A MOVER UNA
	 cmp	 al,tree	;FICHA
	 je	 .tree
	 cmp	 al,four
	 je	 .four
	 cmp	 al,five
	 je	 .five
	 cmp	 al,six
	 je	 .six
	 cmp	 al,seven
	 je	 .seven
	 cmp	 al,eight
	 je	 .eight
	 cmp	 al,nine
	 je	 .nine
	 cmp	 al,A
	 je	 .a
	 cmp	 al,B
	 je	 .b
	 cmp	 al,C
	 je	 .c
	 jmp	 .exit
;-------------------------------------------------
	  .one:     ; POR EJEMPLO FICHA UNO
		cmp	[LE_TOCA_A_BLANCAS],1  ;VERIFICAR QUE LE TOCA A LAS BLANCAS
		jne	.one_ne
		cmp	[MOVE_TO_RIGTH],1    ;VERIFICAR SI ES DERECHA/IZQUIERDA
		jne	.one_izq
		mov	ebx,[FICHA_BLANCA_1]
		call	analizar_borde_blanca  ;VERIFICAR EL BORDE DEL TABLERO
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha    ;VERIFICAR SI ES PARA COMER FICHA
		cmp	[come_negra_derecha],1
		je	.comeD
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25	       ;MOVERSE EN CASO DE PODER HACERLO
		mov	[FICHA_BLANCA_1],ebx
		mov	[LE_TOCA_A_BLANCAS],0  ;LE TOCA AL PROXIMO COLOR
		jmp	.exit
	.comeD:
		add	ebx,25*320+25+320*25+25  ;EN CASO DE TENER QUE COMER
		mov	[FICHA_BLANCA_1],ebx
	       ; mov     [LE_TOCA_A_BLANCAS],0    ;Regla de comer y jugar de nuevo
		jmp	.exit

       .one_izq:mov	ebx,[FICHA_BLANCA_1]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_1],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_1],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne:cmp	[MOVE_TO_RIGTH],1
		jne	.one_ne_izq
		mov	ebx,[FICHA_NEGRA_1]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_1],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_1],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq:mov	ebx,[FICHA_NEGRA_1]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_1],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_1],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

;-------------------------------------------------

		.two:

		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne2
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq2
		mov	ebx,[FICHA_BLANCA_2]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD2
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_2],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD2:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_2],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq2:mov	 ebx,[FICHA_BLANCA_2]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI2
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_2],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI2:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_2],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_ne2:cmp	[MOVE_TO_RIGTH],1
		jne	.one_ne_izq2
		mov	ebx,[FICHA_NEGRA_2]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne2
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_2],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne2:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_2],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq2:mov	 ebx,[FICHA_NEGRA_2]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne2
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_2],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne2:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_2],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.tree:

		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne3
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq3
		mov	ebx,[FICHA_BLANCA_3]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD3
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_3],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD3:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_3],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq3:mov	 ebx,[FICHA_BLANCA_3]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI3
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_3],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI3:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_3],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne3:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izq3
		mov	ebx,[FICHA_NEGRA_3]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne3
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_3],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne3:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_3],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq3:mov	 ebx,[FICHA_NEGRA_3]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne3
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_3],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne3:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_3],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit


		.four:
		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne4
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq4
		mov	ebx,[FICHA_BLANCA_4]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD4
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_4],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD4:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_4],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq4:mov	 ebx,[FICHA_BLANCA_4]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI4
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_4],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI4:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_4],ebx
	    ;    mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne4:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izq4
		mov	ebx,[FICHA_NEGRA_4]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne4
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_4],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne4:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_4],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq4:mov	ebx,[FICHA_NEGRA_4]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne4
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_4],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne4:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_4],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit


		.five:

		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne5
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq5
		mov	ebx,[FICHA_BLANCA_5]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD5
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_5],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD5:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_5],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq5:mov	 ebx,[FICHA_BLANCA_5]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI5
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_5],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI5:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_5],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne5:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izq5
		mov	ebx,[FICHA_NEGRA_5]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne5
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_5],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne5:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_5],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq5:mov	 ebx,[FICHA_NEGRA_5]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne5
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_5],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne5:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_5],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.six:

		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne6
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq6
		mov	ebx,[FICHA_BLANCA_6]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD6
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_6],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD6:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_6],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq6:mov	 ebx,[FICHA_BLANCA_6]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI6
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_6],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI6:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_6],ebx
	      ;  mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne6:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izq6
		mov	ebx,[FICHA_NEGRA_6]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne6
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_6],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne6:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_6],ebx
	    ;    mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq6:mov	 ebx,[FICHA_NEGRA_6]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne6
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_6],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne6:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_6],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.seven:
		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne7
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq7
		mov	ebx,[FICHA_BLANCA_7]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD7
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_7],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD7:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_7],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq7:mov	 ebx,[FICHA_BLANCA_7]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI7
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_7],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI7:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_7],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne7:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izq7
		mov	ebx,[FICHA_NEGRA_7]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne7
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_7],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne7:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_7],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq7:mov	 ebx,[FICHA_NEGRA_7]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne7
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_7],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne7:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_7],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.eight:
		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne8
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq8
		mov	ebx,[FICHA_BLANCA_8]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD8
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_8],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD8:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_8],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq8:mov	 ebx,[FICHA_BLANCA_8]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI8
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_8],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI8:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_8],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne8:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izq8
		mov	ebx,[FICHA_NEGRA_8]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne8
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_1],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne8:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_8],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq8:mov	 ebx,[FICHA_NEGRA_8]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne8
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_8],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne8:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_8],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.nine:
		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_ne9
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izq9
		mov	ebx,[FICHA_BLANCA_9]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeD9
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_9],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeD9:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_9],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izq9:mov	 ebx,[FICHA_BLANCA_9]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeI9
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_9],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeI9:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_9],ebx
	    ;    mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_ne9:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izq9
		mov	ebx,[FICHA_NEGRA_9]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_ne9
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_1],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_ne9:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_9],ebx
	    ;    mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izq9:mov	 ebx,[FICHA_NEGRA_9]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_ne9
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_9],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_ne9:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_9],ebx
	    ;    mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.a:
		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_neA
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izqA
		mov	ebx,[FICHA_BLANCA_A]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeDA
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_A],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeDA:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_A],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izqA:mov	 ebx,[FICHA_BLANCA_A]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeIA
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_A],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeIA:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_A],ebx
	    ;    mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_neA:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izqA
		mov	ebx,[FICHA_NEGRA_A]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_neA
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_A],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_neA:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_A],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izqA:mov	 ebx,[FICHA_NEGRA_A]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_neA
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_A],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_neA:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_A],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.b:
		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_neB
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izqB
		mov	ebx,[FICHA_BLANCA_B]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeDB
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_B],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeDB:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_B],ebx
	    ;    mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izqB:mov	 ebx,[FICHA_BLANCA_B]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeIB
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_B],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeIB:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_B],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_neB:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izqB
		mov	ebx,[FICHA_NEGRA_B]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_neB
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_B],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_neB:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_B],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izqB:mov	 ebx,[FICHA_NEGRA_B]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_neB
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_B],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_neB:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_B],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

		.c:
		cmp	[LE_TOCA_A_BLANCAS],1
		jne	.one_neC
		cmp	[MOVE_TO_RIGTH],1
		jne	.one_izqC
		mov	ebx,[FICHA_BLANCA_C]
		call	analizar_borde_blanca
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_negra_derecha
		cmp	[come_negra_derecha],1
		je	.comeDC
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320+25
		mov	[FICHA_BLANCA_C],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeDC:
		add	ebx,25*320+25+320*25+25
		mov	[FICHA_BLANCA_C],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

       .one_izqC:mov	 ebx,[FICHA_BLANCA_C]
		call	analizar_borde_blanca
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_negra_izquierda
		cmp	[come_negra_izquierda],1
		je	.comeIC
		cmp	[no_come_choca],0
		jne	.exit
		add	ebx,25*320-25
		mov	[FICHA_BLANCA_C],ebx
		mov	[LE_TOCA_A_BLANCAS],0
		jmp	.exit
	.comeIC:
		add	ebx,25*320-25+320*25-25
		mov	[FICHA_BLANCA_C],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],0
		jmp	.exit

	.one_neC:cmp	 [MOVE_TO_RIGTH],1
		jne	.one_ne_izqC
		mov	ebx,[FICHA_NEGRA_C]
		call	analizar_borde_negra
		cmp	[choca_borde_derecha],1
		je	.exit
		call	comer_blanca_derecha
		cmp	[come_blanca_derecha],1
		je	.comeD_neC
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320-25
		mov	[FICHA_NEGRA_C],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeD_neC:
		sub	ebx,25*320-25+320*25-25
		mov	[FICHA_NEGRA_C],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

    .one_ne_izqC:mov	 ebx,[FICHA_NEGRA_C]
		call	analizar_borde_negra
		cmp	[choca_borde_izquierda],1
		je	.exit
		call	comer_blanca_izquierda
		cmp	[come_blanca_izquierda],1
		je	.comeI_neC
		cmp	[no_come_choca],0
		jne	.exit
		sub	ebx,25*320+25
		mov	[FICHA_NEGRA_C],ebx
		mov	[LE_TOCA_A_BLANCAS],1
		jmp	.exit
      .comeI_neC:
		sub	ebx,25*320+25+320*25+25
		mov	[FICHA_NEGRA_C],ebx
	     ;   mov     [LE_TOCA_A_BLANCAS],1
		jmp	.exit

	 .left:  mov [MOVE_TO_RIGTH],0
		 mov [MOVE_TO_LEFT],1
		 jmp	 .exit
	.right:
		 mov [MOVE_TO_RIGTH],1
		 mov [MOVE_TO_LEFT],0
	 .exit:
		mov	[no_come_choca],0
		mov	al,20h	      ;FIN DE LA INTERRUPCION DEL TECLADO
		out	20h,al
 iret

;--------------------------------------------------------------------------
;               FIN DEL TECLADO

; METODOS PARA ANALIZAR FICHAS NEGRAS ANTES DE MOVERLAS POR TECLADO

comer_blanca_izquierda:       ;METODO PARA COMER FICHA BLANCA A LA IZQUIERDA SI
mov [come_blanca_izquierda],0 ;EXISTE LA FICHA Y UNA CASILLA VACIA DESPUES
mov [no_come_choca],0
   sub ebx, 320*25+25
   cmp ebx, [FICHA_BLANCA_1]  ;COMPARA SI EXISTE UNA FICHA CONTRARIA EN DIAGONAL
   jne .2
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh	 ;COMPARA SI EL COLOR DE LA OTRA CASILLA EN DIAGONAL ES EL COLOR
   jne .choca	 ;                   DE LA CASILLA VACIA, SINO NO SE PUEDE COMER
   mov [FICHA_BLANCA_1],320*200 ;EN CASO DE PODER, DESAPARECE LA FICHA QUE HABÍA
   mov [come_blanca_izquierda],1
   jmp .salir
.2:cmp ebx, [FICHA_BLANCA_2]
   jne .3
   sub ebx, 320*20+20
   mov edi, ebx 		 ;ES LA MISMA OPERACION PARA CADA FICHA
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_2],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.3:cmp ebx, [FICHA_BLANCA_3]
   jne .4
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_3],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.4:cmp ebx, [FICHA_BLANCA_4]
   jne .5
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_4],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.5:cmp ebx, [FICHA_BLANCA_5]
   jne .6
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_5],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.6:cmp ebx, [FICHA_BLANCA_6]
   jne .7
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_6],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.7:cmp ebx, [FICHA_BLANCA_7]
   jne .8
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_7],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.8:cmp ebx, [FICHA_BLANCA_8]
   jne .9
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_8],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.9:cmp ebx, [FICHA_BLANCA_9]
   jne .a
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_9],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.a:cmp ebx, [FICHA_BLANCA_A]
   jne .b
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_A],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.b:cmp ebx, [FICHA_BLANCA_B]
   jne .c
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_B],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.c:cmp ebx, [FICHA_BLANCA_C]
   jne .salirSE
   sub ebx, 320*20+20
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_C],320*200
   mov [come_blanca_izquierda],1
   jmp .salir

.choca:
  mov [no_come_choca],1
.salir:
  add ebx, 320*20+20
.salirSE:
  add ebx, 320*25+25
ret


comer_blanca_derecha:
mov [come_blanca_derecha],0
mov [no_come_choca],0
   sub ebx, 320*25-25
   cmp ebx, [FICHA_BLANCA_1]
   jne .2
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_1],320*200
   mov [come_blanca_derecha],1
   jmp .salir
.2:cmp ebx, [FICHA_BLANCA_2]
   jne .3
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_2],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.3:cmp ebx, [FICHA_BLANCA_3]
   jne .4
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_3],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.4:cmp ebx, [FICHA_BLANCA_4]
   jne .5
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_4],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.5:cmp ebx, [FICHA_BLANCA_5]
   jne .6
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_5],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.6:cmp ebx, [FICHA_BLANCA_6]
   jne .7
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_6],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.7:cmp ebx, [FICHA_BLANCA_7]
   jne .8
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_7],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.8:cmp ebx, [FICHA_BLANCA_8]
   jne .9
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_8],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.9:cmp ebx, [FICHA_BLANCA_9]
   jne .a
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_9],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.a:cmp ebx, [FICHA_BLANCA_A]
   jne .b
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_A],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.b:cmp ebx, [FICHA_BLANCA_B]
   jne .c
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_B],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.c:cmp ebx, [FICHA_BLANCA_C]
   jne .salirSE
   sub ebx, 320*20-30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_BLANCA_C],320*200
   mov [come_blanca_derecha],1
   jmp .salir

.choca:
  mov [no_come_choca],1
.salir:
  add ebx, 320*20-30
.salirSE:
  add ebx, 320*25-25
ret

analizar_borde_negra:
mov [choca_borde_derecha],0
    cmp ebx,320
    jbe .choca_d
    cmp ebx,320*25+320-25
    je .choca_d
    cmp ebx,320*75+320-25
    je .choca_d
    cmp ebx,320*125+320-25
    je .choca_d
    cmp ebx,320*175+320-25
    je	.choca_d
    sub ebx, 320*25-25
    cmp ebx, [FICHA_NEGRA_1]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_2]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_3]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_4]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_5]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_6]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_7]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_8]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_9]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_A]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_B]
    je	.choca_da
    cmp ebx, [FICHA_NEGRA_C]
    je	.choca_da
    add ebx, 320*25-25
    jmp .b
.choca_da:
    add ebx, 320*25-25
.choca_d:
    mov [choca_borde_derecha],1
.b: mov [choca_borde_izquierda],0
    cmp ebx,320
    jbe .choca_i
    cmp ebx,120
    je .choca_i
    cmp ebx,120+320*50
    je .choca_i
    cmp ebx,120+320*50+320*50
    je .choca_i
    cmp ebx,120+320*50+320*50+320*50
    je	.choca_i
    sub ebx, 320*25+25
    cmp ebx, [FICHA_NEGRA_1]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_2]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_3]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_4]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_5]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_6]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_7]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_8]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_9]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_A]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_B]
    je	.choca_db
    cmp ebx, [FICHA_NEGRA_C]
    je	.choca_db
    add ebx, 320*25+25
    jmp .no
.choca_db:
    add ebx, 320*25+25
.choca_i:
    mov [choca_borde_izquierda],1
    .no:
ret

; ANALIZAR FICHAS BLANCAS

comer_negra_izquierda:
mov [come_negra_izquierda],0
mov [no_come_choca],0
   add ebx, 320*25-25
   cmp ebx, [FICHA_NEGRA_1]
   jne .2
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_1],-320*25
   mov [come_negra_izquierda],1
   jmp .salir
.2:cmp ebx, [FICHA_NEGRA_2]
   jne .3
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_2],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.3:cmp ebx, [FICHA_NEGRA_3]
   jne .4
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_3],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.4:cmp ebx, [FICHA_NEGRA_4]
   jne .5
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_4],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.5:cmp ebx, [FICHA_NEGRA_5]
   jne .6
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_5],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.6:cmp ebx, [FICHA_NEGRA_6]
   jne .7
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_6],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.7:cmp ebx, [FICHA_NEGRA_7]
   jne .8
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_7],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.8:cmp ebx, [FICHA_NEGRA_8]
   jne .9
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_8],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.9:cmp ebx, [FICHA_NEGRA_9]
   jne .a
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_9],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.a:cmp ebx, [FICHA_NEGRA_A]
   jne .b
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_A],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.b:cmp ebx, [FICHA_NEGRA_B]
   jne .c
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_B],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.c:cmp ebx, [FICHA_NEGRA_C]
   jne .salirSE
   add ebx, 320*30-15
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_C],-320*25
   mov [come_negra_izquierda],1
   jmp .salir

.choca:
  mov [no_come_choca],1
.salir:
  sub ebx, 320*30-15
.salirSE:
  sub ebx, 320*25-25
ret


comer_negra_derecha:
mov [come_negra_derecha],0
mov [no_come_choca],0
   add ebx, 320*25+25
   cmp ebx, [FICHA_NEGRA_1]
   jne .2
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_1],-320*25
   mov [come_negra_derecha],1
   jmp .salir
.2:cmp ebx, [FICHA_NEGRA_2]
   jne .3
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_2],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.3:cmp ebx, [FICHA_NEGRA_3]
   jne .4
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_3],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.4:cmp ebx, [FICHA_NEGRA_4]
   jne .5
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_4],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.5:cmp ebx, [FICHA_NEGRA_5]
   jne .6
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_5],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.6:cmp ebx, [FICHA_NEGRA_6]
   jne .7
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_6],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.7:cmp ebx, [FICHA_NEGRA_7]
   jne .8
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_7],320*200
   mov [come_negra_derecha],1
   jmp .salir

.8:cmp ebx, [FICHA_NEGRA_8]
   jne .9
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_8],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.9:cmp ebx, [FICHA_NEGRA_9]
   jne .a
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_9],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.a:cmp ebx, [FICHA_NEGRA_A]
   jne .b
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_A],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.b:cmp ebx, [FICHA_NEGRA_B]
   jne .c
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_B],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.c:cmp ebx, [FICHA_NEGRA_C]
   jne .salirSE
   add ebx, 320*29+30
   mov edi, ebx
   mov ah,[fs:di]
   cmp ah, 2bh
   jne .choca
   mov [FICHA_NEGRA_C],-320*25
   mov [come_negra_derecha],1
   jmp .salir

.choca:
  mov [no_come_choca],1
.salir:
  sub ebx, 320*29+30
.salirSE:
  sub ebx, 320*25+25
ret

analizar_borde_blanca:
mov [choca_borde_derecha],0
    cmp ebx,320*200+120+25-320*25
    jae .choca_d
    cmp ebx,320*25+320-25
    je .choca_d
    cmp ebx,320*75+320-25
    je .choca_d
    cmp ebx,320*125+320-25
    je .choca_d
    cmp ebx,320*175+320-25
    je	.choca_d
    add ebx, 320*25+25
    cmp ebx, [FICHA_BLANCA_1]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_2]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_3]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_4]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_5]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_6]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_7]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_8]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_9]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_A]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_B]
    je	.choca_da
    cmp ebx, [FICHA_BLANCA_C]
    je	.choca_da
    sub ebx, 320*25+25
    jmp .b
.choca_da:
     sub ebx, 320*25+25
.choca_d:
    mov [choca_borde_derecha],1

.b: mov [choca_borde_izquierda],0
    cmp ebx,320*200+120+25-320*25
    jae .choca_i
    cmp ebx,120
    je .choca_i
    cmp ebx,120+320*50
    je .choca_i
    cmp ebx,120+320*50+320*50
    je .choca_i
    cmp ebx,120+320*50+320*50+320*50
    je	.choca_i
    add ebx, 320*25-25
    cmp ebx, [FICHA_BLANCA_1]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_2]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_3]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_4]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_5]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_6]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_7]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_8]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_9]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_A]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_B]
    je	.choca_ia
    cmp ebx, [FICHA_BLANCA_C]
    je	.choca_ia
sub ebx, 320*25-25
    jmp .no
.choca_ia:
sub ebx, 320*25-25
.choca_i:
    mov [choca_borde_izquierda],1
    .no:
ret


;                     CODIGO DE LAS LETRAS EN LA IZQUIERDA
;------------------------------------------------------------------------------
TiempoPantalla:
	xor eax,eax
	xor ebx,ebx
	      mov bp,0
	      mov edi,texto_pantalla1
	      xor cx,cx
	      mov cx,14
	ciclo:
	      mov ah,09h
	      mov al,[edi]
	      cmp cx,13
	      je .agr
	      cmp cx,14
	      je .agg
	      jmp .con
	 .agg:
	      cmp [tiempo_c],0
	      ja .conto
	      jmp .con
      .conto: add al,10
	      sub al,[tiempo_c]
	      jmp .con
	.agr:
	 cmp [tiempo_c],10
	 je Fin.perder
	 cmp [tiempo_c],0
	 jne .con
	 inc al
    .con:
	 mov bh,0xf
	 mov bl,0x6
	 inc edi
	 int 10h
	 loop ciclo
 ret

Fin:

.perder:
	mov  ax, 13h
	int  0x10
	 mov bp,0
	 mov edi,texto_pantalla2
	 mov cx,15
.ciclo:
	 mov ah,09h
	 mov al,[edi]
	 mov bh,0xf
	 mov bl,0x6
	 inc edi
	 int 10h
	 loop .ciclo

jmp $  ; -----------------------------------------------------------------------
;                     FIN DEL JUEGO DE DAMAS
;-------------------------------------------------------------------------------

timer:	 ;CODIGO DEL TIMER
	cli
	inc [tiempo] ; EL TIMER INCREMENTA UNA VARIABLE TIEMPO
	mov al,20h   ; PARA PODER USARLA PARA CONTAR LOS SEGUNDOS
	out 20h,al
	sti
     iret


texto_pantalla1 db  '00: emiT samaD'
texto_pantalla2 db  '  !REVO EMAG   '

tiempo	 db 0
tiempo_c db 0
tiempo_l db 0

MOVE_TO_RIGTH	   db 0
MOVE_TO_LEFT	   db 1
LE_TOCA_A_BLANCAS  db 1
temp		   db 0

come_blanca_derecha	db  0
come_blanca_izquierda	db  0

choca_borde_derecha	db  0
choca_borde_izquierda	db  0

come_negra_izquierda	db  0
come_negra_derecha	db  0

no_come_choca		db  0

FICHA_BLANCA_1 dd 120+320*50
FICHA_BLANCA_2 dd 120+320*50+50
FICHA_BLANCA_3 dd 120+320*50+50+50
FICHA_BLANCA_4 dd 120+320*50+50+50+50
FICHA_BLANCA_5 dd 120+25+320*25
FICHA_BLANCA_6 dd 120+25+320*25+50
FICHA_BLANCA_7 dd 120+25+320*25+50+50
FICHA_BLANCA_8 dd 120+25+320*25+50+50+50
FICHA_BLANCA_9 dd 120
FICHA_BLANCA_A dd 120+50
FICHA_BLANCA_B dd 120+50+50
FICHA_BLANCA_C dd 120+50+50+50

FICHA_NEGRA_1 dd 120+25+320*125
FICHA_NEGRA_2 dd 120+25+320*125+50
FICHA_NEGRA_3 dd 120+25+320*125+50+50
FICHA_NEGRA_4 dd 120+25+320*125+50+50+50
FICHA_NEGRA_5 dd 120+320*150
FICHA_NEGRA_6 dd 120+320*150+50
FICHA_NEGRA_7 dd 120+320*150+50+50
FICHA_NEGRA_8 dd 120+320*150+50+50+50
FICHA_NEGRA_9 dd 120+25+320*175
FICHA_NEGRA_A dd 120+25+320*175+50
FICHA_NEGRA_B dd 120+25+320*175+50+50
FICHA_NEGRA_C dd 120+25+320*175+50+50+50

cuadro_negro:
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
db   06,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6

cuadro_blanco:
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db   2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh

ficha_negra:
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,70h,70h,70h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh
db 2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh
db 2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh
db 2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh
db 2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh
db 2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh
db 2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh
db 2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh
db 2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh
db 2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh
db 2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh
db 2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh
db 2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,70h,70h,70h,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh


ficha_blanca:
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh
db 2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh
db 2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh
db 2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh
db 2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh
db 2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh
db 2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh
db 2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh
db 2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh
db 2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh
db 2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh
db 2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh
db 2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,0fh,0fh,0fh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh
db 2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh,2bh

uno:
db 0 ,0  ,2bh,0,0
db 0 ,2bh,2bh,0,0
db 0 ,0  ,2bh,0,0
db 0 ,0  ,2bh,0,0
db 0 ,2bh,2bh,2bh,0

dos:
db 0,0,2BH,2BH,0
db 0,2BH,0,0,2BH
db 0,0,0,2BH,0
db 0,0,2BH,0,0
db 0,2BH,2BH,2BH,0

tres:
db 0,0,2bh,2bh,0
db 0,2bh,0,0,2bh
db 0,0,0,2bh,0
db 0,2bh,0,0,2bh
db 0,0,2bh,2bh,0

cuatro:
db 0,0,0,2bh,0
db 0,0,2bh,2bh,0
db 0,2bh,2bh,2bh,2bh
db 0,0,0,2bh,0
db 0,0,0,2bh,0



times(25*512)-($-$$)db 0x00
