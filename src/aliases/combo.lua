if SPAM.next_combo==nil then
    cecho("\n<red>Non c'è nessuna combo in corso!")
elseif SPAM.string.starts(SPAM.next_combo, "-") then
    cecho("\n<yellow>Hai già inviato il prossimo colpo della combo!")
else
    send(SPAM.next_combo)
    SPAM.next_combo="-"..SPAM.next_combo
end