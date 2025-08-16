if SPAM.config.get("auto_alza") == true and
    SPAM.I_am_tank() and
    gmcp.Char.Vitals.stato == "Seduto" then
  send("alza")
end
send("aggira "..matches[3])