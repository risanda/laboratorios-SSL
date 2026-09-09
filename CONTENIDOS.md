# Contenidos docentes

Mapa de las prácticas de **Señales y Sistemas Lineales**: qué se enseña en cada
una, qué debe saber hacer el alumno al terminarla y qué herramientas acumula por
el camino. Sirve de referencia para preparar las prácticas siguientes y evitar
solapamientos o huecos.

- [Visión de conjunto](#visión-de-conjunto)
- [Práctica 0 — Introducción a MATLAB](#práctica-0--introducción-a-matlab)
- [Práctica 1 — Conversión A/D y D/A](#práctica-1--conversión-ad-y-da)
- [Inventario acumulado](#inventario-acumulado)
- [Huecos detectados](#huecos-detectados)

---

## Visión de conjunto

| | Práctica 0 | Práctica 1 |
|---|---|---|
| **Título** | Introducción a MATLAB | Conversión A/D y D/A |
| **Papel** | Prelab instrumental: la herramienta | Primer bloque de teoría aplicado |
| **Formato** | Guía *follow-along* con ejercicios resueltos | Trabajo previo + trabajo de laboratorio |
| **Ejercicios** | 14 (4 integrados + 10 propuestos), todos con solución | 11 (6 previo + 5 laboratorio) |
| **Prerrequisito** | Ninguno | Práctica 0 |
| **Idea vertebradora** | En un ordenador no existen las funciones continuas | Toda señal digital pasa por muestrear, cuantizar y reconstruir |

Las dos prácticas comparten un principio pedagógico explícito: el alumno **escribe
el código él mismo** en scripts `.m` (nunca Live Scripts), un script por ejercicio,
y cada figura empieza con `clear all; close all; clc;`.

---

## Práctica 0 — Introducción a MATLAB

### Objetivos

Al terminar, el alumno debe ser capaz de:

- Crear variables, vectores y evaluar funciones matemáticas sobre ellos.
- Utilizar todos los comandos básicos de representación gráfica.
- Entender que **en un ordenador no existen las funciones continuas**: lo que se ve
  como una curva es un conjunto de puntos próximos unidos por segmentos rectos.
- Muestrear una señal, representarla con `stem` y reconocer el aliasing.
  *(Ver [Huecos detectados](#huecos-detectados): este objetivo no llega a
  desarrollarse en la práctica.)*

### Contenidos

**1. Entorno y método de trabajo**

- Instalación: Software UV y MATLAB Online con credenciales UV.
- Las cuatro ventanas: Command Window, Editor, Workspace, Current Folder.
- Scripts `.m` frente a Live Scripts `.mlx` (estos últimos, desaconsejados).
- Higiene de entorno: `clc`, `clear`, `close all`, y por qué toda figura empieza
  con las tres.
- Autoayuda: `help <comando>` y `doc <comando>`; cómo leer un mensaje de error.

**2. Variables y operaciones básicas**

- Asignación con `=`; el `;` suprime la salida por pantalla; `%` inicia comentario.
- Operadores `+ - * / ^`; constante `pi`; función `sqrt`.

**3. Vectores**

- Generación: operador dos puntos `inicio:paso:fin`, `linspace(inicio, fin, N)` y
  literales entre corchetes `[3, 1, 4, 1, 5]`.
- Indexación: `length`, `x(1)`, `x(end)`, rangos `x(2:4)`.
- **El primer índice es 1**, no 0 (contraste explícito con C, Java y Python).

**4. Operaciones elemento a elemento**

- Por qué `*`, `/` y `^` son operadores *matriciales* y `t^2` da error sobre un
  vector.
- Los operadores con punto `.*`, `./`, `.^` como forma normal de trabajar con
  señales.
- Las funciones matemáticas nativas (`sin`, `cos`, `exp`, `log`, `abs`, `sqrt`)
  ya son vectorizadas; ángulos en radianes.
- Señal compuesta como caso de uso: $x(t) = e^{-t}\cos(2\pi t)$ exige el `.*`.

**5. Sumatorios y convolución**

- `sum(v)` como traducción directa de $\sum_n v[n]$.
- Potencia media de una señal discreta, $P = \frac{1}{N}\sum_n |x[n]|^2$, y
  verificación numérica del resultado teórico $P = A^2/2$ para una senoide
  (con demostración analítica en nota al pie), independiente de la frecuencia.
- Convolución $y[n] = \sum_k x[k]h[n-k]$ como operación central de los sistemas
  LTI y equivalente de todo filtrado digital.
- `conv(x, h)`, longitud del resultado `length(x)+length(h)-1`, y comprobación
  manual deslizando `h` sobre `x`.

**6. Representación gráfica**

- `plot(x, y)`: dibuja puntos y los une con rectas.
- Presentación obligatoria de toda gráfica: `xlabel`, `ylabel`, `title`,
  `grid on`, `'LineWidth'`.
- Superposición con `hold on` / `hold off` y `legend`.
- Especificadores de color (`b r g k m`), estilo (`- -- : -.`) y marcador
  (`o * . s`).
- Control de ejes: `xlim`, `ylim`, `axis([...])`.
- `subplot(filas, columnas, k)` con explicación de la numeración de celdas
  (izquierda a derecha, arriba abajo) y diagrama de una rejilla 2×3.
- `stem` para señales discretas $x[n]$; alternativa `plot(n, x, 'o')` sin trazo.
- `stairs` como reconstrucción continua por **retenedor de orden cero (ZOH)**,
  no como representación de una señal discreta — anticipa la Práctica 1.
- Aplicación transversal: `abs(x)` como rectificador de onda completa.

**7. Funciones propias**

- Sintaxis `function [s1, s2] = nombre(e1, e2) ... end`.
- Reglas: el archivo se llama igual que la función, debe estar en la carpeta
  actual, la función tiene *workspace* local, solo salen las variables de salida.
- Cuándo usar función y cuándo script.
- Ejemplos desarrollados: `senoide(A, f, t)` y `escalon(t, t0)`.
- Comparación booleana vectorizada `t >= t0` + `double()` como forma idiomática de
  construir un escalón, frente a la versión con `for`/`if` (incluida y comentada
  como *menos eficiente*).

### Ejercicios

Integrados en el texto:

1. Representar $x(t)=e^{-t}$ en $[0,5]$ con 300 puntos, con etiquetas y rejilla.
2. Superponer $\sin(2\pi t)$ y $e^{-t}\sin(2\pi t)$ en $[0,3]$ con estilos y leyenda.
3. `subplot` 2×1 con $\cos(2\pi t)$ y $|\cos(2\pi t)|$.
4. Escribir la función `escalon(t, t0)` y representarla para $t_0 = 1$.

Propuestos, de menor a mayor dificultad:

5. Vector de impares del 1 al 19 con el operador `:`; `length`, primer y último
   elemento, y elementos en posición par.
6. Senoide amortiguada $e^{-t}\sin(6\pi t)$ con 500 puntos.
7. `subplot` 3×1: $\cos(4\pi t)$, su valor absoluto y su cuadrado.
8. Función `pulso(t, A, dur, retardo)`: pulso cuadrado parametrizado.
9. Onda cuadrada con `square`; potencia media con `sum` frente al teórico $A^2$.
10. Muestreo de $\sin(4\pi t)$ a $f_s = 10$ Hz superponiendo `plot`, `stem` y
    `stairs` — ensayo directo de la Práctica 1.
11. Convolución de un pulso discreto con una exponencial $e^{-0.3n}$; tres `stem`
    en subplots; razonar la longitud de la salida.
12. Filtrado de ruido: señal con `randn` (semilla fija con `rng(0)`) suavizada por
    **media móvil** de $M=9$ vía `conv(x, ones(1,M)/M, 'same')`.
13. Función con **dos salidas** `[E, P] = energia_potencia(x)` aplicada a tres
    señales distintas.
14. **Síntesis de Fourier**: aproximar una onda cuadrada con $k = 1, 3, 9, 49$
    armónicos impares en una figura 2×2 y observar el **fenómeno de Gibbs**.

### Aprendizajes

- **Instrumentales**: manejo autónomo del entorno, escritura de scripts y
  funciones reutilizables, depuración a partir del mensaje de error.
- **Conceptuales**: la discretización es inherente al cálculo por ordenador; una
  señal es un vector y el vector de tiempos es una decisión de diseño;
  `plot`/`stem`/`stairs` no son estilos gráficos sino **tres objetos matemáticos
  distintos** (continua, discreta, reconstruida).
- **Puentes hacia la teoría** sembrados aquí y recogidos después: potencia media,
  convolución como filtrado LTI, ZOH, series de Fourier y Gibbs, media móvil como
  filtro paso bajo.

---

## Práctica 1 — Conversión A/D y D/A

Recorre la **cadena completa de digitalización**: señal analógica → muestreo →
cuantización → reconstrucción. Se divide en *trabajo previo* (preparación
individual antes de la sesión, con soluciones desplegables) y *trabajo de
laboratorio* (sesión presencial, que reutiliza las funciones escritas en el
previo).

### Objetivos

Al terminar, el alumno debe ser capaz de:

- Distinguir una señal "continua" (vector de tiempos muy denso) de una señal
  **discreta** (muestras cada $T_s = 1/f_s$), y representar cada una con `plot`,
  `stem` o `stairs` según corresponda.
- Reconocer el **aliasing**, explicar por qué dos señales distintas dan las mismas
  muestras y aplicar el criterio de **Nyquist** ($f_s > 2f_{\max}$).
- **Cuantizar** con un número dado de bits, por redondeo y por truncamiento, y
  medir la degradación mediante el error máximo y la **SQNR**.
- **Reconstruir** una señal a partir de sus muestras con ZOH y con interpolación
  ideal (sinc), y comparar ambas con la original.

### Contenidos: trabajo previo

**1. La ilusión de la continuidad**

- La misma senoide de 1 Hz dibujada con $N = \{5, 10, 50, 500\}$ puntos: la curva
  suave aparece solo al aumentar $N$.
- Criterio de elección del vector de tiempos: `linspace(t1, t2, N)` cuando se pide
  una "continua" de $N$ puntos; `t1:Ts:t2` cuando se muestrea a $f_s$.

**2. Muestreo**

- Muestrear = quedarse con los valores en $t = \{0, T_s, 2T_s, \dots\}$.
- La señal continua y sus muestras se generan **con la misma fórmula**: lo único
  que cambia es el vector de tiempos.
- Convención gráfica del resto de la práctica: azul continua, rojo muestras,
  verde reconstruida.

**3. Aliasing y Nyquist**

- Experimento canónico: senoides de 1 Hz y 6 Hz muestreadas ambas a $f_s = 5$ Hz
  producen **muestras idénticas**; la de 6 Hz aparenta ser de 1 Hz.
- Frecuencia de Nyquist $2f_{\max}$ y condición $f_s > 2f_{\max}$.
- Concepto de frecuencia **fantasma** o *alias*.
- El aliasing es **irreversible** → necesidad del **filtro anti-aliasing** previo
  al muestreo.

**4. Cuantización**

- Aproximación de cada muestra a un nivel discreto dentro de un rango.
- Dos criterios, con código proporcionado: `cuant_redondeo` (`round`, al nivel más
  cercano) y `cuant_truncamiento` (`floor`, al nivel inferior).
- Parámetros: $L = 2^N$ niveles y paso $\Delta = (A_{max}-A_{min})/2^N$;
  saturación al rango con `min(max(...))`.
- Error de cuantización $e = x_q - x$; error máximo $\Delta/2$ en redondeo.
- **SQNR** en dB: $10\log_{10}\left(\sum x[n]^2 / \sum e[n]^2\right)$.
- Regla práctica $\text{SQNR} \approx 6{,}02N + 1{,}76$ dB → **~6 dB por bit**,
  verificada numéricamente cambiando $N$.

**5. Reconstrucción D/A**

- Por qué hace falta interpolar: la señal discreta solo existe en los instantes
  de muestreo.
- **ZOH**: mantener cada muestra constante hasta la siguiente. Función
  `interp_zoh` proporcionada, escrita con dos bucles anidados explícitos y muy
  comentada (pensada para leerse, no para ser eficiente).
- Diferencia entre `stairs` (solo dibuja) e `interp_zoh` (devuelve la señal
  evaluada en `tc`, con la que se puede seguir calculando: error, potencia…).
- Mención de la interpolación lineal como escalón intermedio de sofisticación.
- **Teorema de muestreo de Nyquist-Shannon** y fórmula de interpolación ideal
  $x(t) = \sum_n x[n]\,\mathrm{sinc}\!\left(\frac{t-nT_s}{T_s}\right)$.

Ejercicios del trabajo previo:

1. Senoide con $N = \{5,10,50,500\}$ puntos en una figura 2×2 (código incompleto
   con huecos `???`).
2. Senoide de 1 Hz con 1000 puntos superpuesta a sus muestras a 5 Hz.
3. Aliasing: figura 1×2 comparando 1 Hz y 6 Hz muestreadas a 5 Hz.
4. Implementar `calcula_sqnr(x, xq)` en su propio archivo `.m`.
5. Cuantizar una senoide de 5 Hz con 2 bits por redondeo; error máximo y SQNR.
6. Usar `interp_zoh` para reconstruir una senoide de 1 Hz muestreada a 10 Hz y
   dibujar original + muestras + reconstruida.

### Contenidos: trabajo de laboratorio

**Muestreo** — sección presente en el índice pero **sin contenido**
(ver [Huecos detectados](#huecos-detectados)).

**Cuantización**

7. Comparativa **redondeo vs. truncamiento** sobre una senoide de 5 Hz en una
   figura 2×2 (las dos señales cuantizadas arriba, sus dos errores abajo).
   Ejecución para $N = \{2,3,4\}$ y **tabla de resultados rellenada a mano**:
   bits, niveles, resolución, error máximo y SQNR. Es el ejercicio que convierte
   la regla de los 6 dB/bit en dato medido por el alumno.
8. **Cuantización de audio real**: `[y,Fs] = audioread('p44100.wav')`, elección
   razonada del rango, escucha con `sound(yq, Fs)` para varios $N$ y correlación
   entre calidad perceptual y SQNR.

**Reconstrucción**

9. Implementar `interp_ideal(xn, tn, tc)` completando un esqueleto: obtener $T_s$
   de `tn(2)-tn(1)` y escribir el sumatorio `sum(xn .* sinc((tc(k)-tn)/Ts))`.
10. Repetir el experimento del ZOH con `interp_ideal` y comparar visualmente.
11. **Barrido de frecuencia**: aumentar la frecuencia de la senoide de 1 en 1 Hz
    y observar qué ocurre al acercarse a $f_s/2$ y al superarla.

### Aprendizajes

- **Instrumentales**: traducir una fórmula de sumatorio a código vectorizado;
  escribir funciones reutilizables entre sesiones; comparar métodos sobre una
  misma señal con una figura multipanel; medir en vez de opinar.
- **Conceptuales**: la frontera continuo/discreto es una elección del vector de
  tiempos; el aliasing es pérdida irreversible de información, no un artefacto
  visual; la cuantización tiene un coste cuantificable y predecible; ZOH es lo
  que hace un D/A real y sinc es el ideal inalcanzable.
- **Transferencia**: el ejercicio de audio conecta una métrica en dB con una
  experiencia perceptual; el barrido de frecuencia hace *descubrir* Nyquist en
  lugar de enunciarlo.

---

## Inventario acumulado

**Comandos de MATLAB introducidos**

| Bloque | P0 | P1 |
|---|---|---|
| Entorno | `clc`, `clear`, `close all`, `help`, `doc` | — |
| Vectores | `:`, `linspace`, `[]`, `length`, `end`, `zeros`, `size` | — |
| Operadores | `.*`, `./`, `.^` | — |
| Matemáticas | `sin`, `cos`, `exp`, `log`, `sqrt`, `abs`, `sum`, `conv`, `square`, `randn`, `rng`, `double` | `round`, `floor`, `min`, `max`, `log10`, `sinc` |
| Gráficas | `plot`, `stem`, `stairs`, `hold`, `legend`, `xlabel`, `ylabel`, `title`, `grid`, `xlim`, `ylim`, `axis`, `subplot` | — |
| Control y E/S | `function`, `for`, `if` | `fprintf`, `sprintf`, `audioread`, `sound` |

**Funciones que escribe el alumno** (activo reutilizable entre prácticas)

| Función | Origen | Reutilizada en |
|---|---|---|
| `senoide(A, f, t)` | P0 (ejemplo) | — |
| `escalon(t, t0)` | P0 (ej. 4) | — |
| `pulso(t, A, dur, retardo)` | P0 (ej. 8) | P0 (ej. 11) |
| `energia_potencia(x)` | P0 (ej. 13) | — |
| `calcula_sqnr(x, xq)` | P1 previo (ej. 4) | P1 laboratorio (ej. 7, 8) |
| `interp_ideal(xn, tn, tc)` | P1 laboratorio (ej. 9) | P1 (ej. 10, 11) |

Proporcionadas ya escritas: `cuant_redondeo`, `cuant_truncamiento`, `interp_zoh`.

**Conceptos de teoría tocados**

Potencia media y energía · convolución y sistemas LTI · escalón unitario y pulso ·
serie de Fourier y fenómeno de Gibbs · media móvil como filtro · muestreo ·
aliasing y filtro anti-aliasing · Nyquist-Shannon · cuantización uniforme · SQNR y
regla de 6 dB/bit · ZOH e interpolación sinc.

---

## Huecos detectados

Puntos a resolver, relevantes para planificar las prácticas siguientes:

1. **`lab1.qmd`: sección "Muestreo" del trabajo de laboratorio vacía.** Aparece
   como encabezado entre "Trabajo de laboratorio" y "Cuantización" sin ningún
   contenido. Es justamente donde encajaría un ejercicio presencial de aliasing.
2. **Falta el archivo `p44100.wav`.** El ejercicio 8 de la P1 lo carga con
   `audioread` y no está en el repositorio; el alumno no puede ejecutarlo.
3. **Objetivo de la P0 no cumplido.** Entre los objetivos declarados figura
   "muestrear una señal, representarla con `stem` y reconocer el **aliasing**",
   pero la palabra *aliasing* no vuelve a aparecer en toda la práctica: el
   concepto se introduce en la P1. O se añade una demostración breve en la P0, o
   se retira el objetivo.
4. **Objetivos declarados sin verificación explícita.** Ninguna de las dos
   prácticas incluye entregable, rúbrica ni criterio de evaluación; conviene
   decidir el formato antes de escribir la P2.
5. **La numeración de ejercicios es implícita.** El filtro `callouts.lua` numera
   automáticamente, pero el texto de la P1 remite a "tu solución del Ejercicio 6",
   una referencia frágil ante cualquier inserción. Merece la pena usar
   referencias cruzadas de Quarto si el material va a crecer.
