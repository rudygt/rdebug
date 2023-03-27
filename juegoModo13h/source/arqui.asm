
	[BITS 16]           	; Set 16 bit code generation
	SEGMENT junk  		; Segment containing code

  	..start:            	; The two dots tell the linker to Start Here.                  		

  
	mov  ax,data      ; Move segment address of data segment into AX
	mov  ds,ax        ; Copy address from AX into DS
	mov  es,ax	  ;
	mov  ax,stack     ; Move segment address of stack segment into AX
	mov  ss,ax        ; Copy address from AX into SS

	mov  sp,stacktop  ; Point SP to the top of the stack


Inicio:

    mov ax,0013h ; Modo Grafico VGA
    int 10h ; Interrupcion Modo de Video
    
mainLoop:
    
    mov bl,[BGColor]

    call ClearScreen
        
    mov ax, [coordY]
    mov bx, [coordX]
    call DibujarNave
    
    call Flip

    mov cx,0000h ; tiempo del delay
    mov dx,0ffffh ; tiempo del delay
    call Delay
    
        
    call HasKey   ; hay tecla? 

    jz mainLoop   ; no hay, saltar a mainLoop

    call GetCh    ; si ay, leer cual es
    call ClearIn

    cmp al, 'b'   ; si es B , seguir a la salida

    je finProg    ; saltar al final al = b

    cmp al, 'c'   ; es c?

    jne LO1

    mov bl,[BGColor]
    inc bl                 ; si era C, incremento bx para cambiar color (bl)     
    mov [BGColor], bl

    jmp mainLoop  ; continuar

LO1:

    cmp al, 'd'

    jne LO2

    ; si llega aqui, es la tecla d

    mov ax, [coordY]
    inc ax
    mov [coordY], ax

    jmp mainLoop

LO2:
    cmp al, 'a'

    jne LO3

    mov ax, [coordY]
    dec ax
    mov [coordY], ax

    jmp mainLoop

LO3:
    cmp al, 't'
    
    jne LO4

    jmp mainLoop


LO4:
    cmp al,'w'
    jne LO5
    
    mov bx, [coordX]
    dec bx
    mov [coordX], bx

    jmp mainLoop

LO5:
    cmp al,'x'
    jne mainLoop
    
    mov bx, [coordX]
    inc bx
    mov [coordX], bx

    jmp mainLoop

finProg:
    
    mov ax,3h ;Modo Texto
    int 10h
        
    mov ax, 04C00H ; salir 
    int 21H      

    mov ax, 04C00H      ; salir 
    int 21H             ; fin de programa


;=====================================================================
; flip copiar de buffer a pantalla
; casi casi es un clearscreen 
; movsd ( como stosd pero copia de memoria a memoria ) 
; movsd copia desde ds:si hacia es:di 


Flip:

    mov ax, 0a000h
    mov es, ax
    mov di,0

    mov si, buffer

    mov cx, 16000

    call VSync

    rep movsd 

    ret

;======================================================================
    ;Funcion Clear screen
    ;bl color de fondo

ClearScreen:

    mov ax, ds
    mov es,ax ;Guardar la dirección base
    mov di,buffer ;

    mov al,bl ; pasar el color a a low
    mov ah,bl ; pasar el color a a high
    shl eax,16 ; desplazar ax a la parte alta de eax
    mov al,bl
    mov ah,bl
    
    mov cx,16000 ; 64 000 bytes / 4 bytes por copia == 16 000 copias
    rep stosd ; ciclo "store string double word" repetirla 16000


    ret 

;======================================================================
    ;bx= coordenada x
    ;ax= coordenada y
    ;cl= color

PutPixel:

    push cx
    
    push ax

    mov ax, ds
    mov es,ax ;Guardar la dirección base

    pop ax

    mov cx,bx ; copiar bx a cx, para guardar temporalmente
    shl cx,8 ; desplazar 8 --> multiplicar 2^8=256
    shl bx,6 ; desplazar 6, 2^6=64

    add bx,cx ; sumar bx mas cx para un total de 320

    add ax,bx ; sumar la coordenada x
    

    add ax, buffer

    mov di, ax;    
    
    pop cx;
    
    mov byte [es: di],cl 
    
    ret

;======================================================================
    ;bx= coordenada x
    ;ax= coordenada y
    ;cl= color

DibujarNave:

    push ax

    mov ax, ds
    mov es,ax ;Guardar la dirección base

    pop ax

    mov cx,bx ; copiar bx a cx, para guardar temporalmente
    shl cx,8 ; desplazar 8 --> multiplicar 2^8=256
    shl bx,6 ; desplazar 6 --> multiplicar 2^6=64

    add bx,cx ; sumar bx mas cx para un total de 320

    add ax,bx ; sumar la coordenada x
    

    add ax, buffer

    mov di, ax;    
    
    mov si, naveFila1

    mov cx, 8
    
    rep movsb

    add ax, 320

    mov di, ax;    
    
    mov si, naveFila2

    mov cx, 8
    
    rep movsb

    add ax, 320

    mov di, ax;    
    
    mov si, naveFila3

    mov cx, 8
    
    rep movsb

    add ax, 320

    mov di, ax;    
    
    mov si, naveFila4

    mov cx, 8
    
    rep movsb

    add ax, 320

    mov di, ax;    
    
    mov si, naveFila5

    mov cx, 8
    
    rep movsb

    add ax, 320

    mov di, ax;
    
    mov si, naveFila6

    mov cx, 8
    
    rep movsb

    add ax, 320

    mov di, ax;

    mov si, naveFila7

    mov cx, 8
    
    rep movsb

    add ax, 320

    mov di, ax;

    
    ret    


;======================================================================

    ;wait for vsync ( retraso vertical ) 


VSync: 

    mov dx,03dah
    WaitNotVSync: ;wait to be out of vertical sync
    in al,dx
    and al,08h
    jnz WaitNotVSync
    WaitVSync: ;wait until vertical sync begins
    in al,dx
    and al,08h
    jz WaitVSync

    ret
    
;======================================================================
    ; Esta funcion recibe un numero de 32 bits , pero en dos partes
    ; de 16 bits c/u cx y dx. CX en la parte alta y DX en la parte baja
    ; Esta funcion causa retardos de un micro segundo = 1/1 000 000


Delay:

    mov ah , 86h
     int 15h
     ret    



;======================================================================

    ; funcion Write
    ; imprimir una cadena en pantalla
    ;
    ; Parametro dx direccion de la cadena    
    ; imprime una cadena terminada en $ en pantalla


Write:
      
    push ax            ; preservar ax 
        mov ah,0x9          ; funcion 9, imprimir en pantalla
        int 0x21             ; interrupcion dos
    pop ax            ; restaurar ax

    ret                 

;======================================================================

    ; funcion Writeln
    ; imprimir + enter
    ; Parametro dx direccion de la cadena    


Writeln:

      
        call Write          ; Display the string proper through Write
    mov dx,CRLF         ; Load offset of newline string to DX
    call Write          ; Display the newline string through Write
    
    ret                 ; Return to the caller

;======================================================================

    ; funcion HasKey
    ; hay una tecla presionada en espera?
    ; zf = 0 => Hay tecla esperando 
    ; zf = 1 => No hay tecla en espera 
    ; como el ReadKey de pascal: NO UTILIZADA


HasKey:


    push ax            

    mov ah, 0x01        ; funcion 1
    int 0x16        ; interrupcion bios

    pop ax            

    ret            


;======================================================================

    ; funcion ClearIn
    ; Borrar Buffer del Teclado
    ; NO UTILIZADA, me hiba a servir para limpiar posibles
    ; pulsaciones dobles en el menu, pero no se dio el 
    ; problema al probar con la funcion GETCH
    
    ClearIn
    
ClearInL1:
        
    call HasKey        ;    
    jz ClearInL2        ;    
    call GetCh        ;
    jmp ClearInL1        ;    
    
    ClearInL2:        
    
    ret            
        

;======================================================================

    ; funcion PutCh
    ; imprimir el caracter ascii en al, en pantalla
    ; Parametro al el caracter a imprimir

    
PutCh:

    mov ah,    0x0E        ;
    int 0x10        ;

    ret            

;======================================================================

    ; funcion NewLine
    ; nueva linea
    ; imprimir enter en pantalla


NewLine:

    mov dx, CRLF        ;
    call Write        ;
    ret            


;======================================================================

    ; funcion GetCh
    ; ascii tecla presionada
    ; Salida en al codigo ascii sin eco, via BIOS


GetCh:
    
    xor ah,ah        ;
    int 0x16        ;    
    ret            ;
    
;======================================================================
    
;======================================================================
; ********************************************************************
;                 DATA         
; ********************************************************************           
;======================================================================


    SEGMENT data  ; Segment containing initialized data

    naveFila1 DB 0 , 0 , 0 , 15 , 15 , 0 , 0 , 0 
    naveFila2 DB 0 , 0 , 15 , 3 , 3 , 15 , 0 , 0 
    naveFila3 DB 0 , 7 , 7 , 6 , 6 , 7 , 7 , 0 
    naveFila4 DB 7 , 7 , 7 , 7 , 7 , 7 , 7 , 7 
    naveFila5 DB 8 , 8 , 8 , 8 , 8 , 8 , 8 , 8 
    naveFila6 DB 4 , 4 , 4 , 0 , 0 , 4 , 4 , 4
    naveFila7 DB 0 , 4 , 0 , 0 , 0 , 0 , 4 , 0

    
    coordX DW 10        ; posicion X de la nave
    coordY DW 10        ; posicion Y de la nave

    ;color de fondo
    BGColor DB 0 ; inicialmente negro

    ;doble buffer
    buffer resb 64000     

    CRLF   DB   0DH,0AH,'$'

    strCero DB '0'


;======================================================================
; ********************************************************************
;                 STACK                   
; ********************************************************************           
;======================================================================
    



        SEGMENT stack stack     ; This means a segment of *type* "stack"
                                ; that is also *named* "stack"! Some
                                ; linkers demand that a stack segment
                                ; have the explicit type "stack"
    resb 1024              ; Reserve 64 bytes for the program stack
        stacktop:              ; It's significant that this label points to
                               ; the *last* of the reserved 64 bytes, and
                               ;  not the first!