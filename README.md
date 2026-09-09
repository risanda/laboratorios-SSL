# Prácticas de MATLAB — Señales y Sistemas Lineales

**Proyecto Quarto** (sitio web) con las prácticas de laboratorio. Cada práctica
(`lab0.qmd`, `lab1.qmd`, …) ejecuta MATLAB real a través del kernel
`jupyter_matlab_kernel` de [`jupyter-matlab-proxy`](https://github.com/mathworks/jupyter-matlab-proxy).
El sitio (`_quarto.yml`, `project: type: website`) genera un HTML con **menú lateral
izquierdo** para navegar entre labs; cada lab se puede descargar además en **PDF**.

## Contenido actual

- **Práctica 0 — Introducción a MATLAB** (`lab0.qmd`): variables, vectores,
  indexación, operaciones elemento a elemento, sumatorios, convolución,
  representación gráfica (`plot`, `hold on`, `axis`, `subplot`, `stem`, `stairs`)
  y creación de funciones en ficheros `.m`. 14 ejercicios con solución.
- **Práctica 1 — Conversión A/D y D/A** (`lab1.qmd`): muestreo, aliasing y
  criterio de Nyquist, filtro anti-aliasing, cuantización (SQNR) y reconstrucción
  (ZOH e interpolación ideal). Se divide en **trabajo previo** (ejercicios con
  solución desplegable, para hacer antes de la sesión) y **trabajo de
  laboratorio**, que reutiliza las funciones escritas en el trabajo previo
  (`calcula_sqnr`, `interp_zoh`, `interp_ideal`, …).

## Estructura de ficheros

- `_quarto.yml` — configuración compartida (kernel, filtros, formatos, ejecución,
  menú lateral). Los `.qmd` heredan de aquí; su cabecera es mínima (solo `title:`).
- `index.qmd` — portada del sitio.
- `lab0.qmd`, `lab1.qmd`, … — las prácticas.
- `callouts.lua` — filtro de callouts de ejercicio/solución (ver más abajo).
- `_site/` — salida generada (HTML + PDF). No se edita a mano.
- `_freeze/`, `.jupyter_cache/`, `.quarto/` — cachés de ejecución y de proyecto
  (ver *Freeze y caché*). Se regeneran solas; se pueden borrar.
- `lab*.quarto_ipynb*` — notebooks intermedios que Quarto deja cuando un render
  se interrumpe. Son basura: se pueden borrar sin consecuencias.

## Compilar

En este equipo el `~/.zshrc` ya exporta lo necesario (MATLAB en el `PATH`,
`MWI_USE_EXISTING_LICENSE=True` para reutilizar la licencia local, y TinyTeX de
Quarto para el PDF). Con eso:

```bash
cd laboratorios-SSL
quarto render --to html          # construye el SITIO en _site/ (solo HTML)
quarto preview                   # vista en vivo del sitio (recarga al guardar)
quarto render lab0.qmd --to pdf  # PDF de un lab, a demanda (va a _site/lab0.pdf)
```

**Importante:** construye el sitio con `--to html`. Un `quarto render` sin `--to`
intentaría generar también el PDF de todas las páginas (lento, MATLAB en dos
formatos). El PDF se pide por fichero.

En otro equipo, o si no usas el `.zshrc`, antepón la receta de licencia/PATH:

```bash
MWI_USE_EXISTING_LICENSE=True \
PATH="/Applications/MATLAB_R2024a.app/bin:$HOME/Library/TinyTeX/bin/universal-darwin:$PATH" \
  quarto render --to html
```

### Añadir una práctica nueva (`labX`)

1. Crea `labX.qmd` con cabecera mínima: `--- \n title: "Práctica X: ..." \n ---`
   (hereda kernel, formato y filtros de `_quarto.yml`).
2. Añade una línea al menú en `_quarto.yml`, bajo `website: sidebar: contents:`:
   `- text: "Práctica X — ..."` / `  href: labX.qmd`.
3. Enlázala también en la lista de `index.qmd`.

## Freeze y caché (evitar re-ejecutar MATLAB)

`_quarto.yml` fija `execute: freeze: auto` y `execute: cache: true` para **todo el
proyecto**, así que los dos mecanismos actúan a la vez:

- **Freeze** (`_freeze/`): al construir el sitio, un lab **no se re-ejecuta** si su
  `.qmd` no ha cambiado. Por eso `quarto render lab0.qmd --to pdf` reutiliza la
  ejecución del HTML y tarda segundos en lugar de minutos.
- **Caché** (`.jupyter_cache/`, paquete `jupyter-cache`; instálalo con
  `python -m pip install jupyter-cache`): si editas **solo texto** (prosa,
  callouts, títulos), MATLAB **no se ejecuta** y el render es casi instantáneo
  (~2 s en lugar de ~30 s).

**Importante:** `jupyter-cache` cachea el **documento completo**, no celda a celda.
Si cambias **cualquier** celda de código, se re-ejecutan **todas**. No hay caché por
celda para el motor Jupyter en Quarto.

Para forzar un recálculo completo, borra `.jupyter_cache/` y `_freeze/`; se
regeneran solos.

## Callouts de ejercicio y solución (sintaxis corta)

El filtro Lua `callouts.lua` está registrado en `_quarto.yml` (`filters:
[callouts.lua]`), de modo que **vale para todos los labs sin tocar su cabecera**.
Genera los callouts de ejercicio y solución sin escribir todo el envoltorio a mano:

```markdown
::: {.ejercicio}
Enunciado del ejercicio ...
:::

::: {.solucion}
Contenido de la solución (código, figuras, ...).
:::
```

- `.ejercicio` → callout verde con icono de **pluma**; no colapsable.
- `.solucion` → callout verde con icono de **bombilla**; **colapsable**.
- **Numeración automática**: los ejercicios se numeran solos (Ejercicio 1, 2, 3…) y
  cada solución referencia el número del ejercicio en curso ("Solución del Ejercicio N").
- **Anulación con `title=`**: puedes fijar el título a mano, p. ej.
  `::: {.ejercicio title="Ejercicio A"}`. Un ejercicio con `title=` **no** consume
  número del contador automático (la secuencia 1, 2, 3… continúa intacta). El `title=`
  admite markdown (`` title="Ejercicio con `código`" ``).
- **El icono se define en un único sitio** (`callouts.lua`): cambiarlo ahí lo cambia
  en todo el documento.

### Cómo funciona el icono (por si hay que tocarlo)

Los iconos se ven **en HTML y en PDF**. Como los emoji no se renderizan en el PDF
(lualatex) y la extensión FontAwesome choca con la versión de Font Awesome que
Quarto ya usa para los callouts, el filtro elige el icono según el formato: macro de
**fontawesome5** en PDF (`\faPenNib` / `\faLightbulb`) y emoji en HTML (`✏️` / `💡`).
La macro FA5 necesita `\usepackage{fontawesome5}` en el `include-in-header` del PDF.

El mismo efecto escrito a mano (sin el filtro) sería:

```markdown
::: {.callout-tip icon=false}
## [`\faPenNib`{=latex}]{.content-visible when-format="pdf"}[✏️]{.content-visible when-format="html"} Ejercicio 1
...
:::
```

- **PDF:** macro `\faPenNib` / `\faLightbulb` de **fontawesome5**, que se carga con
  `include-in-header` en el encabezado (`\usepackage{fontawesome5}`). Ojo: los
  nombres de macro son los de FA5 (p. ej. `\faPenNib`, no `\faPencilAlt`).
- **HTML:** un emoji (`✏️` / `💡`).
- `icon=false` oculta el icono por defecto del callout para no duplicarlo.

## Opciones de chunk en MATLAB: usa `%|`, no `#|`

El comentario de MATLAB es `%`, así que las opciones de celda de Quarto se escriben
con **`%|`** (no `#|`, que es para Python/R/Julia). Si usas `#|`, MATLAB lo toma como
código y no se aplica la opción. La opción debe ir en la **primera línea** del chunk:

```matlab
%| echo: false
clear all; close all; clc;
plot(t, sin(2*pi*t))     % código oculto; la figura sí se muestra
```

- `%| echo: false` → oculta el código (ejecuta y muestra la figura). Funciona en
  **HTML y PDF**, también dentro de callouts (`.ejercicio` / `.solucion`).
- `%| output: false` → oculta la salida, muestra el código.
- `%| include: false` → oculta código y salida (pero ejecuta el chunk).

Ojo con la diferencia entre ```` ```{matlab} ```` (celda que **se ejecuta**) y
```` ```matlab ```` (bloque que solo se **muestra** resaltado, útil para código que
el alumno debe escribir en su propio `.m`).

## Notas

- Probado con Quarto 1.9 y MATLAB R2024a. Ajusta la versión de MATLAB en la ruta
  si no usas R2024a.
- El PDF usa **TinyTeX** (instalado con `quarto install tinytex`), que descarga por
  sí solo los paquetes LaTeX que falten sin necesidad de `sudo`. Debe ir en el
  `PATH` **por delante** de cualquier BasicTeX/MacTeX del sistema.
- Los acentos y la ñ se representan correctamente (motor lualatex, `lang: es`).
