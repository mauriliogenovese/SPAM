if SPAM.lastDead == nil or SPAM.lastDead == '' then
  return
end
SPAM.persistent_variables[SPAM.character_name]["glory_timer"][SPAM.lastDead] = os.time()
save_persistent_var(SPAM.character_name)