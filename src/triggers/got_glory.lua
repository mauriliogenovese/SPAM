if lastDead == nil or lastDead == '' then
  return
end
persistent_variables[character_name]["glory_timer"][lastDead] = os.time()
save_persistent_var(character_name)