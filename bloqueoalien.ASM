;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Esta es una versión del juego asteroide donde se debe llevar la nave
;desde la parte inferior de la pantalla hasta la superior sin chocar
;con los asteroides o naves alienigenas que patrullan el espacio
;
;Elaborado como tarea del postgrado:
;          Arquitectura de computadoras: Teoría y práctica
;Equipo #1
;
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
    mov [nave_X],152 ; posicion de inicio de la nave
    mov [nave_Y],320*182
    mov [nave_oldX],152 ; posicion antigua  de la nave
    mov [nave_oldY],320*100
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
    LEFT	  equ  4bh  ; flecha izquierda
    DOWN	  equ  50h  ; flecha abajo
    RIGHT	  equ  4dh  ; flecha derecha
    UP		  equ  48h  ; flecha arriba

    ;Inciar el modo grafico 320x200
    mov ax,13h	   ; modo video
    int 10h


; Parte principal del proyecto
;
main:
    xor dx,dx
    ; llamado a los metodos
    call  Mover_objetos
    call  PutObject

   jmp Fin


; esta funcion mueve los diferentes objetos por la pantalla
;
Mover_objetos:	   ; mover carro
	mov bp,0
mover:
	cmp dl,9      ; esto es la velocidad del timer
	jne mover
	call fondo
	;Esto mueve los objetos
	;mover primera linea de naves rosadas
	add [aliensp1_posX], 10
	cmp [aliensp1_posX], 152
	ja pon0
	jmp cont
  pon0: mov [aliensp1_posX], 0
  cont: mov ax, [aliensp1_posX]
	add ax, [aliensp1_posY]
	mov [aliensp1_pos], ax
	;mover la segunda linea de naves rosadas
	sub [aliensp3_posX], 20
	cmp [aliensp3_posX], 0
	jb pon01
	jmp cont1
  pon01: mov [aliensp3_posX], 72
  cont1: mov ax, [aliensp3_posX]
	 add ax, [aliensp3_posY]
	 mov [aliensp3_pos], ax
	;mover la primera linea de naves rojas
	sub [aliensr1_posX], 10
	cmp [aliensr1_posX], 0
	jb pon02
	jmp cont2
  pon02: mov [aliensr1_posX], 72
  cont2: mov ax, [aliensr1_posX]
	 add ax, [aliensr1_posY]
	 mov [aliensr1_pos], ax
	;mover la segunda linea de naves rojas
	add [aliensr3_posX], 10
	cmp [aliensr3_posX], 152
	ja pon03
	jmp cont3
  pon03: mov [aliensr3_posX], 0
  cont3: mov ax, [aliensr3_posX]
	add ax, [aliensr3_posY]
	mov [aliensr3_pos], ax
	;mover la primera linea de naves amarillas
	sub [aliensy1_posX], 15
	cmp [aliensy1_posX], 0
	jb pon04
	jmp cont4
  pon04: mov [aliensy1_posX], 72
  cont4: mov ax, [aliensy1_posX]
	 add ax, [aliensy1_posY]
	 mov [aliensy1_pos], ax
	 ;mover la segunda linea de naves amarillas
	 add [aliensy3_posX], 15
	 cmp [aliensy3_posX], 152
	 ja pon05
	 jmp cont5
  pon05: mov [aliensy3_posX], 0
  cont5: mov ax, [aliensy3_posX]
	 add ax, [aliensy3_posY]
	 mov [aliensy3_pos], ax
	;mover la primera linea de asteroides
	add [aster1_posX], 5
	cmp [aster1_posX], 152
	ja pon06
	jmp cont6
  pon06: mov [aster1_posX], 0
  cont6: mov ax, [aster1_posX]
	add ax, [aster1_posY]
	mov [aster1_pos], ax
	;mover la segunda linea de asteroides
	add [aster3_posX], 25
	cmp [aster3_posX], 152
	ja pon07
	jmp cont7
  pon07: mov [aster3_posX], 0
  cont7: mov ax, [aster3_posX]
	add ax, [aster3_posY]
	mov [aster3_pos], ax
	 ;mover la tercera linea de de asteroides
	sub [aster5_posX], 5
	cmp [aster5_posX], 0
	jb pon08
	jmp cont8
  pon08: mov [aster5_posX], 72
  cont8: mov ax, [aster5_posX]
	 add ax, [aster5_posY]
	 mov [aster5_pos], ax

	;Dibuja los bichos alienigenas
	call Drawbugs

	mov dl,0
	jmp Mover_objetos
	ret

