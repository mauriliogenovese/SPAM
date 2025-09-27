function gmcp_loop()
    -- incomplete login
    if
    gmcp.Char.Vitals == nil or
            gmcp.Char.Magie == nil or
            gmcp.Char.Name == nil or
            gmcp.Char.Classi.classi == nil
    then
        return
    end
    --character loading
    if SPAM.character_name ~= gmcp.Char.Name.name then
        SPAM.character_name = gmcp.Char.Name.name
        SPAM.config.load_character(SPAM.character_name)
        SPAM.observe_spell_list = nil
        SPAM.last_autocast = os.time()
        -- gmcp.Char.Classi.classi = nil

        -- at character loading save exp for day counter
        if SPAM.config.get("glory_today")["date"] == nil or
         SPAM.config.get("glory_today")["date"] ~= os.date("%Y%m%d") or
         SPAM.config.get("glory_today")["base_exp"]  == nil or
         SPAM.config.get("glory_today")["total"]  == nil then
            SPAM.config.get("glory_today")["date"]  = os.date("%Y%m%d")
            SPAM.config.get("glory_today")["base_exp"]  = SPAM.current_exp()
            SPAM.config.get("glory_today")["total"]  = 0
            SPAM.config.save_characters()
        end

        SPAM.init_abbil_chat()
        SPAM.init_dde_group()
        SPAM.init_mem_helper()
        loadWindowLayout()

        -- return NEEDED to refresh classes
        return
    end
    -- party observer
    if SPAM.config.get("dde_group") then
        clearWindow("DdE Group")
        local gruppo = {}
        SPAM.party_fight_check()
        if SPAM.last_command ~= command then
            SPAM.last_command = command
            SPAM.last_command_time = os.time()
        end

        if gmcp.Char.Gruppo == nil or gmcp.Char.Gruppo.gruppo == nil then
            --if not in group, create a similar structure to show player info
            gruppo[1] = {}
            gruppo[1].nome = gmcp.Char.Name.name
            gruppo[1].hp = math.floor(100 * gmcp.Char.Vitals.hp / gmcp.Char.Vitals.maxhp)
            gruppo[1].move = math.floor(100 * gmcp.Char.Vitals.move / gmcp.Char.Vitals.maxmove)
            gruppo[1].incantesimi = {}
        else
            gruppo = gmcp.Char.Gruppo.gruppo
        end
        --generate the observable spell list
        if SPAM.observe_spell_list == nil then
            SPAM.gen_spell_list(gmcp.Char.Classi.classi)
            SPAM.toggle_mem_helper()
        end
        --if not otherwise specifies, i'm always in base observe mode
        if SPAM.config.get("observe_list")[SPAM.character_name] == nil then
            SPAM.config.get("observe_list")[SPAM.character_name] = "base"
            SPAM.config.save_characters()
        end
        --group loop
        local party_names = {}
        for i, v in ipairs(gruppo) do
            local this_name = SPAM.beautify_name(v.nome)
            local name_x = 2
            while party_names[this_name] ~= nil do
                if name_x > 2 then
                    this_name = string.gsub(this_name, (name_x - 1) .. ".", "")
                end
                this_name = name_x .. "." .. this_name
                name_x = name_x + 1
            end
            party_names[this_name] = true
            SPAM.dde_group_window:decho("\n")
            local ob_func_list = {}
            local ob_name_list = SPAM.role_list()
            table.foreach(
                    ob_name_list,
                    function(k1, v1)
                        table.insert(
                                ob_func_list,
                                [[SPAM.ob_role("]] .. this_name .. [[", "]] .. v1 .. [[", false)]]
                        )
                    end
            )
            SPAM.dde_group_window:hechoPopup(this_name, ob_func_list, ob_name_list, true)
            SPAM.dde_group_window:decho("(")
            local this_hp = tonumber(v.hp)
            local row = "#" .. SPAM.get_pf_color(this_hp, 100) .. this_hp
            --if player can cast heal spells, add them as link
            if next(SPAM.observe_spell_list.heal) ~= nil then
                local heal_func_list = {}
                table.foreach(
                        SPAM.observe_spell_list.heal,
                        function(k1, v1)
                            table.insert(
                                    heal_func_list,
                                    [[send(SPAM.observe_spell_list.command .. " ']] .. v1 .. [[' ]] .. this_name .. [[")]]
                            )
                        end
                )
                SPAM.dde_group_window:hechoPopup(row, heal_func_list, SPAM.observe_spell_list.heal, true)
            else
                SPAM.dde_group_window:hecho(row)
            end
            SPAM.dde_group_window:decho("<200,200,200>")
            local this_move = tonumber(v.move)
            if this_move <= 20 then
                row = ", <red>" .. this_move
                if next(SPAM.observe_spell_list.move) ~= nil then
                    local move_func_list = {}
                    table.foreach(
                            SPAM.observe_spell_list.move,
                            function(k1, v1)
                                table.insert(
                                        move_func_list,
                                        [[send(SPAM.observe_spell_list.command .. " ']] .. v1 .. [[' ]] .. this_name .. [[")]]
                                )
                            end
                    )
                    SPAM.dde_group_window:cechoPopup(row, move_func_list, SPAM.observe_spell_list.move, true)
                else
                    SPAM.dde_group_window:cecho(row)
                end
            end
            SPAM.dde_group_window:decho(")")
            --generate spell to check for the current group member
            if SPAM.config.get("observe_list")[this_name] ~= nil then
                local observe_spell = {}
                SPAM.table.merge(SPAM.observe_spell_list.buff.base, observe_spell)
                if this_name == SPAM.character_name then
                    SPAM.table.merge(SPAM.observe_spell_list.self_buff.base, observe_spell)
                    SPAM.table.merge(SPAM.table.get_keys(SPAM.config.get("custom_refresh")), observe_spell)
                end
                if string.find(SPAM.config.get("observe_list")[this_name], "tank") then
                    SPAM.table.merge(SPAM.observe_spell_list.buff.tank, observe_spell)
                    if this_name == SPAM.character_name then
                        SPAM.table.merge(SPAM.observe_spell_list.self_buff.tank, observe_spell)
                    end
                end
                if string.find(SPAM.config.get("observe_list")[this_name], "dps") then
                    SPAM.table.merge(SPAM.observe_spell_list.buff.dps, observe_spell)
                    if this_name == SPAM.character_name then
                        SPAM.table.merge(SPAM.observe_spell_list.self_buff.dps, observe_spell)
                    end
                end
                if SPAM.config.get("optional_buff")[this_name] ~= nil then
                    for key, val in pairs(SPAM.config.get("optional_buff")[this_name]) do
                        if val == true then
                            table.insert(observe_spell, key)
                        end
                    end
                end
                SPAM.table.deduplicate(observe_spell)
                local spells = nil
                spells = v.incantesimi
                -- for me, check property (from items) other than cast
                if this_name == SPAM.character_name and gmcp.Char.Magie.proprieta ~= nil then
                    for i, v in ipairs(gmcp.Char.Magie.proprieta) do
                        table.insert(spells, v.nome)
                    end
                end
             if this_name == SPAM.character_name and gmcp.Char.Magie.incantesimi ~= nil then
                    for i, v in ipairs(gmcp.Char.Magie.incantesimi) do
                        table.insert(spells, v.nome)
                    end
                end
                if spells ~= nil then
                    local active = nil
                    active = {}
                    for n = 1, #spells do
                        active[spells[n]] = true
                    end
                    --races with implicit fly spell
                    if
                    v.razza == "efreet" or
                            v.razza == "gigante delle nuvole" or
                            v.razza == "gigante delle tempeste" or
                            this_name == "Vampiro" or
                            this_name == "Wraith" or
                            this_name == "Spettro" or
                            this_name == "Banshee" or
                            this_name == "Pipistrello" or
                            this_name == "Corvo" or
                            this_name == "Aquila" or
                            this_name == "Pterodattilo" or
                            this_name == "Orsogufo"
                    then
                        active["volo"] = true
                    end
                    --races with implicit fireshield spell
                    if v.razza == "efreet" or v.razza == "azer" then
                        active["scudo infuocato"] = true
                    end
                    --spell overrides
                    if active["volo di gruppo"] or active["fly"] then
                        active["volo"] = true
                    end
                    if active["aura sacra"] or active["i guerrieri del cielo"] then
                        --TODO gestione della sant del bardo: i guerrieri del cielo
                        active["santificazione"] = true
                    end
                    if active["volo"] then
                        active["levitazione"] = true
                    end
                    if active["protezione dalla luce"] or active["protezione dalla oscurita"] or active["protezione da equilibrio"] then
                        active["protezione dalla oscurita"] = true
                        active["protezione dalla luce"] = true
                        active["protezione da equilibrio"] = true
                    end
                    if active["individuazione luce"] or active["individuazione oscurita"] or active["individuazione equilibrio"] then
                        active["individuazione oscurita"] = true
                        active["individuazione luce"] = true
                        active["individuazione equilibrio"] = true
                    end
                    local active_observed = {}
                    for a, b in ipairs(observe_spell) do
                        if not active[b] then
                            --check per autocast
                            if
                            this_name == SPAM.character_name and
                                    SPAM.config.get("autocast") and
                                    SPAM.config.get("custom_refresh")[b] == nil and
                                    SPAM.can_autocast(b) then
                                SPAM.last_autocast = os.time()
                                send(SPAM.observe_spell_list.command .. " '" .. b .. "' " .. this_name)

                            end
                            SPAM.dde_group_window:decho(" - ")
                            SPAM.dde_group_window:dechoLink(
                                    b,
                                    [[
                                      if SPAM.config.get("custom_refresh")["]] .. b .. [["] == nil then
                                        send(SPAM.observe_spell_list.command .. " ']] .. b .. [[' ]] .. this_name .. [[")
                  else
                    sendAll(unpack(SPAM.config.get("custom_refresh")["]] .. b .. [["]))
                  end
                ]],
                                    "Casta " .. b,
                                    true
                            )
                        else
                            active_observed[b] = true
                        end
                    end
                    if gmcp.Char.Magie.incantesimi ~= nil and this_name == SPAM.character_name then
                        for a, b in ipairs(gmcp.Char.Magie.incantesimi) do
                            if active_observed[b.nome] and b.durata < 20 then
                                local color_tag = "<255,0,0>"
                                if b.durata > 10 then
                                    color_tag = "<255,255,0>"
                                end
                                if b.nome == "volo" or b.nome == "branchie" or b.nome == "levitazione" then
                                    SPAM.dde_group_window:dechoLink(
                                            " - " .. color_tag .. b.nome .. "<200,200,200>",
                                            [[send(SPAM.observe_spell_list.command .. " ']] .. b.nome .. [[' ]] .. this_name .. [[")]],
                                            "Casta " .. b.nome,
                                            true
                                    )
                                else
                                    SPAM.dde_group_window:decho(" - " .. color_tag .. b.nome .. "<200,200,200>")
                                end
                            end
                        end
                    end
                end
            end
            SPAM.dde_group_window:decho("\n")
            observe_spell = nil
            active_observed = nil
        end
    end
    if SPAM.is_class("stregone") and SPAM.config.get("mem_helper") then
        SPAM.print_mem()
    end
end