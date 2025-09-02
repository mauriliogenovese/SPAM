send("livello", false)
local today_xp = SPAM.current_exp() - SPAM.config.get("glory_today")["base_exp"]
cecho("<yellow>PX DI OGGI: <white>" .. SPAM.formatNumber(today_xp, ","))