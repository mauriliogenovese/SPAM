if SPAM.last_dead == nil or SPAM.last_dead == '' then
  return
end
SPAM.config.get("glory_timer")[SPAM.last_dead] = os.time()
if SPAM.config.get("glory_today")["date"] == nil or SPAM.config.get("glory_today")["date"] ~= os.date("%Y%m%d") then
    SPAM.config.get("glory_today")["date"]  = os.date("%Y%m%d")
    SPAM.config.get("glory_today")["total"]  = 0
end
SPAM.config.get("glory_today")["total"]  = SPAM.config.get("glory_today")["total"] + tonumber(matches[2])
SPAM.config.save_characters()