if SPAM.config.get("gdcolor")==true then
    send("gd " .. SPAM.config.get("gd_start") .. matches[3] .. SPAM.config.get("gd_end") .. "&d")
else
    send(matches[1])
end