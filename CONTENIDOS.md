# Contenidos docentes

Mapa de las prácticas de **Señales y Sistemas Lineales**: qué se enseña en cada
una, qué debe saber hacer el alumno al terminarla y qué herramientas acumula por
el camino. Sirve de referencia para preparar las prácticas siguientes y evitar
solapamientos o huecos.

- [Visión de conjunto](#visión-de-conjunto)
- [Práctica 0 — Introducción a MATLAB](#práctica-0--introducción-a-matlab)
- [Práctica 1 — Conversión A/D y D/A](#práctica-1--conversión-ad-y-da)
- [Práctica 2 — Análisis en el dominio temporal](#práctica-2--análisis-de-sistemas-en-el-dominio-temporal)
- [Inventario acumulado](#inventario-acumulado)
- [Pendientes](TODO.md) — lo que queda por resolver

---

## Visión de conjunto

| | Práctica 0 | Práctica 1 | Práctica 2 |
|---|---|---|---|
| **Título** | Introducción a MATLAB | Conversión A/D y D/A | Análisis de sistemas en el dominio temporal |
| **Papel** | Prelab instrumental: la herramienta | Primer bloque de teoría aplicado | Del análisis de señales al de sistemas |
| **Formato** | Guía *follow-along* con ejercicios resueltos | Trabajo previo + trabajo de laboratorio | Trabajo previo + trabajo de laboratorio |
| **Ejercicios** | 15 (5 integrados + 10 propuestos), todos con solución | 12 (6 previo + 6 laboratorio) | 9 (5 previo + 4 laboratorio) |
| **Prerrequisito** | Ninguno | Práctica 0 | Prácticas 0 y 1 |
| **Idea vertebradora** | En un ordenador no existen las funciones continuas | Toda señal digital pasa por muestrear, cuantizar y reconstruir | La respuesta de un sistema sale de dos sitios: la entrada y la condición inicial |

Las tres prácticas comparten un principio pedagógico explícito: el alumno **escribe
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

**8. Funciones anónimas y *handles***

- El operador `@`: crear una función de una línea sin abrir un archivo `.m`.
- Cómo se evalúa (`f(3)`) y que sigue siendo vectorizada.
- Que la función anónima **captura** el valor que tenían las variables al
  crearla, no el que tengan después.
- Un *handle* es una variable que contiene una función, y por eso se puede pasar
  como argumento a otra función. Añadido como requisito de la P2, donde `ode45`
  recibe la ecuación diferencial en esa forma.

### Ejercicios

Integrados en el texto:

1. Representar $x(t)=e^{-t}$ en $[0,5]$ con 300 puntos, con etiquetas y rejilla.
2. Superponer $\sin(2\pi t)$ y $e^{-t}\sin(2\pi t)$ en $[0,3]$ con estilos y leyenda.
3. `subplot` 2×1 con $\cos(2\pi t)$ y $|\cos(2\pi t)|$.
4. Escribir la función `escalon(t, t0)` y representarla para $t_0 = 1$.
5. Definir con `@` la función anónima $p(x) = 3x^2 - 2x + 1$, evaluarla y
   representarla.

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

**Muestreo**

- Señal **multicomponente**: cada componente sufre el aliasing por separado, así
  que una puede quedar bien muestreada mientras la otra se pliega.
- Fórmula del alias: $f_{alias} = |f - k f_s|$ con $k = \operatorname{round}(f/f_s)$.
- Dos casos degenerados explotados a fondo: muestrear **justo** a $2f_{max}$
  (la componente cae en $f_s/2$, sus muestras son todas nulas y desaparece — de ahí
  que Nyquist sea una desigualdad **estricta**) y el **solapamiento de alias**
  (dos componentes distintas producen muestras idénticas y sus amplitudes se suman).

7. Muestrear $x(t)=\sin(2\pi 3t)+0.5\sin(2\pi 11 t)$ a
   $f_s = \{40, 22, 15, 8\}$ Hz con un bucle `for` sobre una figura 2×2; predecir
   los alias con la fórmula y rellenar una tabla; explicar los casos $f_s = 22$ Hz
   (la componente de 11 Hz se anula) y $f_s = 8$ Hz (su alias cae en 3 Hz y se
   funde con la otra componente, de modo que las muestras describen exactamente
   $1.5\sin(2\pi 3t)$).

**Cuantización**

8. Comparativa **redondeo vs. truncamiento** sobre una senoide de 5 Hz en una
   figura 2×2 (las dos señales cuantizadas arriba, sus dos errores abajo).
   Ejecución para $N = \{2,3,4\}$ y **tabla de resultados rellenada a mano**:
   bits, niveles, resolución, error máximo y SQNR. Es el ejercicio que convierte
   la regla de los 6 dB/bit en dato medido por el alumno.
9. **Cuantización de audio real**: `[y,Fs] = audioread('p44100.wav')`, elección
   razonada del rango, escucha con `sound(yq, Fs)` para varios $N$ y correlación
   entre calidad perceptual y SQNR.

**Reconstrucción**

10. Implementar `interp_ideal(xn, tn, tc)` completando un esqueleto: obtener $T_s$
   de `tn(2)-tn(1)` y escribir el sumatorio `sum(xn .* sinc((tc(k)-tn)/Ts))`.
11. Repetir el experimento del ZOH con `interp_ideal` y comparar visualmente.
12. **Barrido de frecuencia**: aumentar la frecuencia de la senoide de 1 en 1 Hz
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
  experiencia perceptual; el ejercicio de muestreo multicomponente y el barrido de
  frecuencia hacen *descubrir* Nyquist en lugar de enunciarlo.

---

## Práctica 2 — Análisis de sistemas en el dominio temporal

El salto conceptual de la asignatura: se deja de manipular señales para estudiar
**sistemas**, resolviendo la ecuación diferencial que los describe. Todo con
`ode45`, sin `lsim` ni Symbolic Math Toolbox.

### Objetivos

Al terminar, el alumno debe ser capaz de:

- Reconocer una ecuación diferencial y entender por qué su solución es una
  función y no un número, y qué papel juegan las **condiciones iniciales**.
- Resolver numéricamente ecuaciones de primer y segundo orden con `ode45`,
  escribiendo la ecuación como función anónima.
- **Reducir** una ecuación de segundo orden a un sistema de dos de primer orden
  mediante un vector de estado.
- Distinguir la **respuesta natural** de la **respuesta forzada**.
- Identificar los tres **regímenes** de un sistema de segundo orden y
  relacionarlos con el **factor de calidad**.
- Observar el efecto de la **resonancia** en un circuito RLC serie.

### Contenidos: trabajo previo

La progresión de los conceptos es deliberada: primero condiciones iniciales sin
entrada, después entrada externa con condiciones iniciales nulas.

**1. Qué es una ecuación diferencial**

- La incógnita es una función, no un número; la solución es una familia y hace
  falta una condición inicial para concretarla.
- Tabla comparativa con la ecuación algebraica.
- Comprobación de una solución por sustitución.

**2. Sistemas de primer orden: velocidad en caída libre**

- $v'(t) = g$, sin entrada: lo único que selecciona una solución es $v(0) = v_0$.
- Convenio de signos de toda la práctica: posición hacia arriba, suelo en el
  origen, $g = -9.81\ \mathrm{m/s^2}$.
- Sintaxis de `ode45`: *handle*, `tspan` y condición inicial.

**3. Sistemas de segundo orden: posición en caída libre**

- $y''(t) = g$ con dos condiciones iniciales; la parábola analítica.
- El **vector de estado** $z = [y;\ v]$ y la reducción a dos ecuaciones de primer
  orden, que es el objetivo real del apartado y lo que exige el RLC.
- La función anónima devuelve ahora un vector columna.

**4. Entradas exógenas: carga de un circuito RC**

- Primera aparición de una **entrada externa**. Circuito dibujado con CircuiTikZ.
- $RC\,y' + y = x$, constante de tiempo $\tau = RC$.
- Carga con condiciones iniciales nulas y escalón de 10 V: respuesta forzada,
  $y(t) = E(1 - e^{-t/\tau})$, con el 63 % alcanzado en $t = \tau$.
- Reutilización de la función `escalon` de la P0 para construir la entrada.

**5. Introducción al circuito RLC serie**

- Circuito dibujado con CircuiTikZ. **La salida es la tensión en la
  resistencia**, que es lo que lo convierte en filtro paso banda.
- $LC\,v_C'' + RC\,v_C' + v_C = x$, con $v_R = RC\,v_C'$.
- $\alpha = R/2L$, $\omega_0 = 1/\sqrt{LC}$ y los tres regímenes.
- Resonancia: en $f_0$ las reactancias se cancelan y toda la entrada aparece en
  la resistencia, con ganancia 1 y sin desfase, sea cual sea $R$.
- Factor de calidad $Q = \omega_0 L/R$, ancho de banda $\approx f_0/Q$, y el
  puente entre los dos bloques: $Q = \omega_0/2\alpha$, así que más $Q$ es a la
  vez más selectivo y más oscilante.

Ejercicios del trabajo previo:

1. Clasificar ecuaciones en algebraicas y diferenciales; comprobar una solución
   por sustitución y deducir su condición inicial.
2. Resolver la velocidad con `ode45` para dos condiciones iniciales distintas.
3. Resolver la posición con `ode45` usando el vector de estado.
4. Carga del RC con `ode45` y entrada construida con `escalon`.
5. Calcular $\alpha$, $\omega_0$ y $Q$ para tres valores de $R$ y clasificar el
   régimen de cada configuración, solo a mano.

### Contenidos: trabajo de laboratorio

Todo con `ode45`; las expresiones analíticas se dan hechas para superponerlas.

6. **Descarga del RC**: respuesta natural, sin entrada y con el condensador
   cargado a 10 V. Queda el 37 % en $t = \tau$, imagen especular del 63 % de la
   carga. Cierra el contraste entrada frente a condición inicial.
7. **El RC como filtro**: senoides de 50 Hz y 1 kHz sobre un circuito con
   $f_c \approx 159$ Hz, cada una con su intervalo de simulación. Ganancias
   medidas 0.954 y 0.157, coincidentes con la teoría. Sirve además para ver la
   diferencia entre transitorio y régimen permanente.
8. **RLC: los tres regímenes ante un escalón**: las tres configuraciones
   superpuestas en una gráfica. El resultado contraintuitivo de la sesión es que
   el sobreamortiguado es el más lento pese a tener más resistencia (constantes
   dominantes de 200, 100 y 479 µs).
9. **RLC: resonancia**: con $R = 100\ \Omega$ (mayor $Q$), senoides a 500 Hz,
   1592 Hz y 5000 Hz. Ganancias 0.329, 0.996 y 0.334: en resonancia la salida
   iguala a la entrada y cae de forma parecida a ambos lados. Cierra con un
   callout situando el diagrama de Bode como lo que vendrá después.

### Aprendizajes

- **Instrumentales**: escribir una ecuación diferencial como *handle*; manejar
  `ode45` y su vector de condiciones iniciales; construir entradas como funciones
  anónimas y cambiarlas sin tocar el resto; medir sobre el régimen permanente y
  no sobre el transitorio.
- **Conceptuales**: la condición inicial no es burocracia, es lo que concreta la
  solución; toda respuesta se descompone en natural y forzada; un sistema de
  segundo orden tiene tres comportamientos cualitativamente distintos según quién
  gane entre disipación y oscilación; amortiguamiento y selectividad en
  frecuencia son la misma propiedad vista de dos maneras.
- **Puentes**: la reducción a vector de estado prepara el espacio de estados; la
  resonancia y el paso banda anticipan la respuesta en frecuencia y el diagrama
  de Bode, señalados explícitamente como materia posterior.

---

## Inventario acumulado

**Comandos de MATLAB introducidos**

| Bloque | P0 | P1 | P2 |
|---|---|---|---|
| Entorno | `clc`, `clear`, `close all`, `help`, `doc` | — | — |
| Vectores | `:`, `linspace`, `[]`, `length`, `end`, `zeros`, `size` | — | — |
| Operadores | `.*`, `./`, `.^` | — | — |
| Matemáticas | `sin`, `cos`, `exp`, `log`, `sqrt`, `abs`, `sum`, `conv`, `square`, `randn`, `rng`, `double` | `round`, `floor`, `min`, `max`, `log10`, `sinc` | — |
| Gráficas | `plot`, `stem`, `stairs`, `hold`, `legend`, `xlabel`, `ylabel`, `title`, `grid`, `xlim`, `ylim`, `axis`, `subplot` | — | — |
| Control y E/S | `function`, `for`, `if` | `fprintf`, `sprintf`, `audioread`, `sound` | — |
| Funciones y EDO | `@` (anónimas y *handles*) | — | `ode45` |

**Funciones que escribe el alumno** (activo reutilizable entre prácticas)

| Función | Origen | Reutilizada en |
|---|---|---|
| `senoide(A, f, t)` | P0 (ejemplo) | — |
| `escalon(t, t0)` | P0 (ej. 4) | P2 (previo ej. 4; laboratorio ej. 8) |
| `pulso(t, A, dur, retardo)` | P0 (ej. 8) | P0 (ej. 11) |
| `energia_potencia(x)` | P0 (ej. 13) | — |
| `p(x)` anónima | P0 (ej. 5) | patrón reutilizado en toda la P2 |
| `calcula_sqnr(x, xq)` | P1 previo (ej. 4) | P1 laboratorio (ej. 8, 9) |
| `interp_ideal(xn, tn, tc)` | P1 laboratorio (ej. 10) | P1 (ej. 11, 12) |

Proporcionadas ya escritas: `cuant_redondeo`, `cuant_truncamiento`, `interp_zoh`.

**Conceptos de teoría tocados**

Potencia media y energía · convolución y sistemas LTI · escalón unitario y pulso ·
serie de Fourier y fenómeno de Gibbs · media móvil como filtro · muestreo ·
aliasing y filtro anti-aliasing · Nyquist-Shannon · cuantización uniforme · SQNR y
regla de 6 dB/bit · ZOH e interpolación sinc · ecuación diferencial y condiciones
iniciales · vector de estado y reducción de orden · respuesta natural y forzada ·
constante de tiempo · transitorio y régimen permanente · filtro paso bajo y paso
banda · regímenes de segundo orden · resonancia y factor de calidad.
