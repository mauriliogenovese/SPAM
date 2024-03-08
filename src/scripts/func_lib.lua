SPAM = SPAM or {}

-- string manipulation functions
SPAM.string = SPAM.string or {}

function SPAM.string.trim(input_string)
  return (string.gsub(input_string, "^%s*(.-)%s*$", "%1"))
end

function SPAM.string.parse_bool(input_bool)
    if input_bool then
        return "<green>on"
    end
    return "<red>off"
end

function SPAM.string.to_bool(input_string)
    local str = string.lower(input_string)
    if str == "on" or str == "true" or str == "1" or str == 1 then
        return true
    end
    return false
end

function SPAM.string.remove_last_numeric_char(input_string)
    if type(input_string) ~= "string" then
        return nil
    end

    local last_char = string.sub(input_string, -1) -- Get the last character
    local second_last_char = string.sub(input_string, -2, -2) -- Get the second to last character

    if tonumber(last_char) and tonumber(second_last_char) then
        local modified_string = string.sub(input_string, 1, -3) -- Remove the last two characters
        return modified_string
    else
        return input_string
    end
end

function SPAM.string.starts(input_string, start)
    return string.sub(input_string, 1, string.len(start)) == start
end

function SPAM.string.first_upper(input_string)
    return (input_string:gsub("^%l", string.upper))
end

function SPAM.string.explode(input_string, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}
    for str in string.gmatch(input_string, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function SPAM.string.int_to_fixed_string(input_int, len)
    local my_string = tostring(input_int)
    for i = 1, (len - string.len(my_string)) do
        my_string = "0" .. my_string
    end
    return my_string
end

function SPAM.string.implode(input_table, separator)
    local result = ""
    for i, value in ipairs(input_table) do
        result = result .. value
        if i < #input_table then
            result = result .. separator
        end
    end
    return result
end

function SPAM.string.get_last_word(input_string)
    local last_word = nil
    local last_char = input_string:sub(-1)
    -- Get the last character of the input string
    -- Remove the last character if it's a period
    if last_char == "." then
        input_string = input_string:sub(1, -2)
    end
    -- Split the inputString by spaces and ' characters
    local words = {}
    for word in input_string:gmatch("[^%s']+") do
        table.insert(words, word)
    end
    if #words > 0 then
        last_word = words[#words]
    end
    return last_word
end

function SPAM.string.escape(input_string)
    if type(input_string) == "string" then
        local escaped_string = input_string:gsub([[\]], [[\\]]):gsub([[']], [[\']]):gsub([["]], [[\"]]):gsub("[[;]]","[[\;]]")
        return escaped_string
    else
        return input_string
    end
end

function SPAM.string.remove_first_two_words(input_string)
    -- cerca la posizione della terza parola nella stringa
    local _, pos = string.find(input_string, "%S+%s+%S+%s+")
    if pos then
        -- se la terza parola esiste, restituisce la parte rimanente della stringa
        return string.sub(input_string, pos + 1)
    else
        -- se la terza parola non esiste, restituisce una stringa vuota
        return ""
    end
end

function SPAM.string.remove_first_word(input_string)
    -- cerca la posizione della terza parola nella stringa
    local _, pos = string.find(input_string, "%S+%s+")
    if pos then
        -- se la terza parola esiste, restituisce la parte rimanente della stringa
        return string.sub(input_string, pos + 1)
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

function SPAM.table.merge_class(old_table, new_table)
    table.foreach(
            old_table,
            function(k, v)
                local refined_cast_name = SPAM.get_known_cast(v)
                if refined_cast_name ~= nil then
                    table.insert(new_table, v)
                end
            end
    )
end

function SPAM.table.delete(input_table)
    for k in pairs(input_table) do
        input_table[k] = nil
    end
end

--remove duplicates from a table
function SPAM.table.deduplicate(input_table)
    local seen = {}
    for index, item in ipairs(input_table) do
        if seen[item] then
            table.remove(input_table, index)
        else
            seen[item] = true
        end
    end
    if seen["nuovo vigore"] then
        for k in pairs(input_table) do
            input_table[k] = nil
        end
        table.insert(input_table, "nuovo vigore")
    end
end

function SPAM.table.get_keys(input_table)
    local keys = {}
    for key, _ in pairs(input_table) do
        table.insert(keys, key)
    end
    return keys
end


function SPAM.toggle_dde_group()
    if SPAM.dde_group_container == nil then
        return
    end
    if SPAM.config.get("dde_group") == false then
        SPAM.dde_group_container:hide()
    elseif SPAM.dde_group_container.hidden == true then
        SPAM.dde_group_container:show()
    end
end

function SPAM.toggle_abbil_chat()
    if SPAM.abbil_chat_container == nil then
        return
    end
    if SPAM.config.get("abbil_chat") == false then
        SPAM.abbil_chat_container:hide()
    elseif SPAM.abbil_chat_container.hidden == true then
        SPAM.abbil_chat_container:show()
    end
end

function SPAM.is_class(class_name)
    local is_class = false
    for i, v in ipairs(gmcp.Char.Classi.classi) do
        if string.lower(v.classe) == string.lower(class_name) then
            is_class = true
            break
        end
    end
    return is_class
end

function SPAM.toggle_mem_helper()
    if SPAM.mem_container == nil then
        return
    end

    if SPAM.is_class("stregone") == false or SPAM.config.get("mem_helper") == false then
        SPAM.mem_container:hide()
    elseif SPAM.mem_container.hidden == true then
        SPAM.mem_container:show()
    end
end


function SPAM.get_known_cast(cast_name)
    for _, v in ipairs(gmcp.Char.Skills) do
        if v.tipo == "incantesimo" and SPAM.string.starts(v.nome, cast_name) then
            return string.lower(v.nome)
        end
    end
    return nil
end

function SPAM.print_mem()
    clearWindow("MEM Helper")
    SPAM.mem_widget:cecho("\n")
    SPAM.mem_widget:cecho ("\nHai <royal_blue>" .. gmcp.Char.Magie.memorizzare.in_memoria .. "<grey>/<cyan>" .. gmcp.Char.Magie.memorizzare.in_totale ..  "<grey> incantesimi memorizzati:\n")
    for _, v in pairs(gmcp.Char.Magie.memorizzazioni) do
        row = SPAM.string.first_upper(v.nome)
        for i = 1, (30 - string.len(v.nome)) do
            row = row .. "."
        end
        row = row .. "  <royal_blue>" .. v.memorizzati .."<grey>/<cyan>" .. gmcp.Char.Magie.memorizzare.per_tipo .."<grey>"
        if v.in_studio > 0 then
            row = row .. "  In studio: <royal_blue>" .. v.in_studio .."<grey>"
        end
        if SPAM.config.get("automem")[v.nome] ~= nil then
            row = row .. "  Automem: <royal_blue>" .. SPAM.config.get("automem")[v.nome] .."<grey>"
        end
        row = row .. "\n"
        SPAM.mem_widget:cecho(row)
    end
    SPAM.mem_widget:cecho("\n")
    if gmcp.Char.Magie.memorizzare.in_studio == 0 then
        SPAM.mem_widget:cecho ("Non stai memorizzando alcun incantesimo. Puoi memorizzarne ancora <royal_blue>" .. (gmcp.Char.Magie.memorizzare.in_totale - gmcp.Char.Magie.memorizzare.in_memoria) .. "<grey>.")
    else
        SPAM.mem_widget:cecho ("Stai memorizzando <royal_blue>" .. gmcp.Char.Magie.memorizzare.in_studio .. "<grey>/<cyan>" .. gmcp.Char.Magie.memorizzare.per_studio .. "<grey> incantesimi. Ne avrai memorizzati <royal_blue>" ..  (gmcp.Char.Magie.memorizzare.in_memoria + gmcp.Char.Magie.memorizzare.in_studio) .. "<grey>/<cyan>" .. gmcp.Char.Magie.memorizzare.in_totale .. "<grey> alla fine dei tuoi studi.")
    end
end

function SPAM.automem(matches)
    if SPAM.config.get("mem_helper") == false then
        send(matches[1])
        return
    end
    if matches[1] == "automem" then
        local available_slot = gmcp.Char.Magie.memorizzare.per_studio - gmcp.Char.Magie.memorizzare.in_studio
        if gmcp.Char.Vitals.stato ~= "Seduto" then
            send("siedi")
        end
        local current_mem = {}
        for _, v in pairs(gmcp.Char.Magie.memorizzazioni) do
            current_mem[v.nome] = {}
            current_mem[v.nome]["in_studio"] = v.in_studio
            current_mem[v.nome]["memorizzati"] = v.memorizzati
        end
        for k, v in pairs(SPAM.config.get("automem")) do
            local desired = v
            local prepared = 0
            local preparing = 0
            if current_mem[k] ~= nil then
                prepared = current_mem[k]["memorizzati"]
                preparing = current_mem[k]["in_studio"]
            end
            for i=1,(desired-prepared-preparing) do
                if available_slot < 1 then
                    break
                end
                send("memorizza " .. k)
                available_slot = available_slot -1
            end
        end
        return
    end
    local split = SPAM.string.explode(matches[1])
    if #split > 2 then
        -- the last word should be the desired number
        if split[#split]:match("^%-?%d+$") ~= nil then
            local desired = tonumber(split[#split])
            if desired > gmcp.Char.Magie.memorizzare.per_tipo  then
                desired = gmcp.Char.Magie.memorizzare.per_tipo
            end
            -- remove the first and last word
            table.remove(split)
            table.remove(split, 1)
            local cast_name = string.lower(SPAM.string.implode(split, " "))
            local refined_cast_name = SPAM.get_known_cast(cast_name)
            if refined_cast_name ~= nil then
                if desired == 0 then
                    cecho("<cyan>[AUTOMEM]<grey> ".. refined_cast_name .. " rimosso\n")
                    SPAM.config.get("automem")[refined_cast_name] = nil
                else
                    cecho("<cyan>[AUTOMEM]<grey> ".. refined_cast_name .. ": " .. desired .. "\n")
                    SPAM.config.get("automem")[refined_cast_name] = desired
                end
                SPAM.config.save_characters()
            elseif SPAM.config.get("automem")[cast_name] ~= nil then
                cecho("\n<red>ATTENZIONE: <grey>Rimuovo da automem cast non conosciuto: <white>" .. cast_name .. "\n")
                SPAM.config.get("automem")[cast_name] = nil
                SPAM.config.save_characters()
            else
                cecho("\n<red>ATTENZIONE: <grey>non conosci alcun cast: <white>" .. cast_name .. "\n")
            end
            return
        end
    elseif string.lower(split[2]) == "show" then
        cecho("<grey>Lista dei cast in <cyan>AUTOMEM<grey>:\n")
        display(SPAM.config.get("automem"))
        return
    end
    cecho([[Questo comando permette a uno stregone di memmare automaticamente una lista scelta di cast
Per settare un cast desiderato usare il comando: <yellow>automem nomecast numero
<grey>ad esempio: <yellow>automem missile mag 5
<grey>Per mostrare la lista dei cast desiderati usare il comando: <yellow>automem show
<grey>Per iniziare a memmare i cast desiderati usare il comando: <yellow>automem]])
end

function SPAM.update()
    uninstallPackage("@PKGNAME@")
    local git_url = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/build/SPAM.mpackage"
    if SPAM.config.get("dev") == true then
        git_url = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/dev/build/SPAM.mpackage"
    end
    installPackage(git_url)
end

function SPAM.file_exists(file_name)
    local f = io.open(file_name, "r")
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

function SPAM.compare_with_current_version(new_version)
    if new_version == "@VERSION@" then
        return false
    end
    v1_major, v1_minor, v1_patch = SPAM.parse_version(new_version)
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

function SPAM.event_handler(event, ...)
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

function SPAM.get_ally_name(name)
    local name = string.lower(name)
    if gmcp.Char.Gruppo.gruppo == nil then
        if SPAM.string.starts(string.lower(gmcp.Char.Name.name), name) then
            return gmcp.Char.Name.name
        end
        return
    end
    local gruppo = gmcp.Char.Gruppo.gruppo
    for i, v in ipairs(gruppo) do
        v.nome = SPAM.beautify_name(v.nome)
        if SPAM.string.starts(string.lower(v.nome), name) then
            return v.nome
        end
    end
    return nil
end

--remove articles or other unnecessary names from followers

function SPAM.beautify_name(name)
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
    words[1] = SPAM.string.first_upper(words[1])
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

function SPAM.make_pairs(input_table, array, _k)
    local k, v = next(input_table, _k)
    if k then
        table.insert(array, { k, v })
        return SPAM.make_pairs(input_table, array, k)
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
function SPAM.print_pairs(array, _i)
    local i = _i or 1
    local pair = array[i]
    if pair then
        local k, v = unpack(pair)
        if v > 0 then
            cecho("\n    <white>" .. k .. ': <grey>' .. os.date("%H:%M", v) .. " (" .. SPAM.disp_time(os.difftime(os.time(), v + 24 * 60 * 60)) .. ")")
            return SPAM.print_pairs(array, i + 1)
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
    SPAM.table.merge_class(old_class.buff.dps, new_class.buff.dps)
    SPAM.table.merge_class(old_class.buff.tank, new_class.buff.tank)
    SPAM.table.merge_class(old_class.buff.base, new_class.buff.base)
    SPAM.table.merge_class(old_class.self_buff.dps, new_class.self_buff.dps)
    SPAM.table.merge_class(old_class.self_buff.tank, new_class.self_buff.tank)
    SPAM.table.merge_class(old_class.self_buff.base, new_class.self_buff.base)
    if old_class.heal ~= nil then
        SPAM.table.merge_class(old_class.heal, new_class.heal)
    end
    if old_class.move ~= nil then
        SPAM.table.merge_class(old_class.move, new_class.move)
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

function SPAM.get_pf_color(current, max)
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

function SPAM.ob_role(name, test_role, check_name)
    local roles = SPAM.role_list()
    if check_name == true then
        allyName = SPAM.get_ally_name(name)
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

function SPAM.main_help(input_string)
    local help_string = [[
Questo è l'aiuto per SPAM (Seymour PAckage for Mudlet), un insieme
di alias, trigger e script per migliorare l'esperienza di gioco
in Dei Delle Ere.
]]
    if input_string == "" then
        checho(help_string)
        SPAM.config.show_all()
        checho(
                [[

Per avere maggiori informazioni su una impostazione usa: <yellow>spam nomeimpostazione<grey>
Ad esempio: <yellow>spam ddegroup <grey>oppure <yellow>spam gdcolor
          ]]
        )
    else
        local split = SPAM.string.explode(input_string)
        split[1] = input_string.lower(split[1])
        if #split == 1 then
            if split[1] == "update" then
                SPAM.update()
            else
                SPAM.config.show_desc(split[1])
            end
        else
            SPAM.config.set_by_name(split[1], SPAM.string.remove_first_word(input_string))
        end
    end
    send(" ")
end

function SPAM.show_glory_timer()
    send("gloria")
    if SPAM.config.get("glory") == false then
        return
    end
    local one_day_ago = os.time() - 24 * 60 * 60
    local printed_title = false
    for key, value in pairs(SPAM.config.get("glory_timer")) do
        if value > one_day_ago then
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
    SPAM.make_pairs(SPAM.config.get("glory_timer"), array)
    table.sort(array, greater)
    SPAM.print_pairs(array)
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
        roomtitle = SPAM.string.remove_last_numeric_char(roomtitle)
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

function SPAM.find_slot(name)
    --remove last word to prevent all items classified as armature
    local name_ex = SPAM.string.explode(name)
    table.remove(name_ex)
    name = SPAM.string.implode(name_ex, " ")
    for slot, name_list in pairs(SPAM.slots) do
        for i, v in ipairs(name_list) do
            if string.find(name, v) then
                return slot
            end
        end
    end
    return "da verificare"
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
    local weight_line = SPAM.string.explode(ident[1], " ")
    parsed["peso"] = weight_line[5]
    parsed["valore"] = weight_line[8]:gsub(",", "")
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
    --get type
    parsed["tipo"] = SPAM.find_slot(parsed["nome"])
    SPAM.debug(parsed)
    return parsed
end

function SPAM.ident_to_query(parsed)
    local data = { ["sql"] = "INSERT INTO tblident_temp (nome, peso, affitto, livello, ac, proprieta, affects, diffusione, informazioni, tipo, area, valore, danno_min, danno_max, danno_media,tipo_danno) VALUES('" .. SPAM.string.escape(parsed["nome"]) .. "', " .. SPAM.string.escape(parsed["peso"]) .. ", " .. SPAM.string.escape(parsed["affitto"]) .. ",  " .. SPAM.string.escape(parsed["livello"]) .. ", " .. SPAM.string.escape(parsed["ac"]) .. ", '" .. SPAM.string.escape(parsed["proprieta"]) .. "', '" .. SPAM.string.escape(parsed["affects"]) .. "', '" .. SPAM.string.escape(parsed["diffusione"]) .. "',  '" .. SPAM.string.escape(SPAM.character_name) .. "', '" .. parsed["tipo"] .. "', '', " .. SPAM.string.escape(parsed["valore"]) .. ", " .. SPAM.string.escape(parsed["danno_min"]) .. ", " .. SPAM.string.escape(parsed["danno_max"]) .. ", " .. SPAM.string.escape(parsed["danno_media"]) .. ",'" .. SPAM.string.escape(parsed["tipo_danno"]) .. "');" }
    SPAM.debug(data)
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

function SPAM.parse_eval(eval_text)
    -- parse eval if function is enabled
    if SPAM.config.get("parse_eval") == false then
        return
    end
    local eval = SPAM.string.explode(eval_text:gsub("\r", ""):gsub("\n\n", "\n"), "\n")
    local prop_w = {}
    prop_w["armi da taglio"] = 0
    prop_w["armi da punta"] = 0
    prop_w["armi da botta"] = 0
    local prop_m = {}
    prop_m[" magico"] = 0
    prop_m["non"] = 0
    local prop_b = {}
    prop_b["+1"] = 0
    prop_b["+2"] = 0
    prop_b["+3"] = 0
    prop_b["+4"] = 0
    prop_b["+5"] = 0
    prop_b["+6"] = 0
    local prop_c = {}
    prop_c["energia"] = 0
    prop_c["freddo"] = 0
    prop_c["fuoco"] = 0
    prop_c["acido"] = 0
    prop_c["veleno"] = 0
    prop_c["ombra"] = 0
    prop_c["luce"] = 0
    prop_c["sacro"] = 0
    local mod = {}
    mod["resistenza"] = -1
    mod["immune"] = -2
    mod["sensibile"] = 1

    local nome = ""

    for i, line in ipairs(eval) do
        if nome == "" then
            local split = SPAM.string.explode(line)
            for i,v in pairs(split) do
                if v == "appartiene" then
                    break
                end
                nome = nome .. v .. " "
            end
        end
        for mod_name, mod_val in pairs(mod) do
            if string.find(line, mod_name) then
                for prop_name,prop_val in pairs(prop_w) do
                    if string.find(line, prop_name) then
                        prop_w[prop_name] = prop_val + mod_val
                    end
                end

                for prop_name,prop_val in pairs(prop_m) do
                    if string.find(line, prop_name) then
                        prop_m[prop_name] = prop_val + mod_val
                    end
                end

                for prop_name,prop_val in pairs(prop_b) do
                    if string.find(line, prop_name) then
                        prop_b[prop_name] = prop_val + mod_val
                    end
                end

                for prop_name,prop_val in pairs(prop_c) do
                    if string.find(line, prop_name) then
                        prop_c[prop_name] = prop_val + mod_val
                    end
                end
            end
        end
    end

    local sortedKeys_w = {}
    for key in pairs(prop_w) do
        table.insert(sortedKeys_w, key)
    end
    table.sort(sortedKeys_w, function(a, b) return prop_w[a] > prop_w[b] end)

    local sortedKeys_b = {}
    for key in pairs(prop_b) do
        table.insert(sortedKeys_b, key)
    end
    table.sort(sortedKeys_b, function(a, b) return prop_b[a] > prop_b[b] end)

    local sortedKeys_c = {}
    for key in pairs(prop_c) do
        table.insert(sortedKeys_c, key)
    end
    table.sort(sortedKeys_c, function(a, b) return prop_c[a] > prop_c[b] end)

    local weapon_string

    if prop_w[sortedKeys_w[1]] == prop_w[sortedKeys_w[3]] then
        if prop_w[sortedKeys_w[1]] < 0 then
            weapon_string = "mani nude"
        else
            weapon_string = "tutte le armi"
        end
    elseif prop_w[sortedKeys_w[1]] == prop_w[sortedKeys_w[2]] then
        weapon_string =  sortedKeys_w[1] .. " o " .. sortedKeys_w[2]
    else
        weapon_string =  sortedKeys_w[1]
    end

    if prop_m[" magico"] == prop_m["non"] then
        if prop_m["non-magico"] == -2 then
            weapon_string = "immune alle armi"
           end
    elseif prop_m[" magico"] > prop_m["non"] then
        weapon_string = weapon_string .. " magiche"
    else
        weapon_string = weapon_string .. " non magiche"
    end

    if prop_b[sortedKeys_b[1]] == prop_b[sortedKeys_b[6]] then
        if prop_b[sortedKeys_b[1]] < 0 then
            weapon_string = weapon_string .. " senza bonus"
        end
    else
        local good_b = {}
        for i=1,6 do
            if prop_b[sortedKeys_b[i]] == prop_b[sortedKeys_b[1]] then
                table.insert(good_b,sortedKeys_b[i])
            end
        end
        table.sort(good_b)
        for _, v in pairs(good_b) do
            weapon_string = weapon_string .. " " .. v
           end
    end



    local cast_string = ""
    if prop_c[sortedKeys_c[1]] == prop_c[sortedKeys_c[8]] then
        if prop_b[sortedKeys_c[1]] ==-2 then
            cast_string = "nessuno"
        else
            cast_string = "qualsiasi"
        end
    else
        local good_c = {}
        for i=1,8 do
            if prop_c[sortedKeys_c[i]] == prop_c[sortedKeys_c[1]] then
                table.insert(good_c,sortedKeys_c[i])
            end
        end
        table.sort(good_c)
        for _, v in pairs(good_c) do
            cast_string = cast_string .. v .. " "
        end
    end

    if gmcp.Char.Gruppo == nil or gmcp.Char.Gruppo.gruppo == nil then
        cecho("\n\n<white>Arma per <red>" .. nome .. "<white>" .. weapon_string)
        cecho("\n<white>Elementi per <red>" .. nome .. "<white>" .. cast_string .. "\n")
    else
        send("gd &WArma per &R" .. nome .. "&W" .. weapon_string)
        send("gd &WElementi per &R" .. nome .. "&W" .. cast_string)
    end
end

function SPAM.debug(var)
    if SPAM.config.get("debug") == true then
        cecho("\n<red>DEBUG PRINT:\n")
        display(var)
    end
end

function SPAM.config.save_globals()
    table.save(SPAM.config.globals_savelocation, SPAM.config.persistent_globals)
    SPAM.toggle_dde_group()
    SPAM.toggle_abbil_chat()
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
    SPAM.toggle_mem_helper()
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
        checho("\nLa configurazione del personaggio <white>" .. SPAM.character_name .. "<grey> è:\n")
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
