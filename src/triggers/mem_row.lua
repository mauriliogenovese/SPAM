local cast_name = string.lower(string.gsub(matches[3], "%.", ""))
SPAM.mem.prepared[cast_name] = tonumber(matches[4])
if tonumber(matches[5])>0 then
    if SPAM.mem.temp == nil then
        SPAM.mem.temp = {}
    end
    SPAM.mem.temp[cast_name] = tonumber(matches[5])
end
