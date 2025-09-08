function gmcp_chat()
    local bold_open = "<b>"
    local bold_close = "</b>"
    local italic_open = "<i>"
    local italic_close = "</i>"
    if mudletOlderThan(4, 11) then
        bold_open = ""
        bold_close = ""
        italic_open = ""
        italic_close = ""
    end
    local text = gmcp.Comm.Channel.Text
    local da_a = ""
    local onlytext = ""
    if text.soggetto ~= nil then
        da_a = " da " .. bold_open .. text.soggetto .. bold_close
        onlytext = " da " .. text.soggetto
    end
    if (text.canale == "messaggio" or text.canale == "sogno" or text.canale == "dicoa") then
        da_a = da_a .. " a " .. bold_open .. text.oggetto .. bold_close
        onlytext = onlytext .. " a " .. text.oggetto
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
    table.insert(SPAM.chat_log, "[" .. text.canale .. onlytext .. "]: " .. ansi2decho(text.testo))
    if #SPAM.chat_log > 10 then
        table.remove(SPAM.chat_log, 1)
    end

    SPAM.abbil_chat_window:decho("<" .. c .. ">[" .. italic_open .. text.canale .. italic_close .. da_a .. "]: <160,160,160>" .. ansi2decho(text.testo) .. "\n")
end
