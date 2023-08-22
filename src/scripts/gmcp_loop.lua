function gmcp_loop()
  --incomplete login
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
    initialize_persistent_var(SPAM.character_name)
    SPAM.observe_spell_list = nil
    --first character login
    local save_var = false
    if SPAM.persistent_variables[SPAM.character_name]["observe_list"] == nil then
      SPAM.persistent_variables[SPAM.character_name]["observe_list"] = {}
      save_var = true
    end
    if SPAM.persistent_variables[SPAM.character_name]["optional_buff"] == nil then
      SPAM.persistent_variables[SPAM.character_name]["optional_buff"] = {}
      save_var = true
    end
    if SPAM.persistent_variables[SPAM.character_name]["gd_start"] == nil then
      SPAM.persistent_variables[SPAM.character_name]["gd_start"] = ""
      save_var = true
    end
    if SPAM.persistent_variables[SPAM.character_name]["gd_end"] == nil then
      SPAM.persistent_variables[SPAM.character_name]["gd_end"] = ""
      save_var = true
    end
    if SPAM.persistent_variables[SPAM.character_name]["glory_timer"] == nil then
      SPAM.persistent_variables[SPAM.character_name]["glory_timer"] = {}
      save_var = true
    end
    if save_var == true then
      save_persistent_var(SPAM.character_name)
    end
    --return needed to refresh classes
    gmcp.Char.Classi.classi = nil
    --mod_generic_mapper()
    return
  end
  --party observer
  if SPAM.persistent_variables["config"]["dde_group"] == true then
    clearWindow("DdE Group")
    local gruppo = {}
    if gmcp.Char.Gruppo == nil or gmcp.Char.Gruppo.gruppo == nil then
      --if not in group, create a similar structure to show player info
      gruppo[1] = {}
      gruppo[1].nome = gmcp.Char.Name.name
      gruppo[1].hp = math.floor(100 * gmcp.Char.Vitals.hp / gmcp.Char.Vitals.maxhp)
      gruppo[1].move = math.floor(100 * gmcp.Char.Vitals.move / gmcp.Char.Vitals.maxmove)
      gruppo[1].incantesimi = {}
      if gmcp.Char.Magie.incantesimi ~= nil then
        for i, v in ipairs(gmcp.Char.Magie.incantesimi) do
          table.insert(gruppo[1].incantesimi, v.nome)
        end
      end
    else
      gruppo = gmcp.Char.Gruppo.gruppo
    end
    --generate the observable spell list
    if SPAM.observe_spell_list == nil then
      gen_spell_list(gmcp.Char.Classi.classi)
    end
    --generate the SPAM.persistent_variables[SPAM.character_name]["optional_buff"] entry for current character, if missing
    if SPAM.persistent_variables[SPAM.character_name]["optional_buff"] == nil then
      SPAM.persistent_variables[SPAM.character_name]["optional_buff"] = {}
    end
    --generate the SPAM.persistent_variables[SPAM.character_name]["custom_refresh"] entry for current character, if missing
    if SPAM.persistent_variables[SPAM.character_name]["custom_refresh"] == nil then
      SPAM.persistent_variables[SPAM.character_name]["custom_refresh"] = {}
    end
    --if not otherwise specifies, i'm always in base observe mode
    if SPAM.persistent_variables[SPAM.character_name]["observe_list"][SPAM.character_name] == nil then
      SPAM.persistent_variables[SPAM.character_name]["observe_list"][SPAM.character_name] = "base"
    end
    --group loop
    local party_names = {}
    for i, v in ipairs(gruppo) do
      local this_name = beautifyName(v.nome)
      local name_x = 2
      while party_names[this_name] ~= nil do
        if name_x > 2 then
          this_name = string.gsub(this_name, (name_x - 1) .. ".", "")
        end
        this_name = name_x .. "." .. this_name
        name_x = name_x + 1
      end
      party_names[this_name] = true
      SPAM.ddeGroupWidget:decho("\n")
      local ob_func_list = {}
      local ob_name_list = role_list()
      table.foreach(
        ob_name_list,
        function(k1, v1)
          table.insert(
            ob_func_list,
            function()
              ob_role(this_name, v1, false)
            end
          )
        end
      )
      SPAM.ddeGroupWidget:hechoPopup(this_name, ob_func_list, ob_name_list, true)
      SPAM.ddeGroupWidget:decho("(")
      local this_hp = tonumber(v.hp)
      local row = "#" .. getPFcolor(this_hp, 100) .. this_hp
      --if player can cast heal spells, add them as link
      if next(SPAM.observe_spell_list.heal) ~= nil then
        local heal_func_list = {}
        table.foreach(
          SPAM.observe_spell_list.heal,
          function(k1, v1)
            table.insert(
              heal_func_list,
              function()
                send(SPAM.observe_spell_list.command .. " '" .. v1 .. "' " .. this_name)
              end
            )
          end
        )
        SPAM.ddeGroupWidget:hechoPopup(row, heal_func_list, SPAM.observe_spell_list.heal, true)
      else
        SPAM.ddeGroupWidget:hecho(row)
      end
      SPAM.ddeGroupWidget:decho("<200,200,200>")
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
                function()
                  send(SPAM.observe_spell_list.command .. " '" .. v1 .. "' " .. this_name)
                end
              )
            end
          )
          SPAM.ddeGroupWidget:cechoPopup(row, move_func_list, SPAM.observe_spell_list.move, true)
        else
          SPAM.ddeGroupWidget:cecho(row)
        end
      end
      SPAM.ddeGroupWidget:decho(")")
      --generate spell to check for the current group member
      if SPAM.persistent_variables[SPAM.character_name]["observe_list"][this_name] ~= nil then
        local observe_spell = {}
        merge_tables(SPAM.observe_spell_list.buff.base, observe_spell)
        if this_name == SPAM.character_name then
          merge_tables(SPAM.observe_spell_list.self_buff.base, observe_spell)
          merge_tables(getTableKeys(SPAM.persistent_variables[SPAM.character_name]["custom_refresh"]), observe_spell)
        end
        if string.find(SPAM.persistent_variables[SPAM.character_name]["observe_list"][this_name], "tank") then
          merge_tables(SPAM.observe_spell_list.buff.tank, observe_spell)
          if this_name == SPAM.character_name then
            merge_tables(SPAM.observe_spell_list.self_buff.tank, observe_spell)
          end
        end
        if string.find(SPAM.persistent_variables[SPAM.character_name]["observe_list"][this_name], "dps") then
          merge_tables(SPAM.observe_spell_list.buff.dps, observe_spell)
          if this_name == SPAM.character_name then
            merge_tables(SPAM.observe_spell_list.self_buff.dps, observe_spell)
          end
        end
        if SPAM.persistent_variables[SPAM.character_name]["optional_buff"][this_name] ~= nil then
          for key, val in pairs(SPAM.persistent_variables[SPAM.character_name]["optional_buff"][this_name]) do
            if val == true then
              table.insert(observe_spell, key)
            end
          end
        end
        deduplicate(observe_spell)
        local spells = nil
        spells = v.incantesimi
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
            v.razza == "gigante delle tempeste"
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
          if active["protezione dal bene"] then
            active["protezione dal male"] = true
          end
          if active["protezione dal male"] then
            active["protezione dal bene"] = true
          end
          local active_observed = {}
          for a, b in ipairs(observe_spell) do
            if not active[b] then
              SPAM.ddeGroupWidget:decho(" - ")
              SPAM.ddeGroupWidget:dechoLink(
                b,
                function()
                  if SPAM.persistent_variables[SPAM.character_name]["custom_refresh"][b] == nil then
                    send(SPAM.observe_spell_list.command .. " '" .. b .. "' " .. this_name)
                  else
                    sendAll(unpack(SPAM.persistent_variables[SPAM.character_name]["custom_refresh"][b]))
                  end
                end,
                "Casta " .. b,
                true
              )
            else
              active_observed[b] = true
            end
          end
          if gmcp.Char.Magie.incantesimi ~= nil and this_name == SPAM.character_name then
            for a, b in ipairs(gmcp.Char.Magie.incantesimi) do
              if active_observed[b.nome] == true and b.durata < 20 then
                local color_tag = "<255,0,0>"
                if b.durata > 10 then
                  color_tag = "<255,255,0>"
                end
                if b.nome == "volo" or b.nome == "branchie" or b.nome == "levitazione" then
                  SPAM.ddeGroupWidget:dechoLink(
                    " - " .. color_tag .. b.nome .. "<200,200,200>",
                    function()
                      send(SPAM.observe_spell_list.command .. " '" .. b.nome .. "' " .. this_name)
                    end,
                    "Casta " .. b.nome,
                    true
                  )
                else
                  SPAM.ddeGroupWidget:decho(" - " .. color_tag .. b.nome .. "<200,200,200>")
                end
              end
            end
          end
        end
      end
      SPAM.ddeGroupWidget:decho("\n")
      observe_spell = nil
      active_observed = nil
    end
  end
end