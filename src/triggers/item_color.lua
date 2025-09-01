if SPAM.config.get("equip_color") then
    local this_color = "FF33DA"
    if SPAM.cond[matches[4]] ~= nil then
        this_color = SPAM.colors[SPAM.cond[matches[4]]]
    end

    selectString(matches[4], 1)

    setHexFgColor(this_color)
    resetFormat()

end