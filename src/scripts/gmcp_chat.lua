function gmcp_chat()
    local text = gmcp.Comm.Channel.Text
    local da_a = ""
    if text.soggetto ~= nil then
        da_a = " da <b>" .. text.soggetto .. "</b>"
    end
    if (text.canale == "messaggio" or text.canale == "sogno" or text.canale == "dicoa") then
        da_a = da_a .. " a <b>" .. text.oggetto .. "</b>"
    end
    local c = "255,0,255"
    if (text.canale == "messaggio" or text.canale == "sogno") then
        c = "58,150,221" -- ciano
    elseif (text.canale == "gruppo") then
        c = "59,142,234" -- blu
    elseif (text.canale == "dico") then
        c = "229,229,229"
    elseif (text.canale == "urlo" or text.canale == "grido") then
        c = "205,49,49"
    elseif (text.canale == "parla") then
        c = "255,255,0"
    end
    SPAM.abbilchatWidget:decho("<" .. c .. ">[<i>" .. text.canale .. "</i>" .. da_a .. "]: <160,160,160>" .. ansi2decho(text.testo) .. "\r\n")
end
