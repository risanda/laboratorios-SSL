# Sesión 2: Análisis de sistemas en el dominio temporal

Especificación para escribir `lab2.qmd`. Sigue el formato ya establecido por la
P1: **trabajo previo** (preparación individual, cada apartado con su ejercicio y
solución desplegable) + **trabajo de laboratorio** (sesión presencial, reutiliza
lo del previo).

## Decisiones tomadas

- **Solo `ode45`.** No usar `lsim`, `tf` ni `step`, aunque el Control System
  Toolbox esté disponible.
- **Sin Symbolic Math Toolbox** (no está instalado): nada de `dsolve`. Lo "a
  mano" se resuelve a mano y se contrasta numéricamente con `ode45`.
- **Cada apartado del trabajo previo lleva un ejercicio** con su solución
  desplegable.
- En el trabajo de laboratorio, las soluciones muestran la figura pero **no el
  código** (`%| echo: false`), como en la P1.
- Los circuitos se dibujan con el filtro `tikz.lua` ya integrado: bloques
  ```` ```{.tikz} ```` con CircuiTikZ (ojo al punto: sin él, Quarto se lo pasaría
  al kernel de MATLAB).
- Convención de color heredada de la P0 y la P1: azul la señal de referencia o
  la entrada, verde la calculada, rojo una segunda señal comparada (o las
  muestras) y negro para trazos auxiliares. Para las tres salidas superpuestas
  del RLC, verde, rojo y negro por orden de amortiguamiento, siempre con
  leyenda.
- Progresión deliberada de los conceptos: primero **condiciones iniciales** sin
  entrada (apartados 2 y 3) y después **entrada externa** con condiciones
  iniciales nulas (apartado 4); el apartado 5 prepara el RLC del laboratorio.
  Este recorre los dos casos por separado: empieza por la descarga del RC, el
  único con condición inicial no nula, y sigue con entradas sobre circuitos en
  reposo.

## Requisito previo: ampliar la P0

`ode45` se invoca con un *function handle* (`@(t,y) ...`) y el símbolo `@` no
aparece ni una sola vez en `lab0.qmd` ni en `lab1.qmd`. Antes de escribir la P2,
añadir a la P0 un apartado breve, solo lo básico:

- qué es un *handle* y cómo se crea una función anónima: `f = @(x) x.^2;`
- cómo se evalúa: `f(3)`
- cómo se pasa como argumento a otra función
- un ejercicio corto

No meter `ode45` en la P0: allí solo se enseña la sintaxis `@`.

---

## Trabajo previo

### 1. Qué es una ecuación diferencial

- Concepto: la incógnita es una **función**, no un número.
- Tabla comparativa EDO vs ecuación algebraica: qué es la incógnita, qué es la
  solución (un valor frente a una familia de funciones), qué papel juegan las
  condiciones iniciales, cómo se comprueba que una solución es correcta.
- Ejercicio: dada una lista de ecuaciones, clasificarlas en algebraicas y
  diferenciales; y comprobar por sustitución que una función dada es solución de
  una EDO concreta.

### 2. Sistemas de primer orden: velocidad en caída libre

Aquí **no se habla todavía de entrada**. La EDO es $v'(t) = g$, y lo que fija la
solución concreta dentro de la familia es la **condición inicial** $v(0) = v_0$.

Convenio de signos para toda la práctica: la posición se mide **hacia arriba**
y el suelo es el origen, $y = 0$. La gravedad apunta hacia abajo, así que es
**negativa**: $g = -9.81\ \mathrm{m/s^2}$. Con ese convenio $v_0 > 0$ es una
pelota lanzada hacia arriba y $v_0 = 0$ una que se deja caer.

- Resolución a mano: $v(t) = v_0 + g\,t$.
- Resolución con `ode45`, con la EDO escrita como *handle*.
- Insistir en que la condición inicial no es un detalle administrativo: es lo que
  selecciona una solución de entre infinitas.
- Ejercicio: resolver con `ode45` para dos condiciones iniciales distintas (una
  pelota que se deja caer, $v_0 = 0$, y otra lanzada hacia arriba, $v_0 > 0$),
  superponer la solución analítica y comprobar que coinciden.

### 3. Sistemas de segundo orden: posición en caída libre

Tampoco hay entrada. El objetivo real de este apartado —y conviene decirlo
explícitamente— es la **reducción** de una EDO de segundo orden a un sistema de
dos de primer orden, que es lo que exigirá el RLC del laboratorio.

- EDO: $y''(t) = g$, con dos condiciones iniciales, $y(0) = y_0$ y $v(0) = v_0$.
- Solución analítica, con el convenio de signos del apartado anterior:
  $y(t) = y_0 + v_0 t + \tfrac{1}{2} g t^2$, una parábola cóncava hacia abajo que
  cruza el cero al llegar al suelo.
- Vector de estado $z = [y;\ v]$, con $z_1' = z_2$ y $z_2' = g$.
- Cómo se traduce eso a la función que recibe `ode45`, y por qué ahora la
  condición inicial es un vector de dos componentes.
- Ejercicio: resolver la posición con `ode45` y comparar con la parábola
  analítica.
  

### 4. Entradas exógenas: carga de un circuito RC

Este es el apartado donde aparece por primera vez la **entrada externa**, y
conviene subrayarlo: hasta ahora la respuesta salía de la condición inicial;
aquí el condensador parte descargado y todo lo que ocurre lo provoca la señal
que entra.

- Dibujar el circuito con `{.tikz}`, señalando entrada y salida.
- Ecuación: $RC\,y'(t) + y(t) = x(t)$, con $y = v_C$ y $\tau = RC$.
- Valores: $R = 1\ \mathrm{k\Omega}$, $C = 1\ \mathrm{\mu F}$ ($\tau = 1$ ms);
  simular de 0 a 5 ms.
- Condiciones iniciales **nulas**, $y(0) = 0$, y entrada escalón de $E = 10$ V.
- Construir la entrada **reciclando la función `escalon(t, t0)`** que los alumnos
  ya escribieron en la P0: `x = @(t) E*escalon(t, 0);`. Es una buena ocasión para
  que vean que las funciones de prácticas anteriores siguen sirviendo.
- A mano: $y(t) = E\,(1 - e^{-t/\tau})$.
- Es la **respuesta forzada**: la produce íntegramente la entrada.
- Ejercicio: resolver la carga con `ode45` y superponer la expresión analítica.

Cerrar señalando el caso complementario —sin entrada y con el condensador
cargado, donde la respuesta sale solo de la energía almacenada— y anunciar que
es lo primero que harán en el laboratorio.


### 5. Introducción al circuito RLC serie

Tutorial, para que en el laboratorio ya sepan qué están mirando. Es el apartado
más cargado del previo: conviene que sea directo.

- Circuito RLC serie dibujado con `{.tikz}`, con la entrada y la salida
  señaladas.
- **La salida es la tensión en la resistencia**, $v_R(t)$. Dejarlo dicho de
  forma explícita y mantenerlo así durante toda la práctica, porque es lo que
  hace que el circuito se comporte como un filtro paso banda.
- Derivación de la ecuación en $v_C$: $LC\,v_C'' + RC\,v_C' + v_C = x(t)$, con la
  salida $v_R = RC\,v_C'$.
- Parámetros: $\alpha = R/(2L)$ y $\omega_0 = 1/\sqrt{LC}$.

**Los tres regímenes** y qué se ve en cada uno:

- $\alpha > \omega_0$ — **sobreamortiguado**: sin oscilación, lento.
- $\alpha = \omega_0$ — **crítico**: sin oscilación, lo más rápido posible.
- $\alpha < \omega_0$ — **subamortiguado**: oscila a
  $\omega_d = \sqrt{\omega_0^2 - \alpha^2}$ dentro de una envolvente
  $e^{-\alpha t}$.

**Resonancia y factor de calidad:**

- Frecuencia de resonancia $f_0 = \omega_0/2\pi$. Con los valores de la práctica,
  $f_0 \approx 1592$ Hz.
- Qué pasa en resonancia: las reactancias de $L$ y $C$ se cancelan, la impedancia
  se reduce a $R$ y **toda la tensión de entrada aparece en la resistencia**. La
  ganancia vale 1 y no hay desfase, y esto ocurre sea cual sea $R$.
- Por eso el RLC serie con salida en $R$ es un **filtro paso banda**: deja pasar
  lo que está cerca de $f_0$ y atenúa lo que se aleja por arriba o por abajo.
- Factor de calidad $Q = \omega_0 L / R = \frac{1}{R}\sqrt{L/C}$, que mide lo
  selectivo que es el filtro: el ancho de banda es aproximadamente $f_0/Q$.
- Conectar $Q$ con el régimen, que es la idea que amarra los dos bloques:
  $Q = \omega_0/2\alpha$, así que $Q > 0.5$ es subamortiguado, $Q = 0.5$ crítico
  y $Q < 0.5$ sobreamortiguado. Más $Q$ significa a la vez más selectivo y más
  oscilante.

**Ejercicio:** con $L = 10\ \mathrm{mH}$ y $C = 1\ \mathrm{\mu F}$, calcular
$\alpha$, $\omega_0$ y $Q$ para $R = 100$, $200$ y $500\ \Omega$, y determinar en
qué régimen está cada configuración. Solo a mano, sin simular todavía. Advertir
en el enunciado de que son las tres configuraciones que usarán en el
laboratorio, pero **sin adelantar el resultado**.

La tabla siguiente va en la **solución desplegable**, no en el enunciado:

| $R$ | $\alpha$ | $Q$ | régimen |
|---|---|---|---|
| 100 $\Omega$ | 5000 | 1 | subamortiguado |
| 200 $\Omega$ | 10000 | 0.5 | crítico |
| 500 $\Omega$ | 25000 | 0.2 | sobreamortiguado |

---

## Trabajo de laboratorio

Todo se resuelve con `ode45`. En los casos en que exista expresión analítica se
da hecha, para superponerla y comprobar la simulación: no hay que deducir
ninguna.

### 1. Descarga del circuito RC

Arranca con el caso complementario al del apartado 4 del previo: mismo circuito,
$R = 1\ \mathrm{k\Omega}$ y $C = 1\ \mathrm{\mu F}$, pero ahora **sin entrada** y
con el condensador cargado.

Ejercicio: resolver la descarga con `ode45` partiendo de $y(0) = V_0 = 10$ V y
$x(t) = 0$, y superponer la expresión analítica $y(t) = V_0\,e^{-t/\tau}$.

- Es la **respuesta natural**: no hay entrada, la respuesta sale solo de la
  energía que el condensador tenía almacenada.
- Que comprueben que en $t = \tau$ queda el 37 % de $V_0$.
- Cerrar con el contraste frente a la carga del previo: el circuito y la ecuación
  son los mismos, y lo único que cambia es de dónde sale la respuesta, de la
  entrada o de la condición inicial.


### 2. El circuito RC como filtro

Mismo circuito del apartado 4 del previo, $R = 1\ \mathrm{k\Omega}$ y
$C = 1\ \mathrm{\mu F}$ ($\tau = 1$ ms), con condiciones iniciales nulas. Su
frecuencia de corte es $f_c = 1/(2\pi\tau) \approx 159$ Hz.

Ejercicio: resolver con `ode45` la respuesta a dos entradas senoidales de la
misma amplitud, una de 50 Hz y otra de 1 kHz, y dibujar entrada y salida
superpuestas en una figura de 2×1.

- Cambiar de entrada cuesta reescribir una línea, ya que basta con sustituir la
  función anónima que se le pasa a `ode45`.
- Cada frecuencia necesita **su propio intervalo de simulación**: a 50 Hz el
  periodo es de 20 ms, así que hay que llegar a unos 60 ms para ver tres ciclos;
  para 1 kHz basta con 0 a 3 ms.
- Que midan la amplitud de la salida en régimen permanente y la comparen con la
  de la entrada. Ganancias analíticas, $|H| = 1/\sqrt{1 + (\omega\tau)^2}$: unos
  0.95 a 50 Hz y unos 0.16 a 1 kHz (pendientes de comprobar al escribir la
  práctica).
- La conclusión: muy por debajo de $f_c$ la señal pasa casi intacta y muy por
  encima sale atenuada y desfasada. El RC es un **filtro paso bajo**.
- Aprovechar para que se vea la diferencia entre el **transitorio** del arranque
  y el **régimen permanente**, y que la medida hay que hacerla sobre el segundo.
- Azul la entrada, verde la salida.

### 3. RLC: los tres regímenes ante un escalón

Circuito RLC serie con $L = 10\ \mathrm{mH}$ y $C = 1\ \mathrm{\mu F}$, salida en
la resistencia, condiciones iniciales nulas y entrada **escalón** de 15 V,
construido otra vez con la función `escalon`. Simular de 0 a 3 ms.

Ejercicio: simular las tres configuraciones que clasificaron en el trabajo previo
($R = 100$, $200$ y $500\ \Omega$) y dibujar **las tres salidas superpuestas en
una misma gráfica**.

- Vector de estado $z = [v_C;\ v_C']$, con $z_2' = (x - z_1 - RC\,z_2)/(LC)$ y
  salida $v_R = RC\,z_2$.
- Verde el subamortiguado, rojo el crítico y negro el sobreamortiguado, con
  leyenda. Añadir la entrada escalón en azul como referencia.
- Que identifiquen cada curva con su régimen antes de mirar la solución.
- Lo que deben observar: el subamortiguado ($R = 100$) oscila antes de asentarse;
  el crítico ($R = 200$) llega sin oscilar y es el más rápido de los tres; el
  sobreamortiguado ($R = 500$) no oscila pero es el más lento, **pese a tener más
  resistencia**, que es el resultado contraintuitivo de la sesión. Las constantes
  de tiempo dominantes son 200, 100 y 479 µs respectivamente.
- El escalón es la entrada adecuada aquí precisamente porque excita el
  transitorio y deja los tres regímenes a la vista.

### 4. RLC: comportamiento en frecuencia y resonancia

Solo con **$R = 100\ \Omega$**, que es la configuración de mayor factor de
calidad ($Q = 1$) y por tanto la más selectiva.

Ejercicio: simular la salida ante tres entradas senoidales de 15 V y frecuencias
distintas, y dibujar entrada y salida superpuestas en una figura de 3×1:

- **por debajo** de la resonancia, 500 Hz
- **en** la resonancia, 1592 Hz
- **por encima** de la resonancia, 5000 Hz

Valores de referencia para quien escriba la práctica, con la ganancia analítica
$|H| = R/\sqrt{R^2 + (\omega L - 1/\omega C)^2}$:

| frecuencia | ganancia | amplitud de $v_R$ |
|---|---|---|
| 500 Hz | 0.329 | 4.94 V |
| 1592 Hz ($f_0$) | 1.000 | 15.0 V |
| 5000 Hz | 0.334 | 5.01 V |

Las dos primeras filas están comprobadas con `ode45`; la de 5000 Hz es analítica
y queda pendiente de confirmar al escribir la práctica.

- Que midan la amplitud de salida en régimen permanente en los tres casos y la
  comparen con la ganancia teórica.
- La conclusión que deben sacar: en resonancia la salida iguala a la entrada y
  además va en fase con ella, mientras que a un lado y a otro cae de forma
  parecida. El circuito selecciona una banda de frecuencias alrededor de $f_0$.
- La simulación debe ser lo bastante larga como para que el transitorio inicial
  se apague y la medida se haga sobre el permanente.
- Cerrar el apartado con un callout que sitúe lo que acaban de ver: la
  **respuesta en frecuencia** se estudia más adelante en la asignatura y esto
  son solo unas pinceladas. Aquí se llega a ella a la brava, simulando en el
  tiempo una frecuencia cada vez; más adelante verán que el **diagrama de
  Bode** resume todo este comportamiento en una sola gráfica y explica por qué
  la salida cae a un lado y a otro de $f_0$.

---

## Al terminar la práctica

Lo que exige el README para añadir un lab nuevo, más el mantenimiento de la
documentación:

- [ ] Añadir `lab2.qmd` al menú en `_quarto.yml` (`website: sidebar: contents:`).
- [ ] Enlazarlo en la lista de `index.qmd`.
- [ ] Actualizar `CONTENIDOS.md`: objetivos, contenidos, ejercicios, aprendizajes
      e inventario acumulado (comandos nuevos `@` y `ode45`; conceptos nuevos:
      EDO, condiciones iniciales, vector de estado, respuesta natural y forzada,
      regímenes de segundo orden, resonancia y factor de calidad).
- [ ] Comprobar el render en HTML **y** en PDF, circuitos CircuiTikZ incluidos.


REGLAS:
- Usa código similar a laboratorios previos, usando funciones conocidas por los alumnos.
- Usa estilo visual de las figuras coherente con laboratorios previos.
- Para los ejemplos que deben resolverse a mano, en la medida de lo posible, elige valores numéricos sencillos de manejar.
- Para los ejemplos que solo se resuleven manualmente, elige valores realistas de los componentes.
- Usa circuitikz para la dibujar los circuitos, señala siempre la entrada (in) i la salida (out)

REDACCIÓN:
- No incluyas emojis ni iconos
- Usa cursiva exclusivamentre para palabras en inglés
- Minimiza el uso de negrita, solamente para conceptos importantes que acaban de ser introducidos o palabras clave en una frase.
