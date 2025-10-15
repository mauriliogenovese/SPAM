if SPAM.config.get("nascondi_armi_elementali") then
    --Un frammento di ghiaccio fuoriesce da una sciabola da pirata ma ti sembra che manchi.
    --Una scintilla di elettricita' fuoriesce da Kris, il perfora-demoni e ti fulmina leggermente.
    deleteLine()
    local elemento = matches[2]
    local linea = line:lower()

    local colori = {
      fuoco = "<red>",
      acido = "<green>",
      ghiaccio = "<cyan>",
      elettricita = "<yellow>",
      energia = "<blue>"
    }

    local colore = colori[elemento] or "<white>"

    if linea:find("manchi") then
      cecho(string.format(" %s(manca)<reset>\n", colore))
    else
      cecho(string.format(" %s(%s)<reset>\n", colore, elemento))
    end
end