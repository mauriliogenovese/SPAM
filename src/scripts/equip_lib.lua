-- Script_Generici/spam_extension.lua
-- Estensione generica del pacchetto SPAM per la gestione equip/set/resy/slay

SPAM = SPAM or {}

------------------------------------------------
-- Helper: limita alias a un singolo PG
-- Uso tipico negli alias:
--   if not SPAM.only_for("Uryel") then return end
------------------------------------------------
function SPAM.only_for(charname)
  if SPAM.character_name ~= charname then
    return false
  end
  return true
end

------------------------------------------------
-- Comandi di equip di default per slot speciali
-- - "impugnato" usa "impugna"
-- - tutto il resto usa:
--     "indoss"  in equip_from_bank (banca)
--     "ind"     in switch_set_from_bag (contenitore)
------------------------------------------------
SPAM.defaultEquipCmdBySlot = {
  ["impugnato"] = "impugna",
}

------------------------------------------------
-- Costruttore generico di item per *_items.lua
--
-- Esempi:
--   SPAM.item{
--     name = "il globo del potere",
--     key  = "globo-potere",
--     slot = "luce",
--   }
--
--   -- item dps:
--   SPAM.item{
--     name = "Il Changshan di Gauze di Maestro Shifu",
--     key  = "changshan",
--     slot = "corpo",
--     sets = "dps",
--   }
--
--   -- item tank:
--   SPAM.item{
--     name = "Il Baojia d'Avorio del Tempio di Song",
--     key  = "baojia",
--     slot = "corpo",
--     sets = "tank",
--   }
--
--   -- item resistenza fuoco (overlay):
--   SPAM.item{
--     name = "una corazza del fuoco",
--     key  = "corazza-fuoco",
--     slot = "corpo",
--     resy = "fire",
--   }
--
--   -- item slay demoni (overlay):
--   SPAM.item{
--     name = "un globo purificatore",
--     key  = "globo-purificatore",
--     slot = "afferrato",
--     slay = "demon",
--   }
------------------------------------------------
function SPAM.item(def)
  if type(def) ~= "table" then
    error("SPAM.item: argomento deve essere una tabella")
  end

  if not def.name or not def.key or not def.slot then
    error("SPAM.item: 'name', 'key' e 'slot' sono obbligatori")
  end

  local t = {
    name      = def.name,
    key       = def.key,
    slot      = def.slot,
    spellFail = def.spellFail or false,
    held      = def.held or false,
    -- overlay resistenze (fire/ice/acid/venom...)
    resy      = def.resy,
    -- overlay slay (demon/drake/...)
    slay      = def.slay,
  }

  -- Normalizzazione dei set in una mappa { tag = true, ... }
  -- Qui metti SOLO dps/tank/main/altro, NON resy/slay.
  local setsMap = {}

  if def.sets == nil then
    -- default: appartiene al set "main"
    setsMap.main = true

  elseif type(def.sets) == "string" then
    setsMap[def.sets] = true

  elseif type(def.sets) == "table" then
    local isArray = (#def.sets > 0)
    if isArray then
      for _, tag in ipairs(def.sets) do
        setsMap[tag] = true
      end
    else
      for k, v in pairs(def.sets) do
        if v then setsMap[k] = true end
      end
    end
  else
    setsMap.main = true
  end

  t.sets = setsMap

  return t
end

------------------------------------------------
-- Ritorna la *key* dell'oggetto indossato in uno slot.
--
-- Usa:
--   - SPAM.get_equip_slot(slot)      per leggere il NOME attuale nello slot
--   - charTable.itemkeyByName[name]  per mappare NOME → KEY
--
-- Se lo slot è vuoto o il nome non è mappato, ritorna nil.
-- Se esiste il nome ma non è in itemkeyByName, per compatibilità
-- ritorna il nome così com'è (potrebbe già essere una key).
------------------------------------------------
function SPAM.get_key_in_slot(charname, slot)
  local charTable = SPAM[charname]
  if not charTable then
    return nil
  end

  local itemkeyByName = charTable.itemkeyByName or {}
  if type(SPAM.get_equip_slot) ~= "function" then
    return nil
  end

  local name = SPAM.get_equip_slot(slot)  -- NOME in quello slot
  if not name or SPAM.is_empty_name(name) then
    return nil
  end

  -- se lo conosco, restituisco la key; altrimenti provo a usare il valore così com'è
  return itemkeyByName[name] or name
end

------------------------------------------------
-- Helper generico: costruisce gli indici per una tabella PG
-- charTable è qualcosa tipo SPAM.Uryel / SPAM.Alendil / SPAM.Valagar
-- e deve contenere almeno .items = { ... }
--
-- Crea:
--  - charTable.byName[name]        -> { items... }
--  - charTable.byKey[key]          -> { items... }
--  - charTable.bySet[tag]          -> { items... } (dps, tank, main, ecc.)
--  - charTable.resyByType[type]    -> { items... } (fire, ice, acid, venom...)
--  - charTable.resyKeySet[key]     -> true/false (se la key appartiene a un item resy)
--  - charTable.slayByType[type]    -> { items... } (demon, drake...)
--  - charTable.slayKeySet[key]     -> true/false (se la key appartiene a un item slay)
--  - charTable.spellfail           -> { items... }
--  - charTable.heldKeys[key]       -> true/false
--  - charTable.itemkeyByName[name] -> key (compat con vecchio itemkey[name])
------------------------------------------------
function SPAM.build_item_indexes(charTable)
  if not charTable then
    return
  end

  local items = charTable.items or {}

  charTable.byName        = {}
  charTable.byKey         = {}
  charTable.bySet         = {}
  charTable.resyByType    = {}
  charTable.resyKeySet    = {}
  charTable.slayByType    = {}
  charTable.slayKeySet    = {}
  charTable.spellfail     = {}
  charTable.heldKeys      = {}
  charTable.itemkeyByName = {}

  local resyKeySet = charTable.resyKeySet
  local slayKeySet = charTable.slayKeySet

  for _, it in ipairs(items) do
    ------------------------------------------------
    -- byName + compat itemkey[name] -> key
    ------------------------------------------------
    if it.name then
      charTable.byName[it.name] = charTable.byName[it.name] or {}
      table.insert(charTable.byName[it.name], it)

      if it.key then
        charTable.itemkeyByName[it.name] = it.key
      end
    end

    ------------------------------------------------
    -- byKey
    ------------------------------------------------
    if it.key then
      charTable.byKey[it.key] = charTable.byKey[it.key] or {}
      table.insert(charTable.byKey[it.key], it)
    end

    ------------------------------------------------
    -- bySet (dps, tank, main, ecc.)
    ------------------------------------------------
    if it.sets then
      for tag, ok in pairs(it.sets) do
        if ok then
          charTable.bySet[tag] = charTable.bySet[tag] or {}
          table.insert(charTable.bySet[tag], it)
        end
      end
    end

    ------------------------------------------------
    -- resyByType (fire, ice, acid, venom) + resyKeySet
    -- Usiamo SOLO il campo it.resy per le resistenze.
    ------------------------------------------------
    if it.resy and it.key then
      charTable.resyByType[it.resy] = charTable.resyByType[it.resy] or {}
      table.insert(charTable.resyByType[it.resy], it)
      resyKeySet[it.key] = true
    end

    ------------------------------------------------
    -- slayByType (demon, drake...) + slayKeySet
    -- Usiamo SOLO il campo it.slay per le slay.
    ------------------------------------------------
    if it.slay and it.key then
      charTable.slayByType[it.slay] = charTable.slayByType[it.slay] or {}
      table.insert(charTable.slayByType[it.slay], it)
      slayKeySet[it.key] = true
    end

    ------------------------------------------------
    -- spellfail list (oggetti che fanno fallire incantesimi)
    ------------------------------------------------
    if it.spellFail then
      table.insert(charTable.spellfail, it)
    end

    ------------------------------------------------
    -- held keys (oggetti da NON depositare/Non mettere nel contenitore)
    ------------------------------------------------
    if it.held and it.key then
      charTable.heldKeys[it.key] = true
    end
  end
end

------------------------------------------------
-- Helper: considera “vuoto” nil, "", "null", "nil", "none",
--          "-", "(empty)", "(vuoto)"
------------------------------------------------
function SPAM.is_empty_name(x)
  if x == nil then return true end
  local s = tostring(x):match("^%s*(.-)%s*$")
  local l = s:lower()
  return s == "" or l == "null" or l == "nil" or l == "none" or l == "n/a"
         or l == "-" or l == "(empty)" or l == "(vuoto)"
end

------------------------------------------------
-- Controllo generico: possiamo cambiare equip?
-- Blocca se c'è lag o comandi in coda.
-- Ritorna:
--   true
--   false, "messaggio"
------------------------------------------------
function SPAM.can_change_equip()
  local vit  = gmcp.Char and gmcp.Char.Vitals or {}
  local coda = gmcp.Char and gmcp.Char.Coda   or {}

  if vit.lag ~= nil and vit.lag ~= 0 then
    return false, "sei laggato."
  end

  if coda.numero ~= nil and coda.numero ~= 0 then
    return false, "hai comandi in coda."
  end

  return true
end

------------------------------------------------
-- Funzione generica: equip/unequip con DEPOSITO (banca),
-- usando .items / .bySet / .equipCmdBySlot di un PG
--
-- charname: "Valagar", "Alendil", "Uryel", ...
-- setTag  : es. "main" (se nil → usa "main" o tutto .items)
--
-- Logica:
--  - se lo slot contiene già l'oggetto target → lo rimuove e lo deposita
--  - se slot vuoto → preleva da banca e indossa
--  - se slot contiene qualcosa di diverso → SKIP (non tocca)
------------------------------------------------
function SPAM.equip_from_bank(charname, setTag)
  local charTable = SPAM[charname]
  if not charTable or not charTable.items then
    cecho("\n<red>[" .. tostring(charname) .. "] Nessuna tabella items trovata. Hai caricato lo script _items.lua?\n")
    return
  end

  -- BLOCCO LAG/CODA
  local ok, reason = SPAM.can_change_equip()
  if not ok then
    cecho("\n<red>[" .. tostring(charname) .. "] Non puoi cambiare equip adesso (" .. reason .. ")\n")
    return
  end

  local bySet    = charTable.bySet or {}
  local equipSet = nil

  if setTag and bySet[setTag] and #bySet[setTag] > 0 then
    equipSet = bySet[setTag]
  elseif bySet.main and #bySet.main > 0 then
    equipSet = bySet.main
  else
    equipSet = charTable.items
  end

  local equipCmdBySlot   = charTable.equipCmdBySlot or {}
  local heldKeys         = charTable.heldKeys or {}
  local itemkeyByName    = charTable.itemkeyByName or {}
  local defaultEquipCmds = SPAM.defaultEquipCmdBySlot or {}

  local delay   = 0
  local step    = 0.3
  local prefix  = "[" .. string.upper(charname) .. "] "

  ------------------------------------------------
  -- PRIMO PASSAGGIO: determina la modalità globale
  -- Guardiamo SOLO quanti pezzi del set sono equipaggiati
  ------------------------------------------------
  local equippedCount = 0

  for _, it in ipairs(equipSet) do
    local obj  = it.name
    local slot = it.slot
    local key  = it.key

    local current_raw = SPAM.get_equip_slot and SPAM.get_equip_slot(slot) or nil
    local slotEmpty   = SPAM.is_empty_name(current_raw)
    local current     = slotEmpty and nil or current_raw
    local curKey      = current and itemkeyByName[current] or nil

    local isTargetEquipped = false
    if key then
      if curKey and curKey == key then
        isTargetEquipped = true
      elseif current == key or current == obj then
        isTargetEquipped = true
      end
    end

    if isTargetEquipped then
      equippedCount = equippedCount + 1
    end
  end

  -- Se almeno un pezzo del set è equipaggiato → consideriamo il set "ON"
  local mode
  if equippedCount > 0 then
    mode = "unequip"   -- voglio togliere il set e depositare
  else
    mode = "equip"     -- nessun pezzo del set addosso → provo a equipaggiarlo
  end

  cecho("\n<cyan>" .. prefix .. "Modalità equip_from_bank: " .. mode ..
        " (pezzi equipaggiati: " .. tostring(equippedCount) .. ")\n")

  ------------------------------------------------
  -- SECONDO PASSAGGIO: esegue le azioni coerenti con la modalità scelta
  ------------------------------------------------
  for _, it in ipairs(equipSet) do
    local obj  = it.name
    local slot = it.slot
    local key  = it.key

    tempTimer(delay, function()
      local current_raw = SPAM.get_equip_slot and SPAM.get_equip_slot(slot) or nil
      local slotEmpty   = SPAM.is_empty_name(current_raw)
      local current     = slotEmpty and nil or current_raw
      local curKey      = current and itemkeyByName[current] or nil

      local isTargetEquipped = false
      if key then
        if curKey and curKey == key then
          isTargetEquipped = true
        elseif current == key or current == obj then
          isTargetEquipped = true
        end
      end

      if mode == "unequip" then
        ------------------------------------------------
        -- MODALITÀ "unequip" → tolgo solo i pezzi del set
        ------------------------------------------------
        if isTargetEquipped then
          local token = curKey or key or tostring(current)
          cecho("\n<cyan>" .. prefix .. "TOLGO & DEPOSITO: slot=" .. slot ..
                " → " .. tostring(current) .. "\n")
          send("rimuov " .. token)
          if not heldKeys[token] then
            send("deposit " .. token)
          end
        else
          cecho("\n<yellow>" .. prefix .. "SKIP (unequip): slot=" .. slot ..
                " contiene '" .. tostring(current) .. "' (target: " .. tostring(obj) .. ")\n")
        end

      else
        ------------------------------------------------
        -- MODALITÀ "equip" → provo a indossare il set
        ------------------------------------------------
        if slotEmpty then
          if not key then
            cecho("\n<red>" .. prefix .. "WARN: key mancante per '" .. tostring(obj) .. "'\n")
            return
          end

          local equipCmd = equipCmdBySlot[slot]
                        or defaultEquipCmds[slot]
                        or "indoss"

          cecho("\n<cyan>" .. prefix .. "PRELEVO & INDOSSO (slot vuoto): slot=" ..
                slot .. " → " .. obj .. "\n")
          send("prelev " .. key)
          send(equipCmd .. " " .. key)

        elseif isTargetEquipped then
          cecho("\n<green>" .. prefix .. "OK (già equip): slot=" .. slot ..
                " → " .. tostring(current) .. "\n")

        else
          cecho("\n<yellow>" .. prefix .. "SKIP (equip): slot=" .. slot ..
                " contiene '" .. tostring(current) ..
                "' (target: " .. tostring(obj) .. ")\n")
        end
      end
    end)

    delay = delay + step
  end
end

------------------------------------------------
-- Switch equip da CONTENITORE (legaccio, ecc.)
--
-- Usa i set definiti in .bySet (dps, tank, main, spell, ecc.)
--   SPAM.switch_set_from_bag("Uryel", "dps")
--   SPAM.switch_set_from_bag("Uryel", "tank")
------------------------------------------------
function SPAM.switch_set_from_bag(charname, setTag)
  local charTable = SPAM[charname]
  if not charTable or not charTable.items then
    cecho("\n<red>[" .. tostring(charname) .. "] Nessuna tabella items trovata. Hai caricato lo script _items.lua?\n")
    return
  end

  -- BLOCCO LAG/CODA
  local ok, reason = SPAM.can_change_equip()
  if not ok then
    cecho("\n<red>[" .. tostring(charname) .. " " .. tostring(setTag) .. "] Non puoi cambiare set adesso (" .. reason .. ")\n")
    return
  end

  local bySet    = charTable.bySet or {}
  local setItems = bySet[setTag]

  if not setItems or #setItems == 0 then
    cecho("\n<red>[" .. tostring(charname) .. "] Set '" .. tostring(setTag) .. "' non esiste o è vuoto nella mappa!\n")
    return
  end

  local contenitore    = charTable.contenitore or "legaccio"
  local heldKeys       = charTable.heldKeys or {}
  local equipCmdLocal  = charTable.equipCmdBySlot or {}
  local equipCmdGlobal = SPAM.defaultEquipCmdBySlot or {}

  local delay  = 0
  local step   = 0.3
  local prefix = "[" .. string.upper(charname) .. " " .. tostring(setTag) .. "] "

  for _, it in ipairs(setItems) do
    local objName = it.name
    local slot    = it.slot
    local key     = it.key

    if objName and slot and key then
      tempTimer(delay, function()
        -- Nome SOLO per messaggi / debugging
        local currentName = SPAM.get_equip_slot and SPAM.get_equip_slot(slot) or nil
        -- Key reale nello slot (usa helper robusto, gestisce sia name che key)
        local currentKey  = SPAM.get_key_in_slot and SPAM.get_key_in_slot(charname, slot) or nil

        cecho(string.format("\n<cyan>%sSWITCH: slot=%s → %s\n", prefix, slot, objName))

        -- se nello slot c'è qualcosa di diverso dalla key che vogliamo mettere
        if currentKey and currentKey ~= key then
          send("rimuov " .. currentKey)
          if not heldKeys[currentKey] then
            send("mett " .. currentKey .. " " .. contenitore)
          end
        end

        -- se non abbiamo già la key corretta equipaggiata, prendila e indossala
        if currentKey ~= key then
          if not heldKeys[key] then
            send("prend " .. key .. " " .. contenitore)
          end

          local equipCmd = equipCmdLocal[slot]
                        or equipCmdGlobal[slot]
                        or "ind"   -- comando standard per indossare dal contenitore
          send(equipCmd .. " " .. key)
        end
      end)

      delay = delay + step
    end
  end
end

------------------------------------------------
-- Stato RESY per PG
--   SPAM.RESY_STATE[charname] = {
--     baseBySlot = { [slot] = baseKey, ... },
--     activeType = "fire"/"ice"/"acid"/"venom"/""
--   }
------------------------------------------------
SPAM.RESY_STATE = SPAM.RESY_STATE or {}

------------------------------------------------
-- Stato SLAY per PG
--   SPAM.SLAY_STATE[charname] = {
--     baseBySlot = { [slot] = baseKey, ... },
--     activeType = "demon"/"drake"/""
--   }
------------------------------------------------
SPAM.SLAY_STATE = SPAM.SLAY_STATE or {}

------------------------------------------------
-- Helper generico per RESY/SLAY
-- Gestisce un "overlay" per slot:
--   - salva la base in baseBySlot
--   - mette/toglie gli item di un certo tipo (fire/ice/... o demon/drake)
--
-- cfg:
--   labelLower    = "resy" / "slay"      (per i messaggi)
--   usage         = "resy off | ..."     (stringa di help)
--   byTypeField   = "resyByType" / "slayByType"
--   keySetField   = "resyKeySet" / "slayKeySet"
--   stateTable    = SPAM.RESY_STATE / SPAM.SLAY_STATE
------------------------------------------------
local function switch_overlay(charname, arg, cfg)
  local charTable = SPAM[charname]
  if not charTable or not charTable.items then
    cecho("\n<red>[" .. tostring(charname) .. "] Nessuna tabella items per " .. cfg.labelLower .. ".\n")
    return
  end

  -- BLOCCO LAG/CODA
  local ok, reason = SPAM.can_change_equip()
  if not ok then
    cecho("\n<red>[" .. tostring(charname) .. "] Non puoi cambiare " .. cfg.labelLower .. " adesso (" .. reason .. ")\n")
    return
  end

  arg = string.lower(arg or "")
  if arg == "" then
    cecho("\n<red>Uso: " .. cfg.usage .. "\n")
    return
  end

  local contenitore   = charTable.contenitore or "legaccio"
  local byType        = charTable[cfg.byTypeField] or {}
  local itemkeyByName = charTable.itemkeyByName or {}
  local keySet        = charTable[cfg.keySetField] or {}

  -- stato per questo PG
  local state = cfg.stateTable[charname] or { baseBySlot = {}, activeType = "" }
  cfg.stateTable[charname] = state

  local baseBySlot = state.baseBySlot
  local activeType = state.activeType or ""

  local function isOverlayKey(key)
    if not key then return false end
    return keySet[key] == true
  end

  local function getCurrentKey(slot)
    local name = SPAM.get_equip_slot and SPAM.get_equip_slot(slot) or nil
    if not name then return nil end
    return itemkeyByName[name]
  end

  local function takeFromContainer(key)
    send("prend " .. key .. " " .. contenitore)
  end

  local function putInContainer(key)
    send("mett " .. key .. " " .. contenitore)
  end

  local function wear_from_inventory(key)
    send("indossa " .. key)
  end

  local function removeItem(key)
    send("rimuov " .. key)
  end

  local function getSlotSetForType(tipo)
    local set = {}
    for _, it in ipairs(byType[tipo] or {}) do
      set[it.slot] = true
    end
    return set
  end

  ------------------------------------------------
  -- Caso: OFF → disattivo tipo attivo e rimetto base
  ------------------------------------------------
  if arg == "off" then
    if activeType == "" then
      cecho("\n<yellow>Nessun set " .. cfg.labelLower .. " attivo.\n")
      return
    end

    local items = byType[activeType] or {}
    if #items == 0 then
      cecho("\n<red>Nessun item " .. cfg.labelLower .. " per il tipo attivo (" .. activeType .. ").\n")
      state.activeType = ""
      state.baseBySlot = {}
      return
    end

    cecho("\n<yellow>Disattivo set " .. cfg.labelLower .. " [" .. activeType .. "] e rimetto la base.\n")

    for _, it in ipairs(items) do
      local slot   = it.slot
      local oKey   = it.key
      local curKey = getCurrentKey(slot)

      if curKey == oKey then
        removeItem(oKey)
        putInContainer(oKey)
      end

      local baseKey = baseBySlot[slot]
      if baseKey and baseKey ~= "" then
        wear_from_inventory(baseKey)
      end
    end

    state.activeType = ""
    state.baseBySlot = {}
    return
  end

  ------------------------------------------------
  -- Caso: attivo / cambio tipo
  ------------------------------------------------
  local newType  = arg
  local newItems = byType[newType]

  if not newItems or #newItems == 0 then
    cecho("\n<red>Nessun set " .. cfg.labelLower .. " definito per: " .. newType .. "\n")
    return
  end

  -- se richiamo lo stesso tipo → comportati come OFF
  if activeType == newType then
    cecho("\n<yellow>Set " .. cfg.labelLower .. " [" .. newType .. "] già attivo, lo disattivo e rimetto la base.\n")

    for _, it in ipairs(newItems) do
      local slot   = it.slot
      local oKey   = it.key
      local curKey = getCurrentKey(slot)

      if curKey == oKey then
        removeItem(oKey)
        putInContainer(oKey)
      end

      local baseKey = baseBySlot[slot]
      if baseKey and baseKey ~= "" then
        wear_from_inventory(baseKey)
      end
    end

    state.activeType = ""
    state.baseBySlot = {}
    return
  end

  ------------------------------------------------
  -- Se c'è un vecchio tipo attivo diverso, ripristino
  -- gli slot che il nuovo tipo NON usa
  ------------------------------------------------
  if activeType ~= "" and activeType ~= newType then
    local oldItems   = byType[activeType] or {}
    local newSlotSet = getSlotSetForType(newType)

    cecho("\n<yellow>Passo da set " .. cfg.labelLower .. " [" .. activeType .. "] a [" .. newType .. "].\n")

    for _, it in ipairs(oldItems) do
      local slot   = it.slot
      local oKey   = it.key

      if not newSlotSet[slot] then
        local curKey = getCurrentKey(slot)

        if curKey == oKey then
          removeItem(oKey)
          putInContainer(oKey)
        end

        local baseKey = baseBySlot[slot]
        if baseKey and baseKey ~= "" then
          wear_from_inventory(baseKey)
        end
      end
    end
  end

  ------------------------------------------------
  -- Applico il nuovo tipo: salvo base (se serve) e metto gli overlay
  ------------------------------------------------
  cecho("\n<green>Attivo set " .. cfg.labelLower .. " [" .. newType .. "].\n")
  state.activeType = newType

  for _, it in ipairs(newItems) do
    local slot   = it.slot
    local oKey   = it.key

    local curKey  = getCurrentKey(slot)
    local baseKey = baseBySlot[slot]

    -- se non ho ancora salvato la base e sto indossando qualcosa
    -- di diverso dall'overlay che voglio mettere → salva base
    if not baseKey and curKey and curKey ~= oKey then
      baseBySlot[slot] = curKey
      baseKey = curKey
    end

    -- se sto indossando qualcosa di diverso dall'overlay
    if curKey and curKey ~= oKey then
      if isOverlayKey(curKey) then
        -- è un altro overlay (altro tipo) → torna nel contenitore
        removeItem(curKey)
        putInContainer(curKey)
      else
        -- base/altro → tolto ma resta in inventario
        removeItem(curKey)
      end
    end

    -- equipaggio l'overlay (se non è già su)
    curKey = getCurrentKey(slot)
    if curKey ~= oKey then
      takeFromContainer(oKey)
      wear_from_inventory(oKey)
    end
  end
end

------------------------------------------------
-- Switch RESY per un PG
--
-- arg:
--   "off"           -> disattiva resy e rimette la base
--   "fire"/"ice"/...-> attiva/cambia tipo
------------------------------------------------
function SPAM.switch_resy(charname, arg)
  switch_overlay(charname, arg, {
    labelLower  = "resy",
    usage       = "resy off | resy fire | resy ice | resy acid | resy venom",
    byTypeField = "resyByType",
    keySetField = "resyKeySet",
    stateTable  = SPAM.RESY_STATE,
  })
end

------------------------------------------------
-- Switch SLAY per un PG
--
-- arg:
--   "off"           -> disattiva slay e rimette la base
--   "demon"/"drake" -> attiva/cambia tipo
------------------------------------------------
function SPAM.switch_slay(charname, arg)
  switch_overlay(charname, arg, {
    labelLower  = "slay",
    usage       = "slay off | slay demon | slay drake",
    byTypeField = "slayByType",
    keySetField = "slayKeySet",
    stateTable  = SPAM.SLAY_STATE,
  })
end

------------------------------------------------
-- Entrypoint unico per "equip <tipoequip>"
--
--   equip dps     -> SPAM.switch_set_from_bag(charname, "dps")
--   equip tank    -> SPAM.switch_set_from_bag(charname, "tank")
--   equip fire    -> SPAM.switch_resy(charname, "fire")
--   equip ice     -> SPAM.switch_resy(charname, "ice")
--   equip acid    -> SPAM.switch_resy(charname, "acid")
--   equip venom   -> SPAM.switch_resy(charname, "venom")
--   equip demon   -> SPAM.switch_slay(charname, "demon")
--   equip drake   -> SPAM.switch_slay(charname, "drake")
--   equip off     -> spegne resy/slay attivi (se ci sono)
------------------------------------------------
function SPAM.equip(charname, what)
  local charTable = SPAM[charname]
  if not charTable or not charTable.items then
    cecho("\n<red>[" .. tostring(charname) .. "] Nessuna tabella items trovata.\n")
    return
  end

  -- BLOCCO LAG/CODA
  local ok, reason = SPAM.can_change_equip()
  if not ok then
    cecho("\n<red>[" .. tostring(charname) .. "] Non puoi cambiare " .. cfg.labelLower .. " adesso (" .. reason .. ")\n")
    return
  end

  what = string.lower(what or "")
  if what == "" then
    cecho("\n<red>Uso: vesti dps | vesti tank | vesti fire | vesti ice | vesti acid | vesti venom | vesti demon | vesti drake | vesti off\n")
    return
  end

  local resyByType = charTable.resyByType or {}
  local slayByType = charTable.slayByType or {}
  local bySet      = charTable.bySet or {}

  ------------------------------------------------
  -- "off" → spegni resy e slay se attivi
  ------------------------------------------------
  if what == "off" then
    local didSomething = false

    local resyState = SPAM.RESY_STATE and SPAM.RESY_STATE[charname]
    if resyState and resyState.activeType and resyState.activeType ~= "" then
      SPAM.switch_resy(charname, "off")
      didSomething = true
    end

    local slayState = SPAM.SLAY_STATE and SPAM.SLAY_STATE[charname]
    if slayState and slayState.activeType and slayState.activeType ~= "" then
      SPAM.switch_slay(charname, "off")
      didSomething = true
    end

    if not didSomething then
      cecho("\n<yellow>Nessun set resy/slay attivo da spegnere.\n")
    end

    return
  end

  ------------------------------------------------
  -- resy / slay
  ------------------------------------------------
  -- Se esiste un tipo resy con questo nome → usa switch_resy
  if resyByType[what] and #resyByType[what] > 0 then
    return SPAM.switch_resy(charname, what)
  end

  -- Se esiste un tipo slay con questo nome → usa switch_slay
  if slayByType[what] and #slayByType[what] > 0 then
    return SPAM.switch_slay(charname, what)
  end

  ------------------------------------------------
  -- Set “normali” (dps, tank, ecc.)
  -- Quando cambio set, *solo* lo stato resy/slay va azzerato,
  -- senza toccare l’equip corrente di resy/slay.
  ------------------------------------------------
  if bySet[what] and #bySet[what] > 0 then
    -- azzera SOLO la variabile di stato, non l’equip
    if SPAM.RESY_STATE and SPAM.RESY_STATE[charname] then
      SPAM.RESY_STATE[charname].activeType = nil
    end
    if SPAM.SLAY_STATE and SPAM.SLAY_STATE[charname] then
      SPAM.SLAY_STATE[charname].activeType = nil
    end

    return SPAM.switch_set_from_bag(charname, what)
  end

  ------------------------------------------------
  -- Niente trovato
  ------------------------------------------------
  cecho("\n<red>[" .. tostring(charname) .. "] Nessun set o tipo resy/slay trovato per: " .. what .. "\n")
end

------------------------------------------------
-- Helper GMCP: magie attive / proprietà magiche
------------------------------------------------

-- true se in gmcp.Char.Magie.incantesimi c'è un incantesimo con nome = name
function SPAM.has_spell_active(name)
  local magie = gmcp.Char and gmcp.Char.Magie
  local list = magie and magie.incantesimi
  if type(list) ~= "table" or type(name) ~= "string" then
    return false
  end

  local target = name:lower()
  for _, v in ipairs(list) do
    if type(v) == "table" and type(v.nome) == "string" then
      if v.nome:lower() == target then
        return true
      end
    end
  end

  return false
end

-- true se in gmcp.Char.Magie.proprieta c'è una proprietà con nome = name
function SPAM.has_property(name)
  local magie = gmcp.Char and gmcp.Char.Magie
  local list = magie and magie.proprieta
  if type(list) ~= "table" or type(name) ~= "string" then
    return false
  end

  local target = name:lower()
  for _, v in ipairs(list) do
    if type(v) == "table" and type(v.nome) == "string" then
      if v.nome:lower() == target then
        return true
      end
    end
  end

  return false
end

------------------------------------------------
-- Controlli generici per iniziare / continuare un cast
--
-- opts:
--   checkSilence         (default true)
--   requireStanding      (default true)
--   requireNoLag         (default true)
--   requireEmptyQueue    (default true)
--   blockIfTank          (default true)
--   blockIfPartyFight    (default true)
------------------------------------------------
function SPAM.can_start_cast(manaCost, opts)
  opts = opts or {}
  local vit  = gmcp.Char and gmcp.Char.Vitals or {}
  local coda = gmcp.Char and gmcp.Char.Coda   or {}

  -- silenzio
  if opts.checkSilence ~= false and SPAM.has_property("silenzio") then
    return false
  end

  -- in piedi
  if opts.requireStanding ~= false and vit.stato ~= "In Piedi" then
    return false
  end

  -- lag/coda
  if opts.requireNoLag ~= false and (vit.lag ~= nil and vit.lag ~= 0) then
    return false
  end
  if opts.requireEmptyQueue ~= false and (coda.numero ~= nil and coda.numero ~= 0) then
    return false
  end

  -- tank
  if opts.blockIfTank ~= false and vit.tank ~= nil and vit.tank ~= "" then
    return false
  end

  -- party in fight
  if opts.blockIfPartyFight ~= false and SPAM.party_in_fight then
    return false
  end

  -- mana
  if manaCost and (vit.mana == nil or vit.mana < manaCost) then
    return false
  end

  return true
end

function SPAM.has_hard_block_for_cast(manaCost, opts)
  opts = opts or {}
  local vit = gmcp.Char and gmcp.Char.Vitals or {}

  -- silenzio
  if opts.checkSilence ~= false and SPAM.has_property("silenzio") then
    return true
  end

  -- non in piedi
  if opts.requireStanding ~= false and vit.stato ~= "In Piedi" then
    return true
  end

  -- tank
  if opts.blockIfTank ~= false and vit.tank ~= nil and vit.tank ~= "" then
    return true
  end

  -- party in fight
  if opts.blockIfPartyFight ~= false and SPAM.party_in_fight then
    return true
  end

  -- mana
  if manaCost and (vit.mana == nil or vit.mana < manaCost) then
    return true
  end

  return false
end

------------------------------------------------
-- SpellFail helpers
-- Usa charTable.spellfail costruito da build_item_indexes
------------------------------------------------

-- Ritorna la lista di item spellFail per il PG (può essere vuota)
function SPAM.get_spellfail_items(charname)
  local charTable = SPAM[charname]
  if not charTable then
    return {}
  end
  return charTable.spellfail or {}
end

-- Rimuove dagli slot tutti gli item con spellFail = true attualmente indossati.
-- Ritorna la lista delle key rimosse (per poterle rimettere dopo).
function SPAM.remove_spellfail_equip(charname)
  local removed = {}

  local charTable = SPAM[charname]
  if not charTable then
    return removed
  end

  local spellfailItems = charTable.spellfail or {}
  local get_slot = SPAM.get_equip_slot

  if type(get_slot) ~= "function" then
    return removed
  end

  for _, it in ipairs(spellfailItems) do
    local slot = it.slot
    local name = it.name
    local key  = it.key

    local current = get_slot(slot)
    if current ~= nil and current == name then
      send("rimuov " .. key)
      table.insert(removed, key)
    end
  end

  return removed
end

-- Rimette una lista di key, con comando di equip specificabile (default "indoss")
function SPAM.reequip_keys(keys, equipCmd)
  equipCmd = equipCmd or "indoss"
  for _, key in ipairs(keys or {}) do
    send(equipCmd .. " " .. key)
  end
end

------------------------------------------------
-- Funzione generica:
--   cast_spell_without_spellfail(charname, cfg)
--
-- cfg:
--   spellName          = "distorsione"         -- (string) nome spell in gmcp
--   castCmd            = "formul distorsione"  -- (string|function) comando da inviare
--   manaCost           = 35                    -- (number, opz.) mana richiesto
--
--   opts = {                                   -- (table, opz.) controlli aggiuntivi:
--     -- Controlli di stato / ambiente
--     checkSilence      = true,  -- non castare se hai "silenzio" tra le proprietà
--     requireStanding   = true,  -- richiede gmcp.Char.Vitals.stato == "In Piedi"
--     requireNoLag      = true,  -- blocca se vit.lag ~= 0
--     requireEmptyQueue = true,  -- blocca se coda.numero ~= 0
--
--     -- Contesti "logici" di gioco (dipende dalla tua implementazione interna)
--     blockIfTank       = true,  -- non castare se sei in modalità tank
--     blockIfPartyFight = true,  -- non castare se il party è già in combattimento
--
--     -- Estendibile:
--     -- qualsiasi altra chiave che SPAM.can_start_cast / SPAM.has_hard_block_for_cast
--     -- sappiano interpretare (es. "minIdleSeconds", "blockIfLowHp", ecc.).
--   }
--
--   equipCmd           = "indoss"              -- (string, opz.) comando per rimettere gli item
--   loopDelay          = 0.5                   -- (number, opz.) delay tra i tentativi
--   forceFirstIfActive = false                 -- (bool, opz.) se true tenta almeno il primo cast
--                                              -- anche se la spell risulta già attiva
--
-- Note:
--   - Usa SPAM.can_start_cast(manaCost, opts) per i controlli iniziali.
--   - Usa SPAM.has_hard_block_for_cast(manaCost, opts) dentro il loop.
--   - NON blocca il cast se la spell è già attiva *se* forceFirstIfActive = true
--     (puoi usarla per il refresh).
------------------------------------------------
function SPAM.cast_spell_without_spellfail(charname, cfg)
  cfg = cfg or {}

  local charTable = SPAM[charname]
  if not charTable or not charTable.items then
    cecho("\n<red>[" .. tostring(charname) .. "] Nessuna tabella items per cast_spell_without_spellfail.\n")
    return
  end

  local spellName           = cfg.spellName
  local castCmd             = cfg.castCmd
  local manaCost            = cfg.manaCost
  local opts                = cfg.opts or {}
  local equipCmd            = cfg.equipCmd or "indoss"
  local delay               = cfg.loopDelay or 0.5
  local forceFirstIfActive  = cfg.forceFirstIfActive or false

  if type(spellName) ~= "string" or spellName == "" then
    cecho("\n<red>cast_spell_without_spellfail: 'spellName' obbligatorio.\n")
    return
  end

  -- Se la spell è già attiva
  local alreadyActive = false
  if SPAM.has_spell_active then
    alreadyActive = SPAM.has_spell_active(spellName)
  end

  -- Di default non facciamo nulla se è già attiva.
  -- Se forceFirstIfActive = true, ignoriamo questo check e proseguiamo.
  if alreadyActive and not forceFirstIfActive then
    cecho("\n<yellow>[" .. tostring(charname) .. "] " .. spellName .. " è già attiva, nessun cast eseguito.\n")
    return
  end

  -- Wrapper per eseguire il comando di cast
  local function do_cast()
    if type(castCmd) == "string" then
      send(castCmd)
    elseif type(castCmd) == "function" then
      castCmd()
    else
      send("formul " .. spellName)
    end
  end

  -- 1) Controlli iniziali generali (usano opts)
  if not SPAM.can_start_cast(manaCost, opts) then
    cecho("\n<red>Cannot cast " .. spellName:upper() .. " now!\n")
    return
  end

  -- 2) Rimuovo gli oggetti spellFail attualmente indossati
  local removed_keys = SPAM.remove_spellfail_equip(charname)

  -- 3) Primo tentativo di cast
  do_cast()

  -- 4) Loop asincrono finché la spell non è attiva o c'è blocco duro
  local function loop()
    local vit   = gmcp.Char and gmcp.Char.Vitals or {}
    local coda  = gmcp.Char and gmcp.Char.Coda   or {}

    -- a) Spell attiva → fine, rimettiamo gli oggetti
    if SPAM.has_spell_active(spellName) then
      SPAM.reequip_keys(removed_keys, equipCmd)
      return
    end

    -- b) Blocco duro (usa ancora opts)
    if SPAM.has_hard_block_for_cast(manaCost, opts) then
      cecho("\n<red>Impossibile proseguire col cast di " .. spellName:upper() .. " (blocco duro).\n")
      SPAM.reequip_keys(removed_keys, equipCmd)
      return
    end

    -- c) C'è solo lag o coda → aspettiamo e riproviamo
    if (vit.lag and vit.lag ~= 0) or (coda.numero and coda.numero ~= 0) then
      tempTimer(delay, loop)
      return
    end

    -- d) Nessun blocco, niente lag/coda → nuovo tentativo
    do_cast()
    tempTimer(delay, loop)
  end

  tempTimer(delay, loop)
end