;Dibuja las naves aliens y los asteroides
Drawbugs:
    ;Primera Nave rosada
    mov     edx,  alienshipp
    mov     esi, edx
    mov     di,  [aliensp1_pos]
    call    Drawsprite
    ;tercera Nave rosada
    mov     di,  [aliensp3_pos]
    call    Drawsprite
    ;Nave amarill1a 1
    mov     edx,  alienshipy
    mov     esi, edx
    mov     di,  [aliensy1_pos]
    call    Drawsprite
    ;Nave amarill1a 3
    mov     di,[aliensy3_pos]
    call    Drawsprite
    ;Nave roja
    mov     edx,  alienshipr
    mov     esi, edx
    mov     di,[aliensr1_pos]
    call    Drawsprite
    ;roja 3
    mov     di,[aliensr3_pos]
    call    Drawsprite
    ;Asteroide
    mov     edx, asteroide
    mov     esi, edx
    mov     di,[aster1_pos]
    call    Drawsprite
    ;Asteroide 3
    mov     di,[aster3_pos]
    call    Drawsprite
    ;Asteroide 5
    mov     di,[aster5_pos]
    call    Drawsprite
    ret


fondo:	 ;seccion de codigo que q repinta otra vez el fondo
    mov ax,13h
    int 10h
    xor dx,dx
    ;call draw
    call PutObject
    ret


    SPEED	  equ 16	  ; velocidad de la nave terran (La nave avanza 16 puntos cada vez en cualquier direccion)
    keyboard:	  in  al,60h	  ; Leer el buffer del controlador del teclado
	 cmp	 al,LEFT
	 je	 .left
	 cmp	 al,DOWN
	 je	 .down
	 cmp	 al,RIGHT
	 je	 .right
	 cmp	 al,UP
	 je	 .up
	 jmp	 .exit		       ; Si no hay ninguna tecla de interés, terminar

	 .espera: mov	 ebx, [nave_oldX]
		  mov	 [nave_X], ebx
		  mov	 ebx, [nave_oldY]
		  mov	 [nave_Y], ebx
		 jmp	 .update

	 .left: sub	[nave_X],SPEED	     ; actualizar la coordenada en el framebuffer
		jmp	.update 	      ; Actualizar la pantalla

	 .down: add	[nave_Y],320*SPEED
		cmp	[nave_Y],320*190
		ja	.espera
		jmp	.update

	.right: add	[nave_X],SPEED
		jmp	.update

	   .up: sub	[nave_Y],320*SPEED
		cmp	[nave_Y],320*10
			jb Fin
       .update: call	PutObject      ; Dibujar la nave

	 .exit: mov	al,20h		; Fin de interrupción hardware
		out	20h,al
		iret


;Esto a quien mueve es a la Nave
PutObject: mov	   ebx,[nave_oldY]
	   add	   ebx,[nave_oldX]
	   mov	   edi,ebx	   ; Utilizar la coordenada anterior
	   call EraseObject
	   mov	   ebx,[nave_Y]
	   add	   ebx,[nave_X]
	   mov	   edi,ebx	  ; actualizar la vieja coordenada
	   mov	   ebx, [nave_Y]
	   mov	   [nave_oldY], ebx
	   mov	   ebx, [nave_X]
	   mov	   [nave_oldX], ebx
	   call    DrawObject		; y dibujar el objeto :-)
	   ret


EraseObject: mov     eax,0		     ; El borrado es muy simple
	     mov     ecx,16
	 @@: mov     [0xa0000+edi],eax	     ; Solo se escribe en negro
	     mov     [0xa0000+edi+4],eax     ; Esta es la forma menos elegante :-(
	     mov     [0xa0000+edi+8],eax     ; El área es un cuadrado de 16x16 píxels
	     mov     [0xa0000+edi+12],eax
	     add     edi,320
	     loop    @b
	     ret


DrawObject: mov     esi,mainship	     ; Apuntar al comienzo de la definición del objeto
	    mov     ecx,16		     ; ecx cuant las filas del objeto(16)
     .fila: mov     ebx,16		     ; ebx contará las columnas del objeto(16)
.siguiente: mov     al,[esi]		     ; Obtener los primeros 2 caracteres del objeto
	    cmp     al,0		     ; "Trampa" para simular transparencia, si el dato es cero no se dibuja ;-)
	    je	    @f
	    mov     [0xa0000+edi],al
	@@: inc     edi
	    inc     esi
	    dec     ebx
	    cmp     ebx,0
	    jne     .siguiente
	    add     edi,320-16	     ; Tener en cuanta que se han dibujado 16 píxeles
	    loop    .fila
	    ret

;Dibuja el Sprite dos veces en la misma linea ahorra tiempo
Drawsprite:
    ;dibujar el sprite segun los datos pasados a la funcion
    drawsprite8:  mov	  cx,16 	 ;El Sprite tiene 16 filas por 16 columnas
    siguiente8:   mov	  bl,16
    fila8:	  mov	  al,[esi]
		  cmp	  al,0
		  je	  abc8
		  ;Chequeo colision 1
		  mov	  ah,[fs:di]
		  cmp	  ah,0	;hubo colision
		  jne	  inicio
		  ;
		  mov	  [fs:di],al	 ;dibuja el pixel
		  ;Chequeo colision  2
		  mov	  ah,[fs:di+152]
		  cmp	  ah,0	;hubo colision
		  jne	  inicio
		  ;
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


Fin:			  ; este metodo es para escribir en modo grafico
	call	PutObject
	mov edi,name1
	mov cx,7
	ciclo:
		push cx
		mov ah,09h
		mov al,[edi]
		mov bh,0
		mov bl,1111b
		inc edi
		int 10h
		pop cx
	loop ciclo
jmp $


name1 dq 'etsanaG'     ; texto


timer:	 ; codigo del timer
	cli
	inc dl
	mov al,20h
	out 20h,al
	sti
	iret

; variables gererales y definicion de los sprites
;_________________________________________________________________________________________________
;Posición de los objetos en pantalla
;Posiciones de la Nave Terran JaJa Starcraft jaja
nave_X	    dd 152
nave_oldX   dd 152
nave_Y	    dd 320*182
nave_oldY   dd 320*100

;seis asteriodes
aster1_pos dw 320*54+72
aster3_pos dw 320*90
aster5_pos dw 320*144+152
aster1_posY dw 320*54
aster1_posX dw 72
aster3_posY dw 320*90
aster3_posX dw 0
aster5_posY dw 320*144
aster5_posX dw 152

; cuatro alienshipy
aliensy1_pos dw 320*74+152
aliensy3_pos dw 320*164+72
aliensy1_posY dw 320*74
aliensy1_posX dw 152
aliensy3_posY dw 320*164
aliensy3_posX dw 72

; cuatro alienshipr
aliensr1_pos dw 320*38+152
aliensr3_pos dw 320*128
aliensr1_posY dw 320*38
aliensr1_posX dw 152
aliensr3_posY dw 320*128
aliensr3_posX dw 0

; cuatro alienshipp
aliensp1_pos dw 320*20
aliensp3_pos dw 320*110+72
aliensp1_posY dw 320*20
aliensp1_posX dw 0
aliensp2_posY dw 320*20
aliensp2_posX dw 152
aliensp3_posY dw 320*110
aliensp3_posX dw 72
;_________________________________________________________________________________________
;Nave principal
mainship:
	db 00,00,00,00,00,00,00,23,23,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,00,23,23,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,23,28,28,23,00,00,00,00,00,00
	db 00,00,23,00,00,23,28,28,28,28,23,00,00,23,00,00
	db 00,00,23,00,00,23,28,28,28,28,23,00,00,23,00,00
	db 00,00,23,00,00,23,53,53,55,55,23,00,00,23,00,00
	db 00,00,23,00,23,23,53,55,55,55,23,23,00,23,00,00
	db 00,00,23,23,23,28,53,55,55,55,28,23,23,23,00,00
	db 00,23,28,28,23,28,28,28,28,28,28,23,28,28,23,00
	db 23,28,28,28,23,28,15,15,15,15,28,23,28,28,28,23
	db 23,28,28,28,23,28,15,15,15,15,28,23,28,28,28,23
	db 23,28,28,28,23,28,28,28,28,28,28,23,28,28,28,23
	db 23,28,23,23,23,23,23,23,23,23,23,23,23,23,28,23
	db 23,23,00,00,00,04,04,04,04,04,04,00,00,00,23,23
	db 00,00,00,00,00,00,40,40,40,40,00,00,00,00,00,00
	db 00,00,00,00,00,00,00,42,42,00,00,00,00,00,00,00

