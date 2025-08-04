if SPAM.config.get("auto_alza") == true and
    gmcp.Char.Vitals.tank ~= nil and
    gmcp.Char.Vitals.tank ~= "Tu" and
    gmcp.Char.Vitals.stato == "Seduto" then
  send("alza")
end
send("carica"..matches[3])