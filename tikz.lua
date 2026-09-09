--[[
  tikz.lua — bloques de circuitos (CircuiTikZ) en los dos formatos del sitio.

  Uso en un .qmd:

      ```{.tikz}
      \begin{circuitikz}
        \draw (0,0) to[R, l=$R$] (2,0);
      \end{circuitikz}
      ```

  * En PDF el código se pasa tal cual a LaTeX: CircuiTikZ es nativo y el
    resultado es vectorial, con las mismas fuentes que el resto del documento.
  * En HTML el bloque se compila aparte con `latex` + `dvisvgm` y se inserta el
    SVG resultante.

  El SVG se cachea en `_tikz/<hash>.svg`: solo se recompila si cambia el código
  del circuito, así que un render normal no paga el coste.

  Requiere `latex` y `dvisvgm` en el PATH (los trae TinyTeX) y los paquetes
  LaTeX `circuitikz`, `standalone` y `luatex85`.

  Atributos admitidos: `width` y `alt`, p. ej. ```{.tikz width="60%"}
]]

local CACHE = "_tikz"

-- Documento mínimo que envuelve el bloque para compilarlo por separado.
-- Se concatena, no se usa string.format: el LaTeX está lleno de '%'.
local PREAMBULO = [[\documentclass[border=4pt]{standalone}
% pgf debe emitir SVG nativo, no PostScript: sin esto dvisvgm descarta los
% "specials" de color y relleno (y necesitaría Ghostscript para procesarlos).
\def\pgfsysdriver{pgfsys-dvisvgm.def}
\usepackage{circuitikz}
\begin{document}
]]

local CIERRE = [[

\end{document}
]]

local function huella(texto)
  -- nombre de fichero seguro a partir del contenido del bloque
  return (pandoc.utils.sha1(texto):gsub("[^%x]", ""))
end

local function existe(ruta)
  local f = io.open(ruta, "r")
  if f then f:close(); return true end
  return false
end

-- Compila el código a SVG y lo deja en `destino`.
local function compilar(codigo, destino)
  local svg
  pandoc.system.with_temporary_directory("tikz", function(tmp)
    pandoc.system.with_working_directory(tmp, function()
      local tex = io.open("d.tex", "w")
      tex:write(PREAMBULO .. codigo .. CIERRE)
      tex:close()
      pandoc.pipe("latex", { "-interaction=nonstopmode", "-halt-on-error", "d.tex" }, "")
      pandoc.pipe("dvisvgm", { "--no-fonts", "--exact-bbox", "-o", "d.svg", "d.dvi" }, "")
      local f = io.open("d.svg", "r")
      svg = f:read("a")
      f:close()
    end)
  end)
  pandoc.system.make_directory(CACHE, true)
  local f = io.open(destino, "w")
  f:write(svg)
  f:close()
end

function CodeBlock(bloque)
  if not bloque.classes:includes("tikz") then return nil end

  -- PDF: el código va directo al documento LaTeX.
  if quarto.doc.is_format("latex") then
    quarto.doc.use_latex_package("circuitikz")
    return pandoc.RawBlock("latex",
      "\\begin{center}\n" .. bloque.text .. "\n\\end{center}")
  end

  -- HTML (y cualquier otro formato): compilamos a SVG, con caché.
  local destino = CACHE .. "/" .. huella(bloque.text) .. ".svg"
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

  local img = pandoc.Image({ pandoc.Str(bloque.attributes["alt"] or "Circuito") }, destino)
  if bloque.attributes["width"] then
    img.attributes["width"] = bloque.attributes["width"]
  end
  return pandoc.Div({ pandoc.Para({ img }) },
    pandoc.Attr("", { "tikz-figura" }, { style = "text-align: center;" }))
end