;naves alienigenas
alienshipy:
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,53,53,53,53,00,00,00,00,00,00
	db 00,00,00,00,00,53,55,55,55,55,53,00,00,00,00,00
	db 00,00,00,00,53,55,15,15,55,55,55,53,00,00,00,00
	db 00,00,00,53,55,15,53,53,55,55,53,55,53,00,00,00
	db 00,00,00,53,55,15,53,53,55,55,53,55,53,00,00,00
	db 00,00,00,53,55,15,53,53,55,55,15,55,53,00,00,00
	db 00,00,00,53,55,55,55,55,55,55,55,55,53,00,00,00
	db 00,42,44,15,15,15,44,15,44,44,44,44,44,44,42,00
	db 42,44,44,44,44,44,44,44,44,44,44,44,44,44,44,42
	db 42,44,44,04,44,44,04,44,44,04,44,44,04,44,44,42
	db 00,42,42,42,42,42,42,42,42,42,42,42,42,42,42,00
	db 00,00,42,42,42,42,42,42,42,42,42,42,42,42,00,00
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

alienshipr:
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,55,55,55,55,00,00,00,00,00,00
	db 00,00,00,00,00,55,53,53,53,53,55,00,00,00,00,00
	db 00,00,00,00,55,53,55,55,55,55,53,55,00,00,00,00
	db 00,00,00,55,53,55,15,15,55,55,55,53,55,00,00,00
	db 00,00,55,53,55,15,53,53,55,55,53,55,53,55,00,00
	db 00,00,55,53,55,15,53,53,55,55,53,55,53,55,00,00
	db 00,00,55,53,55,15,53,53,55,55,15,55,53,55,00,00
	db 00,00,55,53,55,55,55,55,55,55,55,55,53,55,00,00
	db 40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40
	db 40,43,43,43,43,43,40,43,40,40,40,40,40,40,40,40
	db 00,41,41,41,41,41,41,41,41,41,41,41,41,41,41,00
	db 00,00,22,22,00,00,22,22,22,22,00,00,22,22,00,00
	db 00,00,22,00,00,00,22,25,25,22,00,00,00,22,00,00
	db 00,25,00,00,00,00,00,25,25,00,00,00,00,00,25,00
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

alienshipp:
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,00,53,53,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,53,53,53,53,00,00,00,00,00,00
	db 00,00,00,00,00,53,55,55,55,55,53,00,00,00,00,00
	db 00,00,00,00,53,55,15,15,55,55,55,53,00,00,00,00
	db 00,00,00,53,55,15,53,53,55,55,53,55,53,00,00,00
	db 00,00,00,53,55,15,53,53,55,55,53,55,53,00,00,00
	db 00,00,00,53,55,15,53,53,55,55,15,55,53,00,00,00
	db 00,00,23,23,23,55,55,55,55,55,55,23,23,23,00,00
	db 00,23,28,28,23,23,23,23,23,23,23,23,28,28,23,00
	db 23,15,55,28,28,28,28,28,28,28,28,28,28,55,15,23
	db 00,23,23,55,15,55,55,15,15,55,55,15,55,23,23,00
	db 00,00,37,23,23,23,23,23,23,23,23,23,23,37,00,00
	db 00,00,00,37,37,37,37,37,37,37,37,37,37,00,00,00
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

asteroide:
	db 000,000,000,000,000,000,000,103,175,000,000,000,000,000,000,000
	db 000,000,000,000,000,000,103,103,175,175,000,000,000,000,000,000
	db 000,000,000,000,000,103,247,247,247,247,175,000,000,000,000,000
	db 000,000,000,103,103,103,103,247,175,175,221,175,000,000,000,000
	db 000,000,103,103,175,175,175,175,175,175,221,247,175,000,000,000
	db 000,000,103,175,103,175,175,175,221,221,175,221,221,103,000,000
	db 000,103,103,175,175,175,247,247,175,103,175,175,247,221,175,000
	db 247,103,175,247,175,103,247,247,175,103,175,247,221,221,175,000
	db 247,247,175,247,175,247,175,175,103,175,247,247,221,221,175,000
	db 000,247,247,175,221,221,221,221,247,247,247,247,221,175,000,000
	db 000,000,247,221,221,247,247,247,247,247,247,221,175,000,000,000
	db 000,000,000,247,247,103,103,175,175,247,221,175,000,000,000,000
	db 000,000,000,247,103,247,247,175,175,221,221,103,000,000,000,000
	db 000,000,000,000,247,247,247,221,221,221,175,000,000,000,000,000
	db 000,000,000,000,000,247,247,221,221,221,103,000,000,000,000,000
	db 000,000,000,000,000,000,000,247,247,103,000,000,000,000,000,000

;____________________________________________________________________________________________
times(6*512)-($-$$)db 0
