--[[
  tikz.lua — bloques TikZ y CircuiTikZ en los dos formatos del sitio.

  Uso en un .qmd:

      ```{.tikz}
      \begin{circuitikz}
        \draw (0,0) to[R, l=$R$] (2,0);
      \end{circuitikz}
      ```

  * En PDF el código se pasa tal cual a LaTeX: TikZ y CircuiTikZ son nativos y el
    resultado es vectorial, con las mismas fuentes que el resto del documento.
  * En HTML el bloque se compila aparte con `latex` + `dvisvgm` y se inserta el
    SVG resultante.

  El SVG se cachea en `_tikz/<hash>.svg`, **junto al documento** que lo usa: solo
  se recompila si cambia el código del diagrama, así que un render normal no paga
  el coste.

  Requiere `latex` y `dvisvgm` en el PATH (los trae TinyTeX) y los paquetes
  LaTeX `circuitikz`, `standalone` y `luatex85`.

  Atributos admitidos: `width` y `alt`, p. ej. ```{.tikz width="60%"}

  Un documento puede añadir definiciones propias al preámbulo (estilos de
  `\tikzset`, paquetes extra...) declarando en su cabecera YAML:

      tikz-preamble: |
        \tikzset{sig/.style={very thick, blue}}
]]

local CACHE = "_tikz"

-- Documento mínimo que envuelve el bloque para compilarlo por separado.
-- Se concatena, no se usa string.format: el LaTeX está lleno de '%'.
local PREAMBULO = [[\documentclass[border=4pt]{standalone}
% pgf debe emitir SVG nativo, no PostScript: sin esto dvisvgm descarta los
% "specials" de color y relleno (y necesitaría Ghostscript para procesarlos).
\def\pgfsysdriver{pgfsys-dvisvgm.def}
\usepackage{circuitikz}
]]

local APERTURA = [[
\begin{document}
]]

local CIERRE = [[

\end{document}
]]

-- Preámbulo propio del documento, leído de la metadata `tikz-preamble`.
local extra = ""

local function huella(texto)
  -- nombre de fichero seguro a partir del contenido del bloque
  return (pandoc.utils.sha1(texto):gsub("[^%x]", ""))
end

local function existe(ruta)
  local f = io.open(ruta, "r")
  if f then f:close(); return true end
  return false
end

-- Carpeta del .qmd que se está renderizando. El SVG se escribe ahí, de modo que
-- la ruta relativa que se inserta en el documento valga también cuando el .qmd
-- vive en un subdirectorio del proyecto.
local function carpeta_documento()
  local entrada = quarto.doc.input_file
  if entrada then
    local d = pandoc.path.directory(entrada)
    if d and d ~= "" then return d end
  end
  return "."
end

-- Compila el código a SVG y lo deja en `destino`.
local function compilar(codigo, destino)
  local svg
  pandoc.system.with_temporary_directory("tikz", function(tmp)
    pandoc.system.with_working_directory(tmp, function()
      local tex = io.open("d.tex", "w")
      tex:write(PREAMBULO .. extra .. APERTURA .. codigo .. CIERRE)
      tex:close()
      pandoc.pipe("latex", { "-interaction=nonstopmode", "-halt-on-error", "d.tex" }, "")
      pandoc.pipe("dvisvgm", { "--no-fonts", "--exact-bbox", "-o", "d.svg", "d.dvi" }, "")
      local f = io.open("d.svg", "r")
      svg = f:read("a")
      f:close()
    end)
  end)
  pandoc.system.make_directory(pandoc.path.directory(destino), true)
  local f = io.open(destino, "w")
  f:write(svg)
  f:close()
end

-- Quarto parsea la metadata como markdown, así que un bloque de LaTeX llega
-- como RawBlock y `pandoc.utils.stringify` lo devolvería vacío: hay que recoger
-- el texto crudo a mano.
local function texto_crudo(valor)
  if valor == nil then return "" end
  if type(valor) == "string" then return valor end

  local partes = {}
  local recoger = {
    RawBlock  = function(el) partes[#partes+1] = el.text .. "\n" end,
    RawInline = function(el) partes[#partes+1] = el.text end,
    CodeBlock = function(el) partes[#partes+1] = el.text .. "\n" end,
    Code      = function(el) partes[#partes+1] = el.text end,
    Str       = function(el) partes[#partes+1] = el.text end,
    Space     = function()   partes[#partes+1] = " "  end,
    SoftBreak = function()   partes[#partes+1] = "\n" end,
    LineBreak = function()   partes[#partes+1] = "\n" end,
  }

  -- el valor puede ser una lista de bloques o de inlines
  if not pcall(function() pandoc.Div(valor):walk(recoger) end) then
    pcall(function() pandoc.Plain(valor):walk(recoger) end)
  end
  return table.concat(partes)
end

local function leer_metadata(meta)
  extra = texto_crudo(meta["tikz-preamble"])
  if extra ~= "" then extra = extra .. "\n" end
  return meta
end

local function procesar(bloque)
  if not bloque.classes:includes("tikz") then return nil end

  -- PDF: el código va directo al documento LaTeX.
  if quarto.doc.is_format("latex") then
    quarto.doc.use_latex_package("circuitikz")
    if extra ~= "" then
      quarto.doc.include_text("in-header", extra)
    end
    return pandoc.RawBlock("latex",
      "\\begin{center}\n" .. bloque.text .. "\n\\end{center}")
  end

  -- HTML (y cualquier otro formato): compilamos a SVG, con caché.
  -- El hash incluye el preámbulo del documento: si cambian los estilos, se
  -- recompila en lugar de reutilizar un SVG viejo.
  local relativa = CACHE .. "/" .. huella(extra .. bloque.text) .. ".svg"
  local destino  = pandoc.path.join({ carpeta_documento(), relativa })

  if not existe(destino) then
    local ok, err = pcall(compilar, bloque.text, destino)
    if not ok then
      quarto.log.error("tikz.lua: no se pudo compilar el diagrama.\n" ..
        "Comprueba que `latex` y `dvisvgm` están en el PATH y que el paquete\n" ..
        "`circuitikz` está instalado (tlmgr install circuitikz dvisvgm luatex85).\n" ..
        tostring(err))
      return nil   -- se deja el bloque como código, para que el fallo se vea
    end
  end

  local img = pandoc.Image({ pandoc.Str(bloque.attributes["alt"] or "Diagrama") }, relativa)
  if bloque.attributes["width"] then
    img.attributes["width"] = bloque.attributes["width"]
  end
  return pandoc.Div({ pandoc.Para({ img }) },
    pandoc.Attr("", { "tikz-figura" }, { style = "text-align: center;" }))
end

-- Se procesa el documento entero de una vez para garantizar que la metadata se
-- lee antes que los bloques: si se dejara a la travesía por defecto, los
-- CodeBlock se visitarían antes que Meta y el preámbulo llegaría vacío.
return {
  {
    Pandoc = function(doc)
      leer_metadata(doc.meta)
      return doc:walk({ CodeBlock = procesar })
    end
  }
}
