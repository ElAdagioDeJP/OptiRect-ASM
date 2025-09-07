; =============================================================
; Integrantes / Team Members: Nombre Apellido - C.I.: XXXXXXXX
; 1) 
; 2) Diego Rojas - C.I.: 27657205
; 3) Jose Farrauto - C.I.: 30696288
; 4) Marco Vilera - C.I.: 29779102
; 5) Juan Vargas - C.I.: 30448315
; Archivo: <ReemplaceConIniciales>.asm  (Renombrar EXACTO a la cadena de iniciales)
; Descripcion: Dibuja un rectangulo 200x100 con colores ciclicos 0..15 y
;              sobrepone cadena de iniciales en modo 13h (320x200x256).
; Requisitos clave: Optimizacion de instrucciones y uso de bucles minimos.
; =============================================================

org 100h                 ; Programa .COM (inicio en 100h)

; --- Entrar a modo grafico 13h ---
    mov ax,0013h         ; VGA 320x200 256 colores
    int 10h

; --- Preparar segmentos ---
    push cs              ; DS = CS (acceso a datos embebidos)
    pop ds
    mov ax,0A000h        ; Segmento de memoria de video
    mov es,ax

; --- Calculo de offset inicial (X=60,Y=50) => 50*320 + 60 = 16000 + 60 = 16060 = 3EBC h ---
    mov di,03EBCh        ; Punto superior-izquierdo del rectangulo

; --- Inicializar contadores ---
    xor ax,ax            ; AL = color inicial 0 (AH=0 no afecta) 
    mov dx,100           ; Altura (filas)

FilaLoop:
    mov cx,200           ; Ancho (columnas)
PixelLoop:
    stosb                ; Escribe AL y avanza DI
    inc al               ; Siguiente color
    and al,0Fh           ; Mod 16 (0..15)
    loop PixelLoop       ; CX-- hasta 0
    add di, (320-200)    ; Saltar el resto de la linea: +120
    dec dx               ; Siguiente fila
    jnz FilaLoop

; --- Escribir texto de iniciales dentro del rectangulo ---
; Usa INT 10h / AH=13h (Write String). En modo 13h usa BL como color.
    push cs              ; ES debe apuntar al segmento del string
    pop es               ; (BP -> offset del texto)
    lea bp, Texto        ; ES:BP -> cadena
    mov ax,1301h         ; AH=13h, AL=01h (actualiza cursor)
    mov bx,000Fh         ; BH=0 (page), BL=0Fh (color claro)
    mov cx,TextoLen      ; Longitud
    mov dh,10            ; Fila (0..24) dentro del rectangulo
    mov dl,10            ; Columna (0..39)
    int 10h

; --- Esperar tecla ---
    xor ah,ah            ; AH=0: BIOS get key
    int 16h

; --- Regresar a modo texto y salir ---
    mov ax,0003h         ; Modo texto 80x25
    int 10h
    int 20h              ; Terminar .COM (CS aun apunta al PSP)

; --- Datos ---
Texto      db '<ReemplaceConIniciales>',0  ; Sustituir por la cadena EXACTA de iniciales (sin NUL si desea ajustar)
TextoLen   equ ($-Texto)-1                 ; Excluye el byte NUL final

; Notas de optimizacion:
; - Color ciclico con INC+AND (2 instrucciones) mas barato que comparar y reiniciar.
; - Uso de STOSB evita MOV [ES:DI],AL redundante.
; - Evita multiplicaciones en tiempo de ejecucion precalculando offset inicial.
; - Reusa registros: AL = color, CX = ancho, DX = alto.
; - Un solo ADD por fila para salto de pitch.
; - INT 20h en lugar de INT 21h/4C00h reduce instrucciones final.
; =============================================================
; Cambie el nombre del archivo a: <ReemplaceConIniciales>.asm antes de entregar.
; =============================================================
