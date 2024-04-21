if SPAM.config.get("aka")==true then
    if matches[3] == "remove" then
        SPAM.config.get("aka_list")[string.lower(matches[2])] = nil
        SPAM.config.save_globals()
        cecho("\n<grey>Rimosso il soprannome del personaggio " .. matches[2] .. "\n")

    else
        SPAM.config.get("aka_list")[string.lower(matches[2])] = matches[3]
        SPAM.config.save_globals()
        cecho("\n<grey>Il personaggio " .. matches[2] .. " ora ha il soprannome " .. matches[3] .. "\n")
    end
end