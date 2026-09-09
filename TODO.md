# TODO

Pendientes del material de prácticas. Salen de la revisión recogida en
[CONTENIDOS.md](CONTENIDOS.md); ninguno bloquea el uso actual de las prácticas.

## Material que falta

- [ ] **Añadir `p44100.wav` al repositorio.** El ejercicio 9 de la P1
  (cuantización de audio real, en el trabajo de laboratorio) lo carga con
  `[y,Fs] = audioread('p44100.wav')`. Sin el archivo el ejercicio no se puede
  ejecutar. Al añadirlo, comprobar que el `.gitignore` no lo excluye y decidir si
  conviene un fragmento corto para no engordar el repositorio.

## Evaluación

- [ ] **Decidir entregable y criterio de evaluación.** Ni la P0 ni la P1 incluyen
  entregable, rúbrica ni criterio. Conviene fijar el formato **antes** de escribir
  la P2, para que las prácticas nuevas nazcan ya con él y no haya que reformar las
  anteriores.

## Deuda técnica

- [ ] **Referencias cruzadas en lugar de números de ejercicio.** `callouts.lua`
  numera los ejercicios automáticamente, pero el texto de la P1 remite a "tu
  solución del Ejercicio 6" con el número escrito a mano. Cualquier ejercicio que
  se inserte antes rompe la referencia sin previo aviso. Solución: identificadores
  y referencias cruzadas de Quarto. Baja prioridad mientras el material sea
  pequeño; revisar si crece.
