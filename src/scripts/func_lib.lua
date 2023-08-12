function toggle_ddegroup()
  if ddeGroupContainer == nil then
    return
  end
  if persistent_variables["config"]["dde_group"] == false then
    ddeGroupContainer:hide()
  else
    ddeGroupContainer:show()
  end
end

function spam_update()
  uninstallPackage("@PKGNAME@")
  installPackage("https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/build/SPAM.mpackage")
end

function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function string.starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

function firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

function explode(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function delete_table(x)
  for k in pairs(x) do
    x[k] = nil
  end
end

function parse_version(string)
  local major, minor, patch = string.match(string, "(%d+)%.(%d+)%.(%d+)")
  return major, minor, patch
end

function compare_with_current_version(newversion)
  if newversion == "@VERSION@" then
    return false
  end
  v1_major, v1_minor, v1_patch = parse_version(newversion)
  v2_major, v2_minor, v2_patch = parse_version("@VERSION@")
  if v1_major>v2_major then
    return true
  elseif v1_major<v2_major then
    return false
  elseif v1_minor>v2_minor then
    return true
  elseif v1_minor<v2_minor then
    return false
   else
    return v1_patch>v2_patch
  end
  return false
end

function spam_eventHandler(event, ...)
  if event == "sysDownloadDone" and spam_downloading then
    local file = arg[1]
    if string.ends(file,"/version") then
      remote_version = {}
      table.load(file, remote_version)
      if compare_with_current_version(remote_version[1]) then
        tempTimer(1, [[cecho("\n<red>E' disponibile una nuova versione di SPAM. Per scaricarla usa il comando: <white>spam update\n")]] )
      end
    end
    spam_downloading = false
  elseif event == "sysDownloadError" and spam_downloading then
    spam_downloading = false
  end
end

function merge_tables(old_table, new_table)
  table.foreach(
    old_table,
    function(k, v)
      table.insert(new_table, v)
    end
  )
end

function getAllyName(name)
  name = string.lower(name)
  if gmcp.Char.Gruppo.gruppo == nil then
    if string.starts(string.lower(gmcp.Char.Name.name), name) then
      return gmcp.Char.Name.name
    end
    return
  end
  local gruppo = gmcp.Char.Gruppo.gruppo
  for i, v in ipairs(gruppo) do
    v.nome = beautifyName(v.nome)
    if string.starts(string.lower(v.nome), name) then
      return v.nome
    end
  end
  return nil
end

--remove articles or other unnecessary names from followers

function beautifyName(name)
  if string.starts(string.lower(name), "un enorme ") then
    name = string.gsub(string.lower(name), "un enorme ", "")
  elseif string.starts(string.lower(name), "una ") then
    name = string.gsub(string.lower(name), "una ", "")
  elseif string.starts(string.lower(name), "l'") then
    name = string.gsub(string.lower(name), "l'", "")
  elseif string.starts(string.lower(name), "della ") then
    name = string.gsub(string.lower(name), "della ", "")
  elseif string.starts(string.lower(name), "un ") then
    name = string.gsub(string.lower(name), "un ", "")
  elseif string.starts(string.lower(name), "un' ") then
    name = string.gsub(string.lower(name), "un' ", "")
  end
  words = {}
  words[1], words[2] = name:match("(%w+)(%W+)")
  if words[1] == nil then
    words[1] = name
  end
  words[1] = firstToUpper(words[1])
  return words[1]
end

--remove duplicates from a table

function deduplicate(x)
  local seen = {}
  for index, item in ipairs(x) do
    if seen[item] then
      table.remove(x, index)
    else
      seen[item] = true
    end
  end
  if seen["nuovo vigore"] then
    for k in pairs(x) do
      x[k] = nil
    end
    table.insert(x, "nuovo vigore")
  end
end

function get_os()
  if package.config:sub(1, 1) == "/" then
    local f_os = assert(io.popen("uname", 'r'))
    local s_os = assert(f_os:read('*a'))
    f_os:close()
    if string.find(s_os, "Linux") then
      return "linux"
    else
      return "macos"
    end
  end
  return "window"
end

function copy_to_clipboard(string)
  if persistent_variables["config"]["clipboard"] == false then
    return
  end
  local os_name = get_os()
  if os_name == "linux" then
    local f = assert(io.popen("which xclip", 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if s == "" then
      cecho("<red>\nERROR: command xclip not found!")
      cecho("<red>\nInstall with this command: sudo apt install xclip\n")
    else
      os.execute("echo -n \"" .. string .. "\" | xclip -selection clipboard")
    end
  elseif os_name == "macos" then
    os.execute("echo -n \"" .. string .. "\" | pbcopy")
  else
    os.execute('echo ' .. string .. ' | clip')
  end
end

function play_sound(file)
  if persistent_variables["config"]["sounds"] == false then
    return
  end
  if get_os() == "linux" then
    local f = assert(io.popen("which paplay", 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if s == "" then
      cecho("<red>\nERROR: command paplay not found!")
      cecho("<red>\nInstall with this command: sudo apt install pulseaudio-utils\n")
    else
      os.execute("paplay " .. file .. " &")
    end
  else
    playSoundFile(file)
  end
end

function initialize_persistent_var(varname)
  if persistent_variables == nil then
    persistent_variables = {}
  end
  local savelocation = getMudletHomeDir() .. "/" .. varname .. ".lua"
  if persistent_variables[varname] == nil then
    persistent_variables[varname] = {}
  end
  if file_exists(savelocation) then
    table.load(savelocation, persistent_variables[varname])
  else
    save_persistent_var(varname)
  end
end

function save_persistent_var(varname)
  local savelocation = getMudletHomeDir() .. "/" .. varname .. ".lua"
  table.save(savelocation, persistent_variables[varname])
end

-- We need this function for sorting.

local function greater(a, b)
  return a[2] > b[2]
end

-- Populate the array with key,value pairs from hashTable.

function makePairs(hashTable, array, _k)
  local k, v = next(hashTable, _k)
  if k then
    table.insert(array, {k, v})
    return makePairs(hashTable, array, k)
  end
end

-- Print the pairs from the array.

function printPairs(array, _i)
  local i = _i or 1
  local pair = array[i]
  if pair then
    local k, v = unpack(pair)
    print(k .. ': ' .. os.date("%H:%M", v + 60 * 60))
    return printPairs(array, i + 1)
  end
end

function new_class()
  local class_table = {}
  class_table.buff = {dps = {}, tank = {}, base = {}}
  class_table.self_buff = {dps = {}, tank = {}, base = {}}
  class_table.move = {}
  class_table.heal = {}
  return class_table
end

--merge 2 classes table by table

function merge_classes(new_class, old_class)
  merge_tables(old_class.buff.dps, new_class.buff.dps)
  merge_tables(old_class.buff.tank, new_class.buff.tank)
  merge_tables(old_class.buff.base, new_class.buff.base)
  merge_tables(old_class.self_buff.dps, new_class.self_buff.dps)
  merge_tables(old_class.self_buff.tank, new_class.self_buff.tank)
  merge_tables(old_class.self_buff.base, new_class.self_buff.base)
  if old_class.heal ~= nil then
    merge_tables(old_class.heal, new_class.heal)
  end
  if old_class.move ~= nil then
    merge_tables(old_class.move, new_class.move)
  end
  if old_class.command ~= nil then
    new_class.command = old_class.command
  end
end

--remove duplicates from each class table

function deduplicate_class(class)
  deduplicate(class.buff.dps)
  deduplicate(class.buff.tank)
  deduplicate(class.buff.base)
  deduplicate(class.self_buff.dps)
  deduplicate(class.self_buff.tank)
  deduplicate(class.self_buff.base)
  deduplicate(class.move)
end

--generate spell list to observe based on player classes

function gen_spell_list(my_class_list)
  observe_spell_list = new_class()
  observe_spell_list.command = "form"
  for i, v in ipairs(my_class_list) do
    if class_list[v.classe] ~= nil then
      merge_classes(observe_spell_list, class_list[v.classe])
    end
  end
  deduplicate_class(observe_spell_list)
end

function removeFirstTwoWords(str)
  -- cerca la posizione della terza parola nella stringa
  local _, pos = string.find(str, "%S+%s+%S+%s+")
  if pos then
    -- se la terza parola esiste, restituisce la parte rimanente della stringa
    return string.sub(str, pos + 1)
  else
    -- se la terza parola non esiste, restituisce una stringa vuota
    return ""
  end
end

function removeFirstWord(str)
  -- cerca la posizione della terza parola nella stringa
  local _, pos = string.find(str, "%S+%s+")
  if pos then
    -- se la terza parola esiste, restituisce la parte rimanente della stringa
    return string.sub(str, pos + 1)
  else
    -- se la terza parola non esiste, restituisce una stringa vuota
    return ""
  end
end

function getPFcolor(current, max)
  local colors =
    {
      "FF0000",
      "ff3500",
      "fc4f00",
      "f86400",
      "f27600",
      "eb8700",
      "e29700",
      "d7a700",
      "cab500",
      "bbc300",
      "aad000",
      "96dc00",
      "7de800",
      "5bf400",
      "00FF00",
    }
  color_index = math.floor((current * table.getn(colors) / max))
  if color_index < 1 then
    color_index = 1
  elseif color_index > table.getn(colors) then
    color_index = table.getn(colors)
  end
  return colors[color_index]
end

function role_list()
  return {"base", "tank", "dps", "tankdps", "remove"}
end

function ob_role(name, test_role, checkname)
  local roles = role_list()
  if checkname == true then
    allyName = getAllyName(name)
  else
    allyName = name
  end
  local role = ""
  if allyName ~= nil then
    for _, value in ipairs(roles) do
      if string.starts(value, test_role) then
        role = test_role
        break
      end
    end
    if role == "" then
      cecho("\n<red>Non è ammesso il valore " .. test_role .. "\n")
      echo("I ruoli ammessi sono: base, tank, dps, tankdps, remove\n")
      return false
    elseif role == "remove" then
      persistent_variables[character_name]["observe_list"][allyName] = nil
      echo("\n" .. allyName .. " non più in osservazione\n")
    else
      persistent_variables[character_name]["observe_list"][allyName] = role
      echo("\n" .. allyName .. " in osservazione come " .. role .. "\n")
    end
    send("\n")
    save_persistent_var(character_name)
    return true
  end
end

function set_char_permanent_var(varname, string)
  persistent_variables[character_name][varname] = string
  save_persistent_var(character_name)
end

function bool2str(bool)
  if bool then
    return "<green>on"
  end
  return "<red>off"
end

function str2bool(str)
  str = string.lower(str)
  if str == "on" or str == "true" or str == "1" or str == 1 then
    return true
  end
  return false
end

function show_config()
  checho("\nLa configurazione del profilo attuale è:")
  checho("\n   DdEGroup: " .. bool2str(persistent_variables["config"]["dde_group"]))
  checho("\n   Suoni: " .. bool2str(persistent_variables["config"]["sounds"]))
  checho("\n   Gloria: " .. bool2str(persistent_variables["config"]["glory_timer"]))
  checho("\n   Appunti: " .. bool2str(persistent_variables["config"]["clipboard"]))
  checho(
    "\n   nascondi_scudoni: " .. bool2str(persistent_variables["config"]["hide_immune_shield"])
  )
  checho(
    "\n   nascondi_px_persi: " .. bool2str(persistent_variables["config"]["hide_lost_experience"])
  )
  checho("\n\nLa configurazione del personaggio <" .. character_name .. "> è:")
  checho("\n   gdcolor_prefisso al gd: " .. persistent_variables[character_name]["gd_start"])
  checho("\n   gdcolor_suffisso al gd: " .. persistent_variables[character_name]["gd_end"])
end

function spam_main(string)
  local help_string =
    [[
Questo è l'aiuto per SPAM (Seymour PAckage for Mudlet), un insieme
di alias, trigger e script per migliorare l'esperienza di gioco
in Dei Delle Ere.
]]
  if string == "" then
    checho(help_string)
    show_config()
    checho(
      [[


Per avere maggiori informazioni su una impostazione usa: <white>spam nomeimpostazione<gray>
Ad esempio: <white>spam ddegroup <gray>oppure <white>spam gdcolor
]]
    )
  else
    split = explode(string)
    split[1] = string.lower(split[1])
    if #split == 1 then
      if string.starts("ddegroup", split[1]) then
        cecho(
          [[

DDEGroup è uno schermo per monitorare i buff dei compagni di gruppo.
Per abilitare/disabilitare DDEGroup usa il comando: <white>spam ddegroup on/off<gray>
Per controllare le ulteriori opzioni di DDEGroup usa il comando: <white>observe<gray>]]
        )
      elseif string.starts("suoni", split[1]) then
        cecho(
          [[

Alcune funzioni di SPAM potrebbero riprodurre dei suoni.
Per controllare la riproduzione dei suoni usa il comando: <white>spam suoni on/off]]
        )
      elseif string.starts("update", split[1]) then
        cecho("<red>Aggiornamento di @PKGNAME@ in corso!")
        spam_update()
      elseif string.starts("appunti", split[1]) then
        cecho(
          [[

SPAM intercetta i valuta mostri e le identificazioni e li copia negli appunti.
Per controllare l'inserimento negli appunti usa il comando: <white>spam appunti on/off]]
        )
      elseif string.starts("nascondi_px_persi", split[1]) then
        cecho(
          [[

Per nascondere le righe che notificano la perdita di px oltre il livello usa il comando: <white>spam nascondi_px_persi on/off]]
        )
      elseif string.starts("nascondi_scudoni", split[1]) then
        cecho(
          [[

Per nascondere le righe sugli scudoni che NON colpiscono usa il comando: <white>spam nascondi_scudoni on/off]]
        )
      elseif string.starts("gloria", split[1]) then
        cecho(
          [[

La funzione Gloria permette di tenere traccia dei mob gloria uccisi nelle ultime 24 ore.
Per abilitare/disabilitare questa funzione usa il comando: <white>spam gloria on/off<gray>
Per mostrare i mob gloria uccisi nelle ultime 24 ore usa il comando: <white>gloria]]
        )
      elseif string.starts("gdcolor", split[1]) then
        cecho(
          [[

SPAM ti permette di impostare un suffisso e un prefisso per personalizzare il comando gd
Per impostare un prefisso usa il comando: <white>spam gdcolor_prefisso prefisso<gray>
Per impostare un suffisso usa il comando: <white>spam gdcolor_suffisso suffisso<gray>

Ad esempio per ottenere questo risultato: <blue>[<white>Seymour<blue>] dice al gruppo '<yellow>**<cyan>ciao<yellow>**<blue>'.
<gray>Dovresti usare i seguenti comandi
<white>spam gdcolor_prefisso &Y**&C
spam gdcolor_suffisso &Y**<gray>

Per scoprire i TAG colore disponibili in Dei delle Ere usa il comando: <white>aiuto colori<gray>
]]
        )
      else
        cecho("\nScelta non valida")
      end
    else
      if string.starts("ddegroup", split[1]) then
        persistent_variables["config"]["dde_group"] = str2bool(split[2])
        checho("\nDdEGroup: " .. bool2str(persistent_variables["config"]["dde_group"]))
        save_persistent_var("config")
        toggle_ddegroup()
      elseif string.starts("suoni", split[1]) then
        persistent_variables["config"]["sounds"] = str2bool(split[2])
        checho("\nSuoni: " .. bool2str(persistent_variables["config"]["sounds"]))
        save_persistent_var("config")
      elseif string.starts("appunti", split[1]) then
        persistent_variables["config"]["clipboard"] = str2bool(split[2])
        checho("\nAppunti: " .. bool2str(persistent_variables["config"]["clipboard"]))
        save_persistent_var("config")
      elseif string.starts("nascondi_px_persi", split[1]) then
        persistent_variables["config"]["hide_lost_experience"] = str2bool(split[2])
        checho("\nnascondi_px_persi: " .. bool2str(persistent_variables["config"]["hide_lost_experience"]))
        save_persistent_var("config")
      elseif string.starts("nascondi_scudoni", split[1]) then
        persistent_variables["config"]["hide_immune_shield"] = str2bool(split[2])
        checho("\nnascondi_scudoni: " .. bool2str(persistent_variables["config"]["hide_immune_shield"]))
        save_persistent_var("config")
      elseif string.starts("gloria", split[1]) then
        persistent_variables["config"]["glory_timer"] = str2bool(split[2])
        checho("\nGloria: " .. bool2str(persistent_variables["config"]["glory_timer"]))
        save_persistent_var("config")
      elseif split[1] == "gdcolor_prefisso" then
        set_char_permanent_var("gd_start", removeFirstWord(string))
        checho("\ngdcolor_prefisso al gd: " .. persistent_variables[character_name]["gd_start"])
      elseif split[1] == "gdcolor_suffisso" then
        set_char_permanent_var("gd_end", removeFirstWord(string))
        checho("\ngdcolor_suffisso al gd: " .. persistent_variables[character_name]["gd_end"])
      else
        cecho("\nScelta non valida")
      end
    end
  end
  send(" ")
end

function show_glory_timer()
  send("gloria")
  if persistent_variables["config"]["glory_timer"] == false then
    return
  end
  oneDayAgo = os.time(os.date("!*t")) - 24 * 60 * 60
  print("\nMOB GLORIA NELLE ULTIME 24 ORE:")
  for key, value in pairs(persistent_variables[character_name]["glory_timer"]) do
    if value > oneDayAgo then
      --print(key .. ": " .. os.date("%H:%M", value + 60 * 60))
    else
      persistent_variables[character_name]["glory_timer"][key] = nil
    end
  end
  local array = {}
  makePairs(persistent_variables[character_name]["glory_timer"], array)
  table.sort(array, greater)
  printPairs(array)
  print("")
end