if SPAM.config.get("nascondi_armi_elementali") then
    --Un frammento di ghiaccio fuoriesce da una sciabola da pirata ma ti sembra che manchi.
    --Una scintilla di elettricita' fuoriesce da Kris, il perfora-demoni e ti fulmina leggermente.
    --Uno spruzzo di acido fuoriesce da Ayasida, il nunchaku corrosivo e corrode violentemente il Capitano delle guardie del Tempio.
    deleteLine()
    local elemento = matches[2]
    local linea = line:lower()
    --echo("\n elemento"..matches[2].."\n")
    local colori = {
      fuoco = "<red>",
      acido = "<green>",
      ghiaccio = "<cyan>",
      elettricita = "<yellow>",
      energia = "<blue>"
    }

    local colore = colori[elemento] or "<white>"

    if linea:find("manchi") then
      cecho(string.format("%s<<IMMUNE>><reset>\n", colore))
    else
      if linea:find("leggermente") then
        cecho(string.format("%s<%s><reset>\n", colore, elemento))
      elseif linea:find("violentemente") then
        cecho(string.format("%s<<<%s>>><reset>\n", colore, elemento))
      else
        cecho(string.format("%s<<%s>><reset>\n", colore, elemento))
      end

    end
end