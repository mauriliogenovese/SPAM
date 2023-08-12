if lastDead == nil or lastDead == '' then
  return
end
persistent_variables[character_name]["glory_timer"][lastDead] = os.time(os.date("!*t"))
save_persistent_var(character_name)