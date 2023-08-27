if SPAM.last_dead == nil or SPAM.last_dead == '' then
  return
end
SPAM.config.get("glory_timer")[SPAM.last_dead] = os.time()
SPAM.config.save_characters()