if SPAM.config.get("glory_timer")[matches[2]] ~= nil then
    SPAM.config.get("glory_timer")[matches[2]] = nil
    SPAM.config.save_characters()
    cecho("<yellow>Rimuovo dalla lista gloria: "..matches[2])
else
    cecho("<red>"..matches[2].." non è presente nella lista gloria")
end