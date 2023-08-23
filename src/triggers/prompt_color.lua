if SPAM.config.get("prompt_color") == true then
    local max=tonumber(matches[3])
    local current=tonumber(matches[2])
    selectString( matches[2], 1 )
    setHexFgColor(getPFcolor(current,max))
    resetFormat()
end