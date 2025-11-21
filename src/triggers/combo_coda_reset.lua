if SPAM.next_combo ~= nil and SPAM.string.starts(SPAM.next_combo, "-") then
    SPAM.next_combo = SPAM.next_combo:sub(2)
end