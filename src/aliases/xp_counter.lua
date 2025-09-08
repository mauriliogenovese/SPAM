send("livello", false)
local today_xp = SPAM.current_exp() - SPAM.config.get("glory_today")["base_exp"]
tempTimer(0.2, function()
        cecho("<yellow>PX DI OGGI: <white>" .. SPAM.formatNumber(today_xp, ","))
    end)