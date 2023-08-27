SPAM = SPAM or {}

-- string manipulation functions
SPAM.string = SPAM.string or {}

function SPAM.string.trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function SPAM.string.parse_bool(bool)
    if bool then
        return "<green>on"
    end
    return "<red>off"
end

function SPAM.string.to_bool(str)
    local str = string.lower(str)
    if str == "on" or str == "true" or str == "1" or str == 1 then
        return true
    end
    return false
end

function SPAM.string.removeLastNumericDigits(inputString)
    if type(inputString) ~= "string" then
        return nil
    end

    local lastChar = string.sub(inputString, -1) -- Get the last character
    local secondLastChar = string.sub(inputString, -2, -2) -- Get the second to last character

    if tonumber(lastChar) and tonumber(secondLastChar) then
        local modifiedString = string.sub(inputString, 1, -3) -- Remove the last two characters
        return modifiedString
    else
        return inputString
    end
end

function SPAM.string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function SPAM.string.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function SPAM.string.explode(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function SPAM.string.implode(list, separator)
    local result = ""
    for i, value in ipairs(list) do
        result = result .. value
        if i < #list then
            result = result .. separator
        end
    end
    return result
end

function SPAM.string.get_last_word(inputString)
    local lastWord = nil
    local lastChar = inputString:sub(-1)
    -- Get the last character of the input string
    -- Remove the last character if it's a period
    if lastChar == "." then
        inputString = inputString:sub(1, -2)
    end
    -- Split the inputString by spaces and ' characters
    local words = {}
    for word in inputString:gmatch("[^%s']+") do
        table.insert(words, word)
    end
    if #words > 0 then
        lastWord = words[#words]
    end
    return lastWord
end

function SPAM.string.escape(input_string)
    if type(input_string) == "string" then
        local escaped_string = input_string:gsub([[\]], [[\\]]):gsub([[']], [[\']]):gsub([["]], [[\"]]):gsub("[[;]]","[[\;]]")
        return escaped_string
    else
        return input_string
    end
end

function SPAM.string.removeFirstTwoWords(str)
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

function SPAM.string.removeFirstWord(str)
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

-- table manipulation functions
SPAM.table = SPAM.table or {}

function SPAM.table.merge(old_table, new_table)
    table.foreach(
            old_table,
            function(k, v)
                table.insert(new_table, v)
            end
    )
end

function SPAM.table.delete(x)
    for k in pairs(x) do
        x[k] = nil
    end
end

--remove duplicates from a table
function SPAM.table.deduplicate(x)
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

function SPAM.table.get_keys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end


function SPAM.toggle_ddegroup()
    if SPAM.ddeGroupContainer == nil then
        return
    end
    if SPAM.config.get("dde_group") == false then
        SPAM.ddeGroupContainer:hide()
    else
        SPAM.ddeGroupContainer:show()
    end
end

function SPAM.toggle_abbilchat()
    if SPAM.abbilchatContainer == nil then
        return
    end
    if SPAM.config.get("abbil_chat") == false then
        SPAM.abbilchatContainer:hide()
    else
        SPAM.abbilchatContainer:show()
    end
end

function SPAM.check_cast(cast_name)
    if gmcp.Char.Magie.incantesimi ~= nil then
        local cast_name = string.lower(cast_name)
        for i, v in ipairs(gmcp.Char.Magie.incantesimi) do
            if string.lower(v.nome) == cast_name then
                return true
            end
        end
    end
    return false
end

function SPAM.update()
    uninstallPackage("@PKGNAME@")
    local git_url = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/build/SPAM.mpackage"
    if SPAM.config.get("dev") == true then
        git_url = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/dev/build/SPAM.mpackage"
    end
    installPackage(git_url)
end

function SPAM.file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function SPAM.parse_version(string)
    local major, minor, patch = string.match(string, "(%d+)%.(%d+)%.(%d+)")
    return major, minor, patch
end

function SPAM.compare_with_current_version(newversion)
    if newversion == "@VERSION@" then
        return false
    end
    v1_major, v1_minor, v1_patch = SPAM.parse_version(newversion)
    v2_major, v2_minor, v2_patch = SPAM.parse_version("@VERSION@")
    if v1_major > v2_major then
        return true
    elseif v1_major < v2_major then
        return false
    elseif v1_minor > v2_minor then
        return true
    elseif v1_minor < v2_minor then
        return false
    else
        return v1_patch > v2_patch
    end
    return false
end

function SPAM.eventHandler(event, ...)
    if event == "sysDownloadDone" and SPAM.downloading then
        local file = arg[1]
        if string.ends(file, "/version") then
            remote_version = {}
            table.load(file, remote_version)
            if SPAM.compare_with_current_version(remote_version[1]) then
                tempTimer(6, [[cecho("\n<red>ATTENZIONE: <grey>E' disponibile una nuova versione di SPAM. Per scaricarla usa il comando: <yellow>spam update\n")]])
            end
        end
        SPAM.downloading = false
    elseif event == "sysDownloadError" and SPAM.downloading then
        SPAM.downloading = false
    end
end

function SPAM.getAllyName(name)
    local name = string.lower(name)
    if gmcp.Char.Gruppo.gruppo == nil then
        if SPAM.string.starts(string.lower(gmcp.Char.Name.name), name) then
            return gmcp.Char.Name.name
        end
        return
    end
    local gruppo = gmcp.Char.Gruppo.gruppo
    for i, v in ipairs(gruppo) do
        v.nome = SPAM.beautifyName(v.nome)
        if SPAM.string.starts(string.lower(v.nome), name) then
            return v.nome
        end
    end
    return nil
end

--remove articles or other unnecessary names from followers

function SPAM.beautifyName(name)
    if SPAM.string.starts(string.lower(name), "un enorme ") then
        name = string.gsub(string.lower(name), "un enorme ", "")
    elseif SPAM.string.starts(string.lower(name), "una ") then
        name = string.gsub(string.lower(name), "una ", "")
    elseif SPAM.string.starts(string.lower(name), "l'") then
        name = string.gsub(string.lower(name), "l'", "")
    elseif SPAM.string.starts(string.lower(name), "della ") then
        name = string.gsub(string.lower(name), "della ", "")
    elseif SPAM.string.starts(string.lower(name), "un ") then
        name = string.gsub(string.lower(name), "un ", "")
    elseif SPAM.string.starts(string.lower(name), "un' ") then
        name = string.gsub(string.lower(name), "un' ", "")
    end
    local words = {}
    words[1], words[2] = name:match("(%w+)(%W+)")
    if words[1] == nil then
        words[1] = name
    end
    words[1] = SPAM.string.firstToUpper(words[1])
    return words[1]
end

function SPAM.get_os()
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

function SPAM.play_sound(file)
    if SPAM.config.get("sounds") == false then
        return
    end
    if SPAM.get_os() == "linux" then
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


-- We need this function for sorting.
local function greater(a, b)
    return a[2] > b[2]
end

-- Populate the array with key,value pairs from hashTable.

function SPAM.makePairs(hashTable, array, _k)
    local k, v = next(hashTable, _k)
    if k then
        table.insert(array, { k, v })
        return SPAM.makePairs(hashTable, array, k)
    end
end

function SPAM.disp_time(time)
    local negative = false

    if time < 0 then
        negative = true
        time = time * -1
    end
    local days = math.floor(time / 86400)
    local hours = math.floor(math.mod(time, 86400) / 3600)
    local minutes = math.floor(math.mod(time, 3600) / 60)
    local seconds = math.floor(math.mod(time, 60))
    time_string = string.format("%02d:%02d", hours, minutes)
    if negative then
        time_string = "-" .. time_string
    end
    return time_string
    --return string.format("%d:%02d:%02d:%02d",days,hours,minutes,seconds)
end

-- Print the pairs from the array.
function SPAM.printPairs(array, _i)
    local i = _i or 1
    local pair = array[i]
    if pair then
        local k, v = unpack(pair)
        if v > 0 then
            cecho("\n    <white>" .. k .. ': <grey>' .. os.date("%H:%M", v) .. " (" .. SPAM.disp_time(os.difftime(os.time(), v + 24 * 60 * 60)) .. ")")
            return SPAM.printPairs(array, i + 1)
        end
    end
end

function SPAM.new_class()
    local class_table = {}
    class_table.buff = { dps = {}, tank = {}, base = {} }
    class_table.self_buff = { dps = {}, tank = {}, base = {} }
    class_table.move = {}
    class_table.heal = {}
    return class_table
end

--merge 2 classes table by table

function SPAM.merge_classes(new_class, old_class)
    SPAM.table.merge(old_class.buff.dps, new_class.buff.dps)
    SPAM.table.merge(old_class.buff.tank, new_class.buff.tank)
    SPAM.table.merge(old_class.buff.base, new_class.buff.base)
    SPAM.table.merge(old_class.self_buff.dps, new_class.self_buff.dps)
    SPAM.table.merge(old_class.self_buff.tank, new_class.self_buff.tank)
    SPAM.table.merge(old_class.self_buff.base, new_class.self_buff.base)
    if old_class.heal ~= nil then
        SPAM.table.merge(old_class.heal, new_class.heal)
    end
    if old_class.move ~= nil then
        SPAM.table.merge(old_class.move, new_class.move)
    end
    if old_class.command ~= nil then
        new_class.command = old_class.command
    end
end

--remove duplicates from each class table
function SPAM.deduplicate_class(class)
    SPAM.table.deduplicate(class.buff.dps)
    SPAM.table.deduplicate(class.buff.tank)
    SPAM.table.deduplicate(class.buff.base)
    SPAM.table.deduplicate(class.self_buff.dps)
    SPAM.table.deduplicate(class.self_buff.tank)
    SPAM.table.deduplicate(class.self_buff.base)
    SPAM.table.deduplicate(class.move)
end

--generate spell list to observe based on player classes

function SPAM.gen_spell_list(my_class_list)
    SPAM.observe_spell_list = SPAM.new_class()
    SPAM.observe_spell_list.command = "form"
    for i, v in ipairs(my_class_list) do
        if SPAM.class_list[v.classe] ~= nil then
            SPAM.merge_classes(SPAM.observe_spell_list, SPAM.class_list[v.classe])
        end
    end
    SPAM.deduplicate_class(SPAM.observe_spell_list)
end

function SPAM.getPFcolor(current, max)
    local color_index = math.floor((current * #SPAM.colors / max))
    if color_index < 1 then
        color_index = 1
    elseif color_index > #SPAM.colors then
        color_index = #SPAM.colors
    end
    -- invert index because SPAM.colors is from red to green
    return SPAM.colors[#SPAM.colors+1-color_index]
end

function SPAM.role_list()
    return { "base", "tank", "dps", "tankdps", "remove" }
end

function SPAM.ob_role(name, test_role, checkname)
    local roles = SPAM.role_list()
    if checkname == true then
        allyName = SPAM.getAllyName(name)
    else
        allyName = name
    end
    local role = ""
    if allyName ~= nil then
        for _, value in ipairs(roles) do
            if SPAM.string.starts(value, test_role) then
                role = test_role
                break
            end
        end
        if role == "" then
            cecho("\n<red>Non è ammesso il valore " .. test_role .. "\n")
            echo("I ruoli ammessi sono: base, tank, dps, tankdps, remove\n")
        elseif role == "remove" then
            SPAM.config.get("observe_list")[allyName] = nil
            echo("\n" .. allyName .. " non più in osservazione\n")
        else
            SPAM.config.get("observe_list")[allyName] = role
            echo("\n" .. allyName .. " in osservazione come " .. role .. "\n")
        end
        send("\n")
        SPAM.config.save_characters()
        return true
    end
end

function SPAM.main_help(string)
    local help_string = [[
Questo è l'aiuto per SPAM (Seymour PAckage for Mudlet), un insieme
di alias, trigger e script per migliorare l'esperienza di gioco
in Dei Delle Ere.
]]
    if string == "" then
        checho(help_string)
        SPAM.config.show_all()
        checho(
                [[

Per avere maggiori informazioni su una impostazione usa: <yellow>spam nomeimpostazione<grey>
Ad esempio: <yellow>spam ddegroup <grey>oppure <yellow>spam gdcolor
          ]]
        )
    else
        local split = SPAM.string.explode(string)
        split[1] = string.lower(split[1])
        if #split == 1 then
            if split[1] == "update" then
                SPAM.update()
            else
                SPAM.config.show_desc(split[1])
            end
        else
            SPAM.config.set_by_name(split[1], SPAM.string.removeFirstWord(string))
        end
    end
    send(" ")
end

function SPAM.show_glory_timer()
    send("gloria")
    if SPAM.config.get("glory") == false then
        return
    end
    local oneDayAgo = os.time() - 24 * 60 * 60
    local printed_title = false
    for key, value in pairs(SPAM.config.get("glory_timer")) do
        if value > oneDayAgo then
            --print(key .. ": " .. os.date("%H:%M", value + 60 * 60))
        else
            if not printed_title then
                cecho("\n<yellow>MOB GLORIA PASSATI:")
                printed_title = true
            end
            SPAM.config.get("glory_timer")[key] = -1
            cecho("\n    <white>" .. key)
        end
    end
    if printed_title then
        echo("\n")
    end
    cecho("\n<yellow>MOB GLORIA NELLE ULTIME 24 ORE:")
    local array = {}
    SPAM.makePairs(SPAM.config.get("glory_timer"), array)
    table.sort(array, greater)
    SPAM.printPairs(array)
    print("\n")
end

function SPAM.mod_mudlet_mapper()

    if SPAM.oldsanitize ~= nil then
        return
    end
    --generic mapper mod for DDE
    map.configs.lang_dirs = {
        d = "b",
        down = "basso",
        e = "e",
        east = "est",
        eastdown = "estbasso",
        eastup = "estalto",
        ed = "ed",
        eu = "eu",
        l = "g",
        look = "guarda",
        n = "n",
        nd = "nd",
        ne = "ne",
        north = "nord",
        northdown = "nordbasso",
        northeast = "nordest",
        northup = "nordalto",
        northwest = "nordovest",
        nu = "na",
        nw = "no",
        out = "out",
        s = "s",
        sd = "sb",
        se = "se",
        south = "sud",
        southdown = "sudbasso",
        southeast = "sudest",
        southup = "sudalto",
        southwest = "sudovest",
        su = "sa",
        sw = "so",
        u = "a",
        up = "alto",
        w = "o",
        wd = "ob",
        west = "ovest",
        westdown = "ovestbasso",
        westup = "ovestalto",
        wu = "oa"
    }
    map.configs.lang_dirs["in"] = "in"
    map.configs.translate = {}
    for k, v in pairs(map.configs.lang_dirs) do
        map.configs.translate[v] = k
    end
    SPAM.oldsanitize = map.sanitizeRoomName
    map.sanitizeRoomName = function(roomtitle)
        roomtitle = string.gsub(roomtitle, ".----N----. ", "")
        roomtitle = SPAM.string.removeLastNumericDigits(roomtitle)
        return SPAM.oldsanitize(roomtitle)
    end
    map.save.prompt_pattern[map.character] = "^PF:(.+)>$"
    find_prompt = false
    map.configs.custom_name_search = true
end

function mudlet.custom_name_search(lines)
    local room_name
    local line_count = #lines + 1
    local cur_line, last_line
    local prompt_pattern = map.save.prompt_pattern[map.character]
    if not prompt_pattern then
        return
    end
    while not room_name do
        line_count = line_count - 1
        if not lines[line_count] then
            break
        end
        cur_line = lines[line_count]
        for k, v in ipairs(map.save.ignore_patterns) do
            cur_line = string.SPAM.string.trim(string.gsub(cur_line, v, ""))
        end
        if
        string.find(cur_line, prompt_pattern) or
                string.find(cur_line, "^Per l'affitto dei tuoi oggetti depositati in banca sono state prelevate(.+).$") or
                string.find(cur_line, "^Debbono trascorrere ancora (.+).$") or
                string.find(cur_line, "^Riconnessione.$")
        then
            cur_line = string.SPAM.string.trim(string.gsub(cur_line, prompt_pattern, ""))
            cur_line = string.SPAM.string.trim(string.gsub(cur_line, "^Per l'affitto dei tuoi oggetti depositati in banca sono state prelevate(.+).$", ""))
            cur_line = string.SPAM.string.trim(string.gsub(cur_line, "^Debbono trascorrere ancora (.+).$", ""))
            cur_line = string.SPAM.string.trim(string.gsub(cur_line, "^Riconnessione.$", ""))
            if cur_line ~= "" then
                room_name = cur_line
            else
                room_name = last_line
            end
        elseif line_count == 1 then
            cur_line = string.SPAM.string.trim(cur_line)
            if cur_line ~= "" then
                room_name = cur_line
            else
                room_name = last_line
            end
        elseif not string.match(cur_line, "^%s*$") then
            last_line = cur_line
        end
    end
    lines = {}
    room_name = room_name:sub(1, 100)
    return room_name
end

function SPAM.is_prop_row(row)
    local tags = {
        "ANTI-",
        "FRAGILE",
        "RESISTENTE",
        "ETERNO",
        "BENEDETTO",
        "CLASSE",
        "UNIQUE",
        "MAGICO",
        "METALLICO",
        "RONZANTE",
        "TRASPORTABILE",
        "ORGANICO",
        "MALVAGIO",
    }
    for tagCount = 1, #tags do
        if string.find(row, tags[tagCount]) then
            return true
        end
    end
    return false
end

function SPAM.parse_ident(ident_text)
    --get name and item type
    local ident = SPAM.string.explode(ident_text:gsub("\r", ""):gsub("\n\n", "\n"), "\n")
    ident[1] = SPAM.string.explode(ident[1], ".")[1]
    local parsed = {}
    parsed["nome"] = ident[1] .. "."
    local itm_type = SPAM.string.get_last_word(ident[1])
    table.remove(ident, 1)
    --if item is weapon, get weapon type
    parsed["tipo_danno"] = ""
    if itm_type == "arma" then
        parsed["tipo_danno"] = SPAM.string.get_last_word(ident[1])
        table.remove(ident, 1)
    end
    --get the diffusion from last line
    parsed["diffusione"] = SPAM.string.get_last_word(table.remove(ident))
    --get weight and value
    local weightline = SPAM.string.explode(ident[1], " ")
    parsed["peso"] = weightline[5]
    parsed["valore"] = weightline[8]:gsub(",", "")
    table.remove(ident, 1)
    --get rent
    parsed["affitto"] = SPAM.string.get_last_word(ident[1]):gsub(",", "")
    table.remove(ident, 1)
    --get item_level
    parsed["livello"] = SPAM.string.get_last_word(ident[1])
    table.remove(ident, 1)
    --initialize variable
    local affects_prefix = "";
    parsed["danno_min"] = -1;
    parsed["danno_max"] = -1;
    parsed["danno_media"] = -1;
    parsed["ac"] = -1;
    --itm_type loop
    if itm_type == "arma" then
        local dmg = SPAM.string.explode(ident[1], " ")
        parsed["danno_min"] = dmg[5]
        parsed["danno_max"] = dmg[7]
        parsed["danno_media"] = SPAM.string.explode(dmg[9], ")")[1]
        table.remove(ident, 1)
    elseif itm_type == "armatura" then
        parsed["ac"] = SPAM.string.get_last_word(ident[1])
        table.remove(ident, 1)
    elseif itm_type == "contenitore" then
        affects_prefix = ident[1] .. "\n"
        table.remove(ident, 1)
    elseif
    (itm_type == "magica" or itm_type == "pozione" or itm_type == "magico") and
            string.find(ident[1], "seguenti magie")
    then
        while not string.find(ident[2], "Proprieta' speciali") do
            affects_prefix = affects_prefix .. ident[1] .. "\n"
            table.remove(ident, 1)
        end
        affects_prefix = affects_prefix .. ident[1] .. "\n"
        table.remove(ident, 1)
    end
    --SPAM.implode special property lines
    while #ident > 1 and SPAM.is_prop_row(ident[2]) do
        ident[1] = ident[1] .. " " .. ident[2]
        table.remove(ident, 2)
    end
    parsed["proprieta"] = ident[1]
    table.remove(ident, 1)
    --get affects
    parsed["affects"] = affects_prefix .. SPAM.string.implode(ident, "\n")
    parsed["affects"] = parsed["affects"]:gsub("\n%s*$", "")
    parsed["SPAM.character_name"] = SPAM.character_name
    return parsed
end

function SPAM.ident_to_query(parsed)
    local data = { ["sql"] = "INSERT INTO tblident_temp (nome, peso, affitto, livello, ac, proprieta, affects, diffusione, informazioni, tipo, area, valore, danno_min, danno_max, danno_media,tipo_danno) VALUES('" .. SPAM.string.escape(parsed["nome"]) .. "', " .. SPAM.string.escape(parsed["peso"]) .. ", " .. SPAM.string.escape(parsed["affitto"]) .. ",  " .. SPAM.string.escape(parsed["livello"]) .. ", " .. SPAM.string.escape(parsed["ac"]) .. ", '" .. SPAM.string.escape(parsed["proprieta"]) .. "', '" .. SPAM.string.escape(parsed["affects"]) .. "', '" .. SPAM.string.escape(parsed["diffusione"]) .. "',  '" .. SPAM.string.escape(SPAM.character_name) .. "', 'da verificare', '', " .. SPAM.string.escape(parsed["valore"]) .. ", " .. SPAM.string.escape(parsed["danno_min"]) .. ", " .. SPAM.string.escape(parsed["danno_max"]) .. ", " .. SPAM.string.escape(parsed["danno_media"]) .. ",'" .. SPAM.string.escape(parsed["tipo_danno"]) .. "');" }
    return data
end

function SPAM.send_ident_to_db(data)
    -- send to db only if function is enabled
    if SPAM.config.get("auto_send") == false then
        return
    end
    -- This will create a JSON message body. Many modern REST APIs expect a JSON body.
    -- data must be a table
    local url = "https://maker.ifttt.com/trigger/DDE_IDENT/json/with/key/detdl1yCyfRQmLZnf3jFvg"
    local header = { ["Content-Type"] = "application/json" }
    -- first we create something to handle the success, and tell us what we got
    registerAnonymousEventHandler(
            'sysPostHttpDone',
            function(event, rurl, response)
                if rurl == url then
                    --display(response)
                    cecho("\n\n<yellow>Identificazione inviata con successo al NariaDB\n\n")
                else
                    return true
                end
                -- this will show us the response body, or if it's not the right url, then do not delete the handler
            end,
            true
    )
    -- this sets it to delete itself after it fires
    -- then we create something to handle the error message, and tell us what went wrong
    registerAnonymousEventHandler(
            'sysPostHttpError',
            function(event, response, rurl)
                if rurl == url then
                    --display(response)
                    cecho("\n\n<red>ERRORE: invio identificazione al NariaDB\n\n")
                else
                    return true
                end
                -- this will show us the response body, or if it's not the right url, then do not delete the handler
            end,
            true
    )
    -- this sets it to delete itself after it fires
    -- Lastly, we make the request:
    postHTTP(yajl.to_string(data), url, header)
    -- yajl.to_string converts our Lua table into a JSON-like string so the server can understand it
end

function SPAM.config.save_globals()
    table.save(SPAM.config.globals_savelocation, SPAM.config.persistent_globals)
    SPAM.toggle_ddegroup()
    SPAM.toggle_abbilchat()
end

function SPAM.config.load_globals()
    if SPAM.config.persistent_globals == nil then
        SPAM.config.persistent_globals = {}
    end
    if SPAM.file_exists(SPAM.config.globals_savelocation) then
        table.load(SPAM.config.globals_savelocation, SPAM.config.persistent_globals)
    end
    SPAM.config.initialize_persistent_globals()
end

function SPAM.config.initialize_persistent_globals()
    local save = false
    for k, v in pairs(SPAM.config.globals) do
        if SPAM.config.persistent_globals[k] == nil then
            SPAM.config.persistent_globals[k] = v.default
            save = true
        end
    end
    SPAM.config.save_globals()
end

function SPAM.config.save_characters()
    table.save(SPAM.config.characters_savelocation, SPAM.config.persistent_characters)
end

function SPAM.config.load_characters()
    if SPAM.config.persistent_characters == nil then
        SPAM.config.persistent_characters = {}
    end
    if SPAM.file_exists(SPAM.config.characters_savelocation) then
        table.load(SPAM.config.characters_savelocation, SPAM.config.persistent_characters)
    end
end

function SPAM.config.load_character(character_name)
    if SPAM.config.persistent_characters[character_name] == nil then
        SPAM.config.persistent_characters[character_name] = {}
    end
    SPAM.config.initialize_persistent_character(character_name)
end

function SPAM.config.initialize_persistent_character(character_name)
    local save = false
    for k, v in pairs(SPAM.config.characters) do
        if SPAM.config.persistent_characters[character_name][k] == nil then
            SPAM.config.persistent_characters[character_name][k] = v.default
            save = true
        end
    end
    SPAM.config.save_characters()
end

function SPAM.config.show_global(config_name)
    local row = ""
    if SPAM.config.globals[config_name] ~= nil then
        row = "    " .. SPAM.config.globals[config_name].name ..": "
        if SPAM.config.globals[config_name].var_type == "bool" then
            if SPAM.config.globals[config_name].hidden == true and SPAM.config.persistent_globals[config_name] == false then
                return
            end
            row = row .. SPAM.string.parse_bool(SPAM.config.persistent_globals[config_name])
        else
            row = row .. SPAM.config.persistent_globals[config_name]
            end
        cecho(row.."\n")
    end
end

function SPAM.config.show_character(config_name)
    local row = ""
    if SPAM.config.characters[config_name] ~= nil and SPAM.config.characters[config_name].hidden ~= true then
        row = "    " .. SPAM.config.characters[config_name].name ..": "
        if SPAM.config.characters[config_name].var_type == "bool" then
            row = row .. SPAM.string.parse_bool(SPAM.config.persistent_characters[SPAM.character_name][config_name])
        else
            row = row .. SPAM.config.persistent_characters[SPAM.character_name][config_name]
            end
        cecho(row.."\n")
    end
end

function SPAM.config.show_all()
    checho("\nLa configurazione del profilo attuale è:\n")
    for k, v in pairs(SPAM.config.globals) do
        SPAM.config.show_global(k)
    end
    if SPAM.character_name ~= nil then
        checho("\nLa configurazione del personaggio <" .. SPAM.character_name .. "> è:\n")
        for k, v in pairs(SPAM.config.characters) do
            SPAM.config.show_character(k)
        end
    end
end

function SPAM.config.show_desc(config_name)
    for k, v in pairs(SPAM.config.globals) do
        if k == config_name or SPAM.string.starts(string.lower(v.name), string.lower(config_name)) then
            cecho("\n" .. v.desc .. "\n\n")
            return
        end
    end
    for k, v in pairs(SPAM.config.characters) do
        if k == config_name or SPAM.string.starts(string.lower(v.name), string.lower(config_name))  then
            cecho("\n" .. v.desc .. "\n\n")
            return
        end
    end
    cecho("\nScelta non valida\n\n")
end

function SPAM.config.get(config_name)
    if SPAM.config.globals[config_name] ~= nil then
        return SPAM.config.persistent_globals[config_name]
    elseif SPAM.character_name ~= nil and SPAM.config.characters[config_name] ~= nil then
        return SPAM.config.persistent_characters[SPAM.character_name][config_name]
    end
end

function SPAM.config.set(config_name, value, report)
    report = report or false
    if SPAM.config.globals[config_name] ~= nil then
        SPAM.config.persistent_globals[config_name] = value
        if report then
            SPAM.config.show_global(config_name)
        end
        SPAM.config.save_globals()
    elseif SPAM.character_name ~= nil and SPAM.config.characters[config_name] ~= nil then
        SPAM.config.persistent_characters[SPAM.character_name][config_name] = value
        if report then
            SPAM.config.show_character(config_name)
        end
        SPAM.config.save_characters()
    end
end

function SPAM.config.set_by_name(config_name, value, report)
    report = report or true
    for k, v in pairs(SPAM.config.globals) do
        if SPAM.string.starts(string.lower(v.name), string.lower(config_name)) then
            if v.var_type == "bool" then
                value = SPAM.string.to_bool(value)
            end
            SPAM.config.set(k,value,report)
            return
        end
    end
    for k, v in pairs(SPAM.config.characters) do
        if SPAM.string.starts(string.lower(v.name), string.lower(config_name)) then
            if v.var_type == "bool" then
                value = SPAM.string.to_bool(value)
            end
            SPAM.config.set(k,value,report)
            return
        end
    end
    cecho("\nScelta non valida\n\n")
end
