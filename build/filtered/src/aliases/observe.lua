local help_string =
  [[

Questo è l'aiuto per l'alias observe del package BuffObserver
Il comando è abbreviabile con ob.
Se vuoi monitorare i buff di un alleato usa: observe nome ruolo
I ruoli ammessi sono: base, tank, dps, tankdps, remove (rimuove l'alleato)
Per visionare tutti gli alleati in observe usa: observe list
Per svuotare la lista degli alleati in observe usa: observe clear
Per aggiungere un buff optionale usa: observe optionalbuff alleato cast

]]
local roles = {"remove", "base", "tank", "dps", "tankdps", "dpstank"}
local role = ""
local split = explode(matches[3])
if #split == 1 then
  if string.starts("list", string.lower(split[1])) then
    echo("\nLista observe:")
    display(persistent_variables[character_name]["observe_list"])
    return
  end
  if string.starts("clear", string.lower(split[1])) then
    persistent_variables[character_name]["observe_list"] = nil
    persistent_variables[character_name]["observe_list"] = {}
    save_persistent_var(character_name)
    echo("\nLista observe svuotata")
    send("\n")
    return
  end
end
if #split > 1 then
  if string.starts("optionalbuff", string.lower(split[1])) then
    allyName = getAllyName(split[2])
    if allyName == nil then
      cecho("\n<red>Nessun alleato trovato per " .. split[2])
      echo("\nLa sintassi corretta è: observe optionalbuff alleato cast\n")
      send("\n")
      return
    end
    if persistent_variables[character_name]["optional_buff"][allyName] == nil then
      persistent_variables[character_name]["optional_buff"][allyName] = {}
    end
    buff = removeFirstTwoWords(matches[3])
    if persistent_variables[character_name]["optional_buff"][allyName][buff] == true then
      echo("\nRimuovo " .. buff .. " per " .. allyName .. "\n")
      persistent_variables[character_name]["optional_buff"][allyName][buff] = nil
    else
      echo("\nOsservo " .. buff .. " per " .. allyName .. "\n")
      persistent_variables[character_name]["optional_buff"][allyName][buff] = true
    end
    send("\n")
    save_persistent_var(character_name)
    return
  end
  if ob_role(split[1], split[2], true) then
    return
  end
end
checho(help_string)