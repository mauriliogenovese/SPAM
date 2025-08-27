if SPAM.next_combo==nil then
    cecho("\n<red>Non c'è nessuna combo in corso!")
elseif SPAM.next_combo==0 then
    cecho("\n<yellow>Hai già inviato il prossimo colpo della combo!")
else
    send(SPAM.next_combo)
    SPAM.next_combo=0
end