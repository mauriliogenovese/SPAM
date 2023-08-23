SPAM = SPAM or {}

function toggle_ddegroup()
    if SPAM.ddeGroupContainer == nil then
        return
    end
    if SPAM.config.get("dde_group") == false then
        SPAM.ddeGroupContainer:hide()
    else
        SPAM.ddeGroupContainer:show()
    end
end

function toggle_abbilchat()
    if SPAM.abbilchatContainer == nil then
        return
    end
    if SPAM.config.get("abbil_chat") == false then
        SPAM.abbilchatContainer:hide()
    else
        SPAM.abbilchatContainer:show()
    end
end

function check_cast(cast_name)
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

function spam_update()
    uninstallPackage("@PKGNAME@")
    local git_url = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/build/SPAM.mpackage"
    if SPAM.config.get("dev") == true then
        git_url = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/dev/build/SPAM.mpackage"
    end
    installPackage(git_url)
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

function spam_eventHandler(event, ...)
    if event == "sysDownloadDone" and SPAM.downloading then
        local file = arg[1]
        if string.ends(file, "/version") then
            remote_version = {}
            table.load(file, remote_version)
            if compare_with_current_version(remote_version[1]) then
                tempTimer(2, [[cecho("\n<red>E' disponibile una nuova versione di SPAM. Per scaricarla usa il comando: <white>spam update\n")]])
            end
        end
        SPAM.downloading = false
    elseif event == "sysDownloadError" and SPAM.downloading then
        SPAM.downloading = false
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
    local name = string.lower(name)
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
    local words = {}
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
    if SPAM.config.get("clipboard") == false then
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
    if SPAM.config.get("sounds") == false then
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


-- We need this function for sorting.

local function greater(a, b)
    return a[2] > b[2]
end

-- Populate the array with key,value pairs from hashTable.

function makePairs(hashTable, array, _k)
    local k, v = next(hashTable, _k)
    if k then
        table.insert(array, { k, v })
        return makePairs(hashTable, array, k)
    end
end

function disp_time(time)
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
function printPairs(array, _i)
    local i = _i or 1
    local pair = array[i]
    if pair then
        local k, v = unpack(pair)
        if v > 0 then
            cecho("\n    <white>" .. k .. ': <grey>' .. os.date("%H:%M", v) .. " (" .. disp_time(os.difftime(os.time(), v + 24 * 60 * 60)) .. ")")
            return printPairs(array, i + 1)
        end
    end
end

function new_class()
    local class_table = {}
    class_table.buff = { dps = {}, tank = {}, base = {} }
    class_table.self_buff = { dps = {}, tank = {}, base = {} }
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
    SPAM.observe_spell_list = new_class()
    SPAM.observe_spell_list.command = "form"
    for i, v in ipairs(my_class_list) do
        if SPAM.class_list[v.classe] ~= nil then
            merge_classes(SPAM.observe_spell_list, SPAM.class_list[v.classe])
        end
    end
    deduplicate_class(SPAM.observe_spell_list)
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
    local colors = {
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
    return { "base", "tank", "dps", "tankdps", "remove" }
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

function bool2str(bool)
    if bool then
        return "<green>on"
    end
    return "<red>off"
end

function str2bool(str)
    local str = string.lower(str)
    if str == "on" or str == "true" or str == "1" or str == 1 then
        return true
    end
    return false
end

function spam_main(string)
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

Per avere maggiori informazioni su una impostazione usa: <white>spam nomeimpostazione<gray>
Ad esempio: <white>spam ddegroup <gray>oppure <white>spam gdcolor
          ]]
        )
    else
        local split = explode(string)
        split[1] = string.lower(split[1])
        if #split == 1 then
            if split[1] == "update" then
                spam_update()
            else
                SPAM.config.show_desc(split[1])
            end
        else
            SPAM.config.set_by_name(split[1], removeFirstWord(string))
        end
    end
    send(" ")
end

function show_glory_timer()
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
    makePairs(SPAM.config.get("glory_timer"), array)
    table.sort(array, greater)
    printPairs(array)
    print("\n")
end

function removeLastNumericDigits(inputString)
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

function mod_generic_mapper()

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
        roomtitle = removeLastNumericDigits(roomtitle)
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
            cur_line = string.trim(string.gsub(cur_line, v, ""))
        end
        if
        string.find(cur_line, prompt_pattern) or
                string.find(cur_line, "^Per l'affitto dei tuoi oggetti depositati in banca sono state prelevate(.+).$") or
                string.find(cur_line, "^Debbono trascorrere ancora (.+).$") or
                string.find(cur_line, "^Riconnessione.$")
        then
            cur_line = string.trim(string.gsub(cur_line, prompt_pattern, ""))
            cur_line = string.trim(string.gsub(cur_line, "^Per l'affitto dei tuoi oggetti depositati in banca sono state prelevate(.+).$", ""))
            cur_line = string.trim(string.gsub(cur_line, "^Debbono trascorrere ancora (.+).$", ""))
            cur_line = string.trim(string.gsub(cur_line, "^Riconnessione.$", ""))
            if cur_line ~= "" then
                room_name = cur_line
            else
                room_name = last_line
            end
        elseif line_count == 1 then
            cur_line = string.trim(cur_line)
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

function implode(list, separator)
    local result = ""
    for i, value in ipairs(list) do
        result = result .. value
        if i < #list then
            result = result .. separator
        end
    end
    return result
end

function get_last_word(inputString)
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

function is_prop_row(row)
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

function escape(input_string)
    if type(input_string) == "string" then
        local escaped_string = input_string:gsub([[\]], [[\\]]):gsub([[']], [[\']]):gsub([["]], [[\"]]):gsub("[[;]]","[[\;]]")
        return escaped_string
    else
        return input_string
    end
end

function parse_ident(ident_text)
    --get name and item type
    local ident = explode(ident_text:gsub("\r", ""):gsub("\n\n", "\n"), "\n")
    ident[1] = explode(ident[1], ".")[1]
    local parsed = {}
    parsed["nome"] = ident[1] .. "."
    local itm_type = get_last_word(ident[1])
    table.remove(ident, 1)
    --if item is weapon, get weapon type
    parsed["tipo_danno"] = ""
    if itm_type == "arma" then
        parsed["tipo_danno"] = get_last_word(ident[1])
        table.remove(ident, 1)
    end
    --get the diffusion from last line
    parsed["diffusione"] = get_last_word(table.remove(ident))
    --get weight and value
    local weightline = explode(ident[1], " ")
    parsed["peso"] = weightline[5]
    parsed["valore"] = weightline[8]:gsub(",", "")
    table.remove(ident, 1)
    --get rent
    parsed["affitto"] = get_last_word(ident[1]):gsub(",", "")
    table.remove(ident, 1)
    --get item_level
    parsed["livello"] = get_last_word(ident[1])
    table.remove(ident, 1)
    --initialize variable
    local affects_prefix = "";
    parsed["danno_min"] = -1;
    parsed["danno_max"] = -1;
    parsed["danno_media"] = -1;
    parsed["ac"] = -1;
    --itm_type loop
    if itm_type == "arma" then
        local dmg = explode(ident[1], " ")
        parsed["danno_min"] = dmg[5]
        parsed["danno_max"] = dmg[7]
        parsed["danno_media"] = explode(dmg[9], ")")[1]
        table.remove(ident, 1)
    elseif itm_type == "armatura" then
        parsed["ac"] = get_last_word(ident[1])
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
    --implode special property lines
    while #ident > 1 and is_prop_row(ident[2]) do
        ident[1] = ident[1] .. " " .. ident[2]
        table.remove(ident, 2)
    end
    parsed["proprieta"] = ident[1]
    table.remove(ident, 1)
    --get affects
    parsed["affects"] = affects_prefix .. implode(ident, "\n")
    parsed["SPAM.character_name"] = SPAM.character_name
    return parsed
end

function ident_to_query(parsed)
    local data = { ["sql"] = "INSERT INTO tblident_temp (nome, peso, affitto, livello, ac, proprieta, affects, diffusione, informazioni, tipo, area, valore, danno_min, danno_max, danno_media,tipo_danno) VALUES('" .. escape(parsed["nome"]) .. "', " .. escape(parsed["peso"]) .. ", " .. escape(parsed["affitto"]) .. ",  " .. escape(parsed["livello"]) .. ", " .. escape(parsed["ac"]) .. ", '" .. escape(parsed["proprieta"]) .. "', '" .. escape(parsed["affects"]) .. "', '" .. escape(parsed["diffusione"]) .. "',  '" .. escape(SPAM.character_name) .. "', 'da verificare', '', " .. escape(parsed["valore"]) .. ", " .. escape(parsed["danno_min"]) .. ", " .. escape(parsed["danno_max"]) .. ", " .. escape(parsed["danno_media"]) .. ",'" .. escape(parsed["tipo_danno"]) .. "');" }
    return data
end

function send_ident_to_db(data)
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

function getTableKeys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end

function trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function SPAM.config.save_globals()
    table.save(SPAM.config.globals_savelocation, SPAM.config.persistent_globals)
    toggle_ddegroup()
    toggle_abbilchat()
end

function SPAM.config.load_globals()
    if SPAM.config.persistent_globals == nil then
        SPAM.config.persistent_globals = {}
    end
    if file_exists(SPAM.config.globals_savelocation) then
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
    if file_exists(SPAM.config.characters_savelocation) then
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
            row = row .. bool2str(SPAM.config.persistent_globals[config_name])
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
            row = row .. bool2str(SPAM.config.persistent_characters[SPAM.character_name][config_name])
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
        if k == config_name or string.starts(string.lower(v.name), string.lower(config_name)) then
            cecho("\n" .. v.desc .. "\n\n")
            return
        end
    end
    for k, v in pairs(SPAM.config.characters) do
        if k == config_name or string.starts(string.lower(v.name), string.lower(config_name))  then
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
        if string.starts(string.lower(v.name), string.lower(config_name)) then
            if v.var_type == "bool" then
                value = str2bool(value)
            end
            SPAM.config.set(k,value,report)
            return
        end
    end
    for k, v in pairs(SPAM.config.characters) do
        if string.starts(string.lower(v.name), string.lower(config_name)) then
            if v.var_type == "bool" then
                value = str2bool(value)
            end
            SPAM.config.set(k,value,report)
            return
        end
    end
    cecho("\nScelta non valida\n\n")
end
