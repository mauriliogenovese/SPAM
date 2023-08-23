if SPAM.config.get("equip_color") == true then
    local thiscolor = "FF33DA"
    if SPAM.cond[matches[4]] ~= nil then
        thiscolor = SPAM.colors[SPAM.cond[matches[4]]]
    end

    selectString(matches[4], 1)

    setHexFgColor(thiscolor)
    resetFormat()

end