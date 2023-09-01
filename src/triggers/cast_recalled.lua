if SPAM.mem.prepared[matches[2]] ~= nil then
    SPAM.mem.prepared[matches[2]] = SPAM.mem.prepared[matches[2]] - 1
    SPAM.print_mem()
end