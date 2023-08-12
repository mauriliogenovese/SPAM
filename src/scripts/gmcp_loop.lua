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
  if character_name ~= gmcp.Char.Name.name then
    character_name = gmcp.Char.Name.name
    initialize_persistent_var(character_name)
    observe_spell_list = nil
    --first character login
    local save_var = false
    if persistent_variables[character_name]["observe_list"] == nil then
      persistent_variables[character_name]["observe_list"] = {}
      save_var = true
    end
    if persistent_variables[character_name]["optional_buff"] == nil then
      persistent_variables[character_name]["optional_buff"] = {}
      save_var = true
    end
    if persistent_variables[character_name]["gd_start"] == nil then
      persistent_variables[character_name]["gd_start"] = ""
      save_var = true
    end
    if persistent_variables[character_name]["gd_end"] == nil then
      persistent_variables[character_name]["gd_end"] = ""
      save_var = true
    end
    if persistent_variables[character_name]["glory_timer"] == nil then
      persistent_variables[character_name]["glory_timer"] = {}
      save_var = true
    end
    if save_var == true then
      save_persistent_var(character_name)
    end
    --return needed to refresh classes
    gmcp.Char.Classi.classi = nil
    return
  end
  --party observer
  if persistent_variables["config"]["dde_group"] == true then
    clearWindow("DdE Group")
    if gmcp.Char.Gruppo == nil or gmcp.Char.Gruppo.gruppo == nil then
      --if not in group, create a similar structure to show player info
      gruppo = {}
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
    if observe_spell_list == nil then
      gen_spell_list(gmcp.Char.Classi.classi)
    end
    --generate the persistent_variables[character_name]["optional_buff"] entry for current character, if missing
    if persistent_variables[character_name]["optional_buff"] == nil then
      persistent_variables[character_name]["optional_buff"] = {}
    end
    --if not otherwise specifies, i'm always in base observe mode
    if persistent_variables[character_name]["observe_list"][character_name] == nil then
      persistent_variables[character_name]["observe_list"][character_name] = "base"
    end
    --group loop
    party_names = {}
    for i, v in ipairs(gruppo) do
      local this_name = beautifyName(v.nome)
      name_x = 2
      while party_names[this_name] ~= nil do
        if name_x > 2 then
          this_name = string.gsub(this_name, (name_x - 1) .. ".", "")
        end
        this_name = name_x .. "." .. this_name
        name_x = name_x + 1
      end
      party_names[this_name] = true
      ddeGroupWidget:decho("\n")
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
      ddeGroupWidget:hechoPopup(this_name, ob_func_list, ob_name_list, true)
      ddeGroupWidget:decho("(")
      this_hp = tonumber(v.hp)
      row = "#" .. getPFcolor(this_hp, 100) .. this_hp
      --if player can cast heal spells, add them as link
      if next(observe_spell_list.heal) ~= nil then
        heal_func_list = {}
        table.foreach(
          observe_spell_list.heal,
          function(k1, v1)
            table.insert(
              heal_func_list,
              function()
                send(observe_spell_list.command .. " '" .. v1 .. "' " .. this_name)
              end
            )
          end
        )
        ddeGroupWidget:hechoPopup(row, heal_func_list, observe_spell_list.heal, true)
      else
        ddeGroupWidget:hecho(row)
      end
      ddeGroupWidget:decho("<200,200,200>")
      this_move = tonumber(v.move)
      if this_move <= 20 then
        row = ", <red>" .. this_move
        if next(observe_spell_list.move) ~= nil then
          move_func_list = {}
          table.foreach(
            observe_spell_list.move,
            function(k1, v1)
              table.insert(
                move_func_list,
                function()
                  send(observe_spell_list.command .. " '" .. v1 .. "' " .. this_name)
                end
              )
            end
          )
          ddeGroupWidget:cechoPopup(row, move_func_list, observe_spell_list.move, true)
        else
          ddeGroupWidget:cecho(row)
        end
      end
      ddeGroupWidget:decho(")")
      --generate spell to check for the current group member
      if persistent_variables[character_name]["observe_list"][this_name] ~= nil then
        observe_spell = {}
        merge_tables(observe_spell_list.buff.base, observe_spell)
        if this_name == character_name then
          merge_tables(observe_spell_list.self_buff.base, observe_spell)
        end
        if string.find(persistent_variables[character_name]["observe_list"][this_name], "tank") then
          merge_tables(observe_spell_list.buff.tank, observe_spell)
          if this_name == character_name then
            merge_tables(observe_spell_list.self_buff.tank, observe_spell)
          end
        end
        if string.find(persistent_variables[character_name]["observe_list"][this_name], "dps") then
          merge_tables(observe_spell_list.buff.dps, observe_spell)
          if this_name == character_name then
            merge_tables(observe_spell_list.self_buff.dps, observe_spell)
          end
        end
        if persistent_variables[character_name]["optional_buff"][this_name] ~= nil then
          for key, val in pairs(persistent_variables[character_name]["optional_buff"][this_name]) do
            if val == true then
              table.insert(observe_spell, key)
            end
          end
        end
        deduplicate(observe_spell)
        spells = nil
        spells = v.incantesimi
        if spells ~= nil then
          active = nil
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
          active_observed = {}
          for a, b in ipairs(observe_spell) do
            if not active[b] then
              ddeGroupWidget:decho(" - ")
              ddeGroupWidget:dechoLink(
                b,
                function()
                  send(observe_spell_list.command .. " '" .. b .. "' " .. this_name)
                end,
                "Casta " .. b,
                true
              )
            else
              active_observed[b] = true
            end
          end
          if gmcp.Char.Magie.incantesimi ~= nil and this_name == character_name then
            for a, b in ipairs(gmcp.Char.Magie.incantesimi) do
              if active_observed[b.nome] == true and b.durata < 20 then
                if b.durata > 10 then
                  color_tag = "<255,255,0>"
                else
                  color_tag = "<255,0,0>"
                end
                if b.nome == "volo" or b.nome == "branchie" or b.nome == "levitazione" then
                  ddeGroupWidget:dechoLink(
                    " - " .. color_tag .. b.nome .. "<200,200,200>",
                    function()
                      send(observe_spell_list.command .. " '" .. b.nome .. "' " .. this_name)
                    end,
                    "Casta " .. b.nome,
                    true
                  )
                else
                  ddeGroupWidget:decho(" - " .. color_tag .. b.nome .. "<200,200,200>")
                end
              end
            end
          end
        end
      end
      ddeGroupWidget:decho("\n")
      observe_spell = nil
      active_observed = nil
    end
    --delete_table(gruppo)
  end
end