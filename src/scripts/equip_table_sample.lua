SPAM = SPAM or {}

SPAM.equip_table_help = [[
-- Script_Personaggio/pg_items.lua

SPAM = SPAM or {}
SPAM.PGName = SPAM.PGName or {}

------------------------------------------------
-- Contenitore di default del Personaggio
------------------------------------------------
SPAM.PGName.contenitore = "legaccio"

------------------------------------------------
-- Tabella unica degli oggetti del Personaggio
-- Ogni voce è creata tramite SPAM.item{ ... }:
--   name      = "Nome GMCP esatto" (obbligatorio)
--   key       = "chiave-per-i-comandi" (obbligatorio)
--   slot      = "slot di equip" (obbligatorio)
--   spellFail = true/false (default: false)
--   held      = true/false (default: false)
--   sets      = "main" / { "main", "altro" } / { main = true, ... }
--               (default: { main = true })
--   resy  = "fire"/"ice"/"acid"/"venom"/nil
--   slay  = "demon"/"drake"/nil
------------------------------------------------
SPAM.PGName.items = {
  -------------------------------
  -- ESEMPIO EQUIP DI DEFAULT
  -------------------------------
  SPAM.item{
    name = "L'elmo di Default del PGName",
    key  = "elmo-default",
    slot = "testa",
    sets = {},  -- nessun set specifico
  },

  -------------------------------
  -- ESEMPIO DI EQUIP APPARTENENTE A UN SET
  -------------------------------
  SPAM.item{
    name = "La Maschera del DPS di PGName",
    key  = "elmo-dps",
    slot = "maschera",
    sets = "dps",
  },
  
  -------------------------------
  -- ESEMPIO DI EQUIP CON SPELLFAIL
  -------------------------------
  SPAM.item{
    name = "Gli occhiali con gradazione sbagliata di PGName",
    key  = "occhiali-graffiati",
    slot = "occhi",
    spellFail = true,   -- fa fallire i cast
  },
  
  -------------------------------
  -- ESEMPIO DI EQUIP DA TENERE IN INVENTARIO QUANDO RIMOSSI/SWITCHATI
  -------------------------------
  SPAM.item{
    name = "Gli orecchini portafortuna di PGName",
    key  = "orecchini-portafortuna",
    slot = "orecchini",
    held = true,   -- da tenere in inventario
  },

  -------------------------------
  -- ESEMPIO DI EQUIP DI UN SET RESY
  -------------------------------
  SPAM.item{
    name = "La collana di protezione dal ghiaccio di PGName",
    key  = "collana-ghiaccio",
    slot = "collo 1",
    resy = "acido",
  },

  -------------------------------
  -- ESEMPIO DI EQUIP DI UN SET SLAY
  -------------------------------
  SPAM.item{
    name = "Lo stendardo di Maximilian il Cacciademoni",
    key  = "stendardo-demoni",
    slot = "zaino",
    slay = "demoni",
  },
}
------------------------------------------------
-- Costruzione indici tramite helper generico
------------------------------------------------
SPAM.build_item_indexes(SPAM.PGName)


------------------------------------------------
-- ESEMPIO ALIAS DI UTILIZZO TABELLA EQUIP PER SWITCH TRA SET
------------------------------------------------
-- alias: equip <tipoequip>
-- pattern: ^equip (.+)$

local setName = matches[2] and string.lower(matches[2]) or nil
if not setName then
  cecho("\n<red>Devi specificare un set/tipo: vesti dps | vesti tank | vesti fire | vesti ice | vesti acid | vesti venom | vesti off\n")
  return
end

SPAM.equip("PGName", setName)

------------------------------------------------
-- ESEMPIO ALIAS DI UTILIZZO DELLA TABELLA EQUIP PER SWITCH RESY
------------------------------------------------
-- Alias: resy [tipo]
-- Esempi:
--   resy fire
--   resy ice
--   resy acid
--   resy venom
--   resy off

-- pattern: ^resy(?: (.+))?$

local arg = matches[2]
if arg then
  arg = string.lower(arg):gsub("^%s+", ""):gsub("%s+$", "")
end

if not arg or arg == "" then
  cecho("\n<yellow>Uso: resy fire | resy ice | resy acid | resy venom | resy off\n")
  return
end

SPAM.switch_resy("PGName", arg)

------------------------------------------------
-- ESEMPIO ALIAS DI UTILIZZO DELLA TABELLA EQUIP PER SWITCH SLAY
------------------------------------------------
-- Alias: slay [tipo]
-- Esempi:
--   slay demon
--   slay drake

-- pattern: ^say(?: (.+))?$

local arg = matches[2]
if arg then
  arg = string.lower(arg):gsub("^%s+", ""):gsub("%s+$", "")
end

if not arg or arg == "" then
  cecho("\n<yellow>Uso: slay demon | slay drake | slay off\n")
  return
end

SPAM.switch_slay("PGName", arg)
]]