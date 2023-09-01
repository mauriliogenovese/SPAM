if SPAM.mem.temp == nil then
    SPAM.mem.temp = {}
end
if SPAM.mem.temp[matches[2]] == nil then
    SPAM.mem.temp[matches[2]] = 1
else
    SPAM.mem.temp[matches[2]] = SPAM.mem.temp[matches[2]] + 1
end
if SPAM.mem.prepared[matches[2]] == nil then
    SPAM.mem.prepared[matches[2]] = 0
end
SPAM.print_mem()