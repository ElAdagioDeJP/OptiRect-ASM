; =============================================================
; Integrantes / Team Members:
; 1) Alejandro Chávez - C.I.: 32278392
; 2) Diego Rojas - C.I.: 27657205
; 3) Jose Farrauto - C.I.: 30696288
; 4) Marco Vilera - C.I.: 29779102
; 5) Juan Vargas - C.I.: 30448315
; =============================================================


name "AcDrJfMvJv"

org 100h ; Directiva para programas .COM, indica que el codigo inicia en la direccion 0100h.


jmp start ; Salta a la etiqueta 'start' para comenzar la ejecucion del programa.

; --- Constantes para definir las dimensiones y posicion del rectangulo ---
w        equ 200 ; Define 'w' como el ancho (width) del rectangulo.
h        equ 100 ; Define 'h' como la altura (height) del rectangulo.
start_x  equ 60  ; Define la coordenada X inicial (columna) donde empieza el rectangulo.
start_y  equ 50  ; Define la coordenada Y inicial (fila) donde empieza el rectangulo.
end_x    equ start_x + w - 1 ; Calcula y define la coordenada X final del rectangulo.
end_y    equ start_y + h - 1 ; Calcula y define la coordenada Y final del rectangulo.

; --- Datos del programa ---
texto    db 'AcDrJfMvJv'      ; Declara la cadena de texto a mostrar.
len      equ $ - texto       ; Calcula la longitud de la cadena 'texto' automaticamente.


; =============================================================
; CODIGO PRINCIPAL
; =============================================================
start:
     ; --- Establece el modo de video a 13h (320x200, 256 colores) ---
     mov ax, 13h ; Carga el valor 13h en AX para seleccionar el modo grafico.
     int 10h     ; Llama a la interrupcion de video de la BIOS para aplicar el cambio.

     ; --- Inicializa el contador de color en el registro BL ---
     xor bl, bl ; Pone a cero el registro BL. Es una forma eficiente de hacer 'mov bl, 0'.

     ; --- Dibuja el contorno del rectangulo, linea por linea ---
     ; --- DIBUJAR LINEA SUPERIOR (de derecha a izquierda) ---
     mov dx, start_y ; Carga la coordenada Y (fila) de la linea superior en DX.
     mov cx, end_x   ; Carga la coordenada X final (columna) en CX para empezar a dibujar desde ahi.
L1:
     mov ah, 0ch ; Carga la funcion 0Ch ("Escribir Pixel") de la int 10h en AH.
     mov al, bl  ; Carga el color actual (de BL) en AL para el pixel.
     int 10h     ; Llama a la interrupcion de video para dibujar el pixel en las coordenadas (CX, DX).
     
     inc bl      ; Incrementa el color para el siguiente pixel.
     cmp bl, 16  ; Compara el valor del color con 16 (los colores validos son 0-15).
     jne L1_C    ; Si el color no es 16, salta a la continuacion del bucle.
     xor bl, bl  ; Si el color es 16, lo reinicia a 0 para crear el efecto ciclico.
L1_C:
     dec cx      ; Decrementa la coordenada X (columna) para moverse a la izquierda.
     cmp cx, start_x ; Compara la columna actual con la columna inicial.
     jae L1      ; Mientras CX sea mayor o igual a start_x, repite el bucle L1.


     ; --- DIBUJAR LINEA INFERIOR (de derecha a izquierda) ---
     mov dx, end_y ; Carga la coordenada Y (fila) de la linea inferior en DX.
     mov cx, end_x ; Carga la coordenada X final (columna) en CX para empezar a dibujar desde ahi.
L2:
     mov ah, 0ch ; Carga la funcion "Escribir Pixel" en AH.
     mov al, bl  ; Carga el color actual en AL.
     int 10h     ; Dibuja el pixel en (CX, DX).
     
     inc bl      ; Incrementa el color.
     cmp bl, 16  ; Compara si el color llego a 16.
     jne L2_C    ; Si no, continua.
     xor bl, bl  ; Si si, reinicia el color a 0.
L2_C:
     dec cx      ; Decrementa la coordenada X para moverse a la izquierda.
     cmp cx, start_x ; Compara la columna actual con la columna inicial.
     jae L2      ; Mientras CX sea mayor o igual a start_x, repite el bucle L2.


     ; --- DIBUJAR LINEA IZQUIERDA (de abajo hacia arriba) ---
     mov cx, start_x ; Carga la coordenada X (columna) de la linea izquierda en CX.
     mov dx, end_y   ; Carga la coordenada Y final (fila) en DX para empezar a dibujar desde abajo.
L3:
     mov ah, 0ch ; Carga la funcion "Escribir Pixel" en AH.
     mov al, bl  ; Carga el color actual en AL.
     int 10h     ; Dibuja el pixel en (CX, DX).
     
     inc bl      ; Incrementa el color.
     cmp bl, 16  ; Compara si el color llego a 16.
     jne L3_C    ; Si no, continua.
     xor bl, bl  ; Si si, reinicia el color a 0.
L3_C:
     dec dx      ; Decrementa la coordenada Y (fila) para moverse hacia arriba.
     cmp dx, start_y ; Compara la fila actual con la fila inicial.
     jae L3      ; Mientras DX sea mayor o igual a start_y, repite el bucle L3.
     
     
     ; --- DIBUJAR LINEA DERECHA (de abajo hacia arriba) ---
     mov cx, end_x ; Carga la coordenada X (columna) de la linea derecha en CX.
     mov dx, end_y ; Carga la coordenada Y final (fila) en DX para empezar a dibujar desde abajo.
L4:
     mov ah, 0ch ; Carga la funcion "Escribir Pixel" en AH.
     mov al, bl  ; Carga el color actual en AL.
     int 10h     ; Dibuja el pixel en (CX, DX).
     
     inc bl      ; Incrementa el color.
     cmp bl, 16  ; Compara si el color llego a 16.
     jne L4_C    ; Si no, continua.
     xor bl, bl  ; Si si, reinicia el color a 0.
L4_C:
     dec dx      ; Decrementa la coordenada Y (fila) para moverse hacia arriba.
     cmp dx, start_y ; Compara la fila actual con la fila inicial.
     jae L4      ; Mientras DX sea mayor o igual a start_y, repite el bucle L4.


     ; --- Escribe la cadena de texto en la pantalla ---
     mov dh, 12  ; Carga la fila 12 en DH para la posicion del cursor.
     mov dl, 15  ; Carga la columna 15 en DL para la posicion del cursor.
     mov si, offset texto ; Carga en SI la direccion de memoria donde comienza el 'texto'.
     mov cx, len ; Carga la longitud del texto en CX para usarlo como contador del bucle.
escribir_loop:
     mov ah, 02h ; Carga la funcion 02h ("Posicionar Cursor") de la int 10h en AH.
     mov bh, 0   ; Especifica la pagina de video 0.
     int 10h     ; Llama a la interrupcion para mover el cursor a la posicion (DH, DL).

     mov ah, 09h ; Carga la funcion 09h ("Escribir Caracter y Atributo") en AH.
     mov al, [si] ; Carga en AL el caracter al que apunta SI.
     mov bl, 14  ; Carga en BL el atributo de color (14 = Amarillo brillante).
     push cx     ; Guarda el contador del bucle principal (cx) en la pila.
     mov cx, 1   ; Establece CX en 1 porque la funcion 09h repite la escritura CX veces.
     int 10h     ; Llama a la interrupcion para escribir el caracter.
     pop cx      ; Restaura el contador del bucle principal desde la pila.
     
     inc si      ; Apunta al siguiente caracter de la cadena.
     inc dl      ; Incrementa la columna para el siguiente caracter.
     loop escribir_loop ; Decrementa CX y, si no es cero, salta a 'escribir_loop'.


     ; --- Espera a que el usuario presione una tecla para salir ---
     mov ah, 00h ; Carga la funcion 00h ("Esperar Pulsacion de Tecla") de la int 16h en AH.
     int 16h     ; Llama a la interrupcion del teclado.

     ; --- Restaura el modo de video a texto (03h) y termina el programa ---
     mov ax, 03h ; Carga el valor 03h en AX para seleccionar el modo texto estandar.
     int 10h     ; Llama a la interrupcion de video para restaurar el modo texto.

ret ; Regresa el control al sistema operativo (finaliza el programa .COM).
