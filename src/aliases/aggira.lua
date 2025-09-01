if SPAM.config.get("auto_alza") and
    SPAM.I_am_tank() and
    gmcp.Char.Vitals.stato == "Seduto" then
  send("alza")
end
send("aggira "..matches[3], false)