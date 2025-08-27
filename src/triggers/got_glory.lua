if SPAM.last_dead == nil or SPAM.last_dead == '' then
  return
endif
SPAM.config.get("glory_timer")[SPAM.last_dead] = os.time()
if SPAM.config.get("glory_timer")["today"] == nil or SPAM.config.get("glory_timer")["today"]  != os.date("%Y%m%d") then
    SPAM.config.get("glory_timer")["today"]  = os.date("%Y%m%d")
    SPAM.config.get("glory_timer")["today_total"]  = 0
end
SPAM.config.get("glory_timer")["today_total"]  = SPAM.config.get("glory_timer")["today_total"] + tonumber(matches[2])
SPAM.config.save_characters()