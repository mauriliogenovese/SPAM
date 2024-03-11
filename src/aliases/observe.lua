local help_string =
  [[

<grey>Questo è l'aiuto per l'alias observe del package BuffObserver
Il comando è abbreviabile con ob.
Se vuoi monitorare i buff di un alleato usa: <yellow>observe nomealleato ruolo
<grey>I ruoli ammessi sono: <yellow>base, tank, dps, tankdps, remove (rimuove l'alleato)
<grey>Per visionare tutti gli alleati in observe usa: <yellow>observe list
<grey>Per svuotare la lista degli alleati in observe usa: <yellow>observe clear
<grey>Per aggiungere un buff optionale usa: <yellow>observe optionalbuff nomealleato cast
<grey>Inoltre è possibile riattivare un buff su se stessi con comandi personalizzati
(ad esempio indossando un oggetto, o qualsiasi altra cosa).
Per aggiungere un buff personalizzato usa: <yellow>observe customrefresh cast-comando1,comando2,...
<grey>Ad esempio: <yellow>observe customrefresh scudo di ghiaccio-impuigna bacchetta,zap me,rimuovi bacchetta
<grey>Infine, per modificare la dimensione del font nel BuffObserver usa: <yellow>observe font +/-

]]
local split = SPAM.string.explode(matches[3])
if #split == 1 then
  if SPAM.string.starts("list", string.lower(split[1])) then
    cecho("\n<yellow>Lista observe: ")
    display(SPAM.config.get("observe_list"))
    cecho("\n\n<yellow>Lista buff opzionali:")
    display(SPAM.config.get("optional_buff"))
    cecho("\n\n<yellow>Lista custom refresh:")
    display(SPAM.config.get("custom_refresh"))
    return
  end
  if SPAM.string.starts("clear", string.lower(split[1])) then
    SPAM.config.set("observe_list", {})
    echo("\nLista observe svuotata")
    send("\n")
    return
  end
end
if #split > 1 then
  if SPAM.string.starts("optionalbuff", string.lower(split[1])) then
    local ally_name = SPAM.get_ally_name(split[2])
    if ally_name == nil then
      cecho("\n<red>Nessun alleato trovato per " .. split[2])
      cecho("\nLa sintassi corretta è: <yellow>observe optionalbuff alleato cast\n")
      send("\n")
      return
    end
    if SPAM.config.get("optional_buff")[ally_name] == nil then
      SPAM.config.get("optional_buff")[ally_name] = {}
    end
    local buff = SPAM.string.remove_first_two_words(matches[3])
    if SPAM.config.get("optional_buff")[ally_name][buff] == true then
      echo("\nRimuovo " .. buff .. " per " .. ally_name .. "\n")
      SPAM.config.get("optional_buff")[ally_name][buff] = nil
    else
      echo("\nOsservo " .. buff .. " per " .. ally_name .. "\n")
      SPAM.config.get("optional_buff")[ally_name][buff] = true
    end
    send("\n")
    SPAM.config.save_characters()
    return
  elseif SPAM.string.starts("customrefresh", string.lower(split[1])) then
    if SPAM.config.get("custom_refresh") == nil then
      SPAM.config.set("custom_refresh", {})
    end
    local exp = SPAM.string.explode(SPAM.string.remove_first_word(matches[3]), "-")
    if #exp == 2 then
      exp[1] = SPAM.string.trim(exp[1])
      if SPAM.config.get("custom_refresh")[exp[1]] ~= nil then
        echo("\nRimuovo custom refresh " .. exp[1] .. "\n")
        SPAM.config.get("custom_refresh")[exp[1]] = nil
      else
        echo("\nOsservo custom refresh " .. exp[1] .. " with commands: " .. exp[2] .. "\n")
        SPAM.config.get("custom_refresh")[exp[1]] = SPAM.string.explode(exp[2],",")
      end
      send("\n")
      SPAM.config.save_characters()
      return
    end
  elseif SPAM.string.starts("font", string.lower(split[1])) then
    if split[2] == "+" then
      SPAM.dde_group_widget:setFontSize(SPAM.dde_group_widget:getFontSize()+1)
      echo("\nDimension del testo aumentata\n")
    elseif split[2] == "-" then
      SPAM.dde_group_widget:setFontSize(SPAM.dde_group_widget:getFontSize()-1)
      echo("\nDimension del testo ridotta\n")
    else
      cecho("\n<red>Comando invalido:<white> " .. split[2])
      cecho("\nLa sintassi corretta è: <yellow>observe font +/-\n")
    end
    SPAM.config.set("buff_font_size", SPAM.dde_group_widget:getFontSize())
    return
  end
  if SPAM.ob_role(split[1], split[2], true) then
    return
  end
end
checho(help_string)