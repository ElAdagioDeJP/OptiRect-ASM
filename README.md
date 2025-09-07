# OptiRect-ASM ⚙️🖼️

Programa ultra–optimizado en Assembly (x86 real mode) para **EMU8086 / DOS** que:

- Entra a **modo VGA 13h (320x200x256)**.
- Dibuja un **rectángulo de 200x100 px** con un patrón de color **cíclico 0..15** (reinicia tras 15 sin usar divisiones).
- Superpone una **cadena de iniciales** del equipo dentro del rectángulo usando **INT 10h / AH=13h** (Write String).
- Vuelve limpiamente a modo texto.

Orientado a la **mínima cantidad de instrucciones y bytes**, priorizando registros sobre memoria y evitando operaciones costosas.

---

## 📂 Archivo Principal

El archivo fuente debe llamarse exactamente con la cadena de iniciales, ej.: `CpLmJq.asm`.

Dentro del código encontrarás marcadores para reemplazar:

```asm
; 1) Nombre Apellido - C.I.: XXXXXXXX
Texto db 'CpLmJq',0
```

---

## 🚀 Ejecución Rápida en EMU8086

1. Abre el `.asm` renombrado con tus iniciales.
2. Ensambla y ejecuta (Compile > Run).
3. Verás el rectángulo con el degrade cíclico y el texto.
4. Pulsa cualquier tecla para regresar a modo texto y finalizar.

### Alternativa (DOSBox + TASM/MASM)

1. Copia el `.asm` a la carpeta montada en DOSBox.
2. Ensambla y enlaza como `.COM` (ejemplo con MASM/TLINK):

```bash
MASM INITIALES.ASM;
LINK /T INITIALES.OBJ;
REN INITIALES.EXE INITIALES.COM
```

1. Ejecuta: `INITIALES`.

---

## 🧠 Lógica del Rectángulo (Resumen)

- Offset inicial precalculado (evita multiplicaciones en tiempo de ejecución).
- Bucle externo = 100 filas (DX).
- Bucle interno = 200 columnas (CX) usando `LOOP`.
- Escritura de píxel: `STOSB` (ES:DI) + avance automático.
- Color en `AL` se incrementa y se enmascara: `INC AL / AND AL,0Fh` (mod 16 sin `CMP` ni saltos extra).
- Fin de fila: `ADD DI,120` (320 - 200) para saltar al inicio de la siguiente.

Pseudo-estructura:

```text
for y in 0..99:
	for x in 0..199:
		*video++ = color; color = (color+1) & 0x0F
	video += 120
```

---

## ✍️ Texto de Iniciales

Se pinta con `INT 10h / AH=13h` (Write String) usando:

- `AL=01h` (mueve cursor)
- `BH=0` página, `BL=0Fh` color claro (puedes variar 0–15)
- `DH` fila y `DL` columna en coordenadas de texto (0..24 / 0..39)

Puedes reposicionar modificando `DH` / `DL` (procura mantenerlo dentro del rectángulo para el enunciado original).

---

## 🛠️ Personalización Rápida

| Elemento | Cambiar | Notas |
|----------|---------|-------|
| Iniciales | Cadena en `Texto db '...'` | Renombra también el archivo. |
| Posición rectángulo | Offset inicial en `DI` | Recalcular: `y*320 + x`. |
| Tamaño rectángulo | Constantes en `mov cx,200` y `mov dx,100` | Ajustar salto de línea: `ADD DI, 320 - ancho`. |
| Paleta cíclica | Máscara `AND AL,0Fh` | Para 0..N usar máscara adecuada (N=2^k-1). |
| Color del texto | `BL` en llamada a INT 10h | 0..15. |

---

## 🔍 Micro–Optimizaciones Aplicadas

- `STOSB` en lugar de `MOV [ES:DI],AL / INC DI` (1 instrucción vs 2).
- Ciclo de color con `AND` en vez de `CMP/JNE` (eliminas salto condicional).
- Pre-cálculo del offset de inicio (X,Y) fuera de bucles.
- Reutilización de registros: `AL`=color, `CX`=ancho, `DX`=alto.
- Un único `ADD DI,120` por fila (salto de pitch) evita multiplicaciones.
- Salida con `INT 20h` (más corta que `MOV AX,4C00h / INT 21h`).
- Segmentos: `push cs / pop ds` y `mov es,0A000h` sin redundancias.

---

## 📏 Métrica Aproximada

El núcleo de dibujo (entre modo 13h y la impresión de texto) cabe en decenas bajas de bytes; ideal para ejercicios de code–golf en modo real.

---

## 🔄 Extensiones Sugeridas (Opcionales)

- Animar desplazando el rectángulo (actualizar offset + redibujar).
- Variar máscara de color para patrones 0..7 o 0..3.
- Añadir un borde usando un segundo bucle parcial.
- Introducir doble buffer (copiar a 0A000h) para animaciones suaves.

---

## ✅ Checklist de Entrega

1. Encabezado con nombres completos y C.I.
2. Archivo renombrado EXACTAMENTE a la cadena de iniciales.
3. Cadena en el código coincide con el nombre del archivo.
4. Rectángulo 200x100 con ciclo 0..15.
5. Texto visible dentro del rectángulo.
6. Retorno a modo texto tras una tecla.

---

## ❓ FAQ Breve

**¿Por qué AND 0Fh y no modulo?** Más rápido y pequeño: mod 16 = máscara binaria.

**¿Por qué INT 10h AH=13h y no dibujar fuente manual?** Ahorra bytes y tiempo; BIOS ya tiene la fuente 8x8.

**¿Se puede quitar el NUL final del texto?** Sí, ajusta `TextoLen` si redefines la macro o usas cálculo manual.

---

## 📝 Licencia

Ver `LICENSE` (modifica si el docente exige otro formato).

---

## 🤝 Contribuciones

Enfocado a práctica académica; abre un issue si propones una optimización demostrable (menos bytes / ciclos).

---

### Fin

El reto: ¿puedes aún reducir 2–3 bytes sin sacrificar legibilidad mínima? 😉

