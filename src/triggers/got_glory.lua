if SPAM.lastDead == nil or SPAM.lastDead == '' then
  return
end
SPAM.config.get("glory_timer")[SPAM.lastDead] = os.time()
SPAM.config.save_characters()