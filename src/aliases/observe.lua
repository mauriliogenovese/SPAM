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
<grey>Ad esempio: <yellow>observe customrefresh scudo di ghiaccio-impuigna bacchetta, zap me,rimuovi bacchetta

]]
local roles = {"remove", "base", "tank", "dps", "tankdps", "dpstank"}
local role = ""
local split = explode(matches[3])
if #split == 1 then
  if string.starts("list", string.lower(split[1])) then
    cecho("\n<yellow>Lista observe: ")
    display(SPAM.config.get("observe_list"))
    cecho("\n\n<yellow>Lista buff opzionali:")
    display(SPAM.config.get("optional_buff"))
    cecho("\n\n<yellow>Lista custom refresh:")
    display(SPAM.config.get("custom_refresh"))
    return
  end
  if string.starts("clear", string.lower(split[1])) then
    SPAM.config.set("observe_list", {})
    echo("\nLista observe svuotata")
    send("\n")
    return
  end
end
if #split > 1 then
  if string.starts("optionalbuff", string.lower(split[1])) then
    local allyName = getAllyName(split[2])
    if allyName == nil then
      cecho("\n<red>Nessun alleato trovato per " .. split[2])
      cecho("\nLa sintassi corretta è: <yellow>observe optionalbuff alleato cast\n")
      send("\n")
      return
    end
    if SPAM.config.get("optional_buff")[allyName] == nil then
      SPAM.config.get("optional_buff")[allyName] = {}
    end
    local buff = removeFirstTwoWords(matches[3])
    if SPAM.config.get("optional_buff")[allyName][buff] == true then
      echo("\nRimuovo " .. buff .. " per " .. allyName .. "\n")
      SPAM.config.get("optional_buff")[allyName][buff] = nil
    else
      echo("\nOsservo " .. buff .. " per " .. allyName .. "\n")
      SPAM.config.get("optional_buff")[allyName][buff] = true
    end
    send("\n")
    SPAM.config.save_characters()
    return
  elseif string.starts("customrefresh", string.lower(split[1])) then
    if SPAM.config.get("custom_refresh") == nil then
      SPAM.config.set("custom_refresh", {})
    end
    local exp = explode(removeFirstWord(matches[3]), "-")
    if #exp == 2 then
      exp[1] = trim(exp[1])
      if SPAM.config.get("custom_refresh")[exp[1]] ~= nil then
        echo("\nRimuovo custom refresh " .. exp[1] .. "\n")
        SPAM.config.get("custom_refresh")[exp[1]] = nil
      else
        echo("\nOsservo custom refresh " .. exp[1] .. " with command" .. exp[2] .. "\n")
        SPAM.config.get("custom_refresh")[exp[1]] = explode(exp[2],",")
      end
      send("\n")
      SPAM.config.save_characters()
      return

    end
  end
  if ob_role(split[1], split[2], true) then
    return
  end
end
checho(help_string)