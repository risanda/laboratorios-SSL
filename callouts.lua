-- callouts.lua
-- Convierte los divs `.ejercicio` y `.solucion` en callouts estilizados,
-- con el icono definido en un único sitio (aquí). Uso:
--
--   ::: {.ejercicio title="Ejercicio 1"}
--   Enunciado ...
--   :::
--
--   ::: {.solucion title="Solución del Ejercicio 1"}
--   ...
--   :::
--
-- El título se toma del atributo `title=`; si se omite, se usa "Ejercicio" /
-- "Solución". El icono se elige por formato: pluma/bombilla de fontawesome5 en
-- PDF y emoji ✏️/💡 en HTML.

-- Contador de ejercicios para la numeración automática. Se reinicia en cada
-- render (html y pdf se generan por separado), así que la numeración es estable.
local n_ejercicio = 0

local function icono(kind)
  local pdf = quarto.doc.is_format("pdf")
  if kind == "ejercicio" then
    return pdf and pandoc.RawInline("latex", "\\faPenNib\\ ") or pandoc.Str("✏️ ")
  else
    return pdf and pandoc.RawInline("latex", "\\faLightbulb\\ ") or pandoc.Str("💡 ")
  end
end

function Div(el)
  local kind
  if el.classes:includes("ejercicio") then
    kind = "ejercicio"
  elseif el.classes:includes("solucion") then
    kind = "solucion"
  else
    return nil
  end

  -- El título se puede fijar a mano con `title=` (anula la numeración). Si no se
  -- indica, se numera automáticamente: los ejercicios llevan un contador y las
  -- soluciones referencian el número del ejercicio actual.
  local texto = el.attributes["title"]
  if texto == nil or texto == "" then
    if kind == "ejercicio" then
      n_ejercicio = n_ejercicio + 1
      texto = "Ejercicio " .. n_ejercicio
    elseif n_ejercicio > 0 then
      texto = "Solución del Ejercicio " .. n_ejercicio
    else
      texto = "Solución"
    end
  end

  -- El texto del título puede contener markdown (p. ej. `código`); lo leemos
  -- como inlines y le anteponemos el icono.
  local titulo = pandoc.read(texto, "markdown").blocks[1].content
  table.insert(titulo, 1, icono(kind))

  -- Solo las soluciones son colapsables. Para el ejercicio pasamos `nil`
  -- (clave ausente): si pasáramos `false`, Quarto lo haría colapsable-pero-abierto
  -- y mostraría la flecha.
  return quarto.Callout{
    type = "tip",
    icon = false,
    collapse = (kind == "solucion") or nil,
    title = titulo,
    content = el.content,
  }
end
