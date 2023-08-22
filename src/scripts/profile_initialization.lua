SPAM = SPAM or {}
initialize_persistent_var("config")
SPAM.package_name = "@PKGNAME@"
--first profile login
local save_var = false
if SPAM.persistent_variables["config"]["sounds"] == nil then
  SPAM.persistent_variables["config"]["sounds"] = true
  save_var = true
end
if SPAM.persistent_variables["config"]["dde_group"] == nil then
  SPAM.persistent_variables["config"]["dde_group"] = true
  save_var = true
end
if SPAM.persistent_variables["config"]["abbil_chat"] == nil then
  SPAM.persistent_variables["config"]["abbil_chat"] = true
  save_var = true
end
if SPAM.persistent_variables["config"]["glory_timer"] == nil then
  SPAM.persistent_variables["config"]["glory_timer"] = true
  save_var = true
end
if SPAM.persistent_variables["config"]["hide_lost_experience"] == nil then
  SPAM.persistent_variables["config"]["hide_lost_experience"] = true
  save_var = true
end
if SPAM.persistent_variables["config"]["hide_immune_shield"] == nil then
  SPAM.persistent_variables["config"]["hide_immune_shield"] = true
  save_var = true
end
if SPAM.persistent_variables["config"]["clipboard"] == nil then
  SPAM.persistent_variables["config"]["clipboard"] = true
  save_var = true
end
if SPAM.persistent_variables["config"]["mapper"] == nil then
  SPAM.persistent_variables["config"]["mapper"] = false
  save_var = true
end
if SPAM.persistent_variables["config"]["auto_send"] == nil then
  SPAM.persistent_variables["config"]["auto_send"] = false
  save_var = true
end
if SPAM.persistent_variables["config"]["dev"] == nil then
  SPAM.persistent_variables["config"]["dev"] = false
  save_var = true
end
if save_var == true then
  save_persistent_var("config")
end
if SPAM.persistent_variables["config"]["mapper"] then
    enableTrigger("DDE_mapper_Trigger_Group")
    tempTimer(0.5,mod_generic_mapper)
else
    disableTrigger("DDE_mapper_Trigger_Group")
end
--temporary fix for game bug
SPAM.persistent_variables["config"]["hide_immune_shield"] = false
--update check
registerAnonymousEventHandler("sysDownloadDone", "spam_eventHandler")
registerAnonymousEventHandler("sysDownloadError", "spam_eventHandler")
SPAM.spam_downloading = true
local version_file = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/version"
if SPAM.persistent_variables["config"]["dev"] == true then
    version_file = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/dev/version"
end
downloadFile(getMudletHomeDir() .. "/@PKGNAME@/version", version_file)
SPAM.ding_file = getMudletHomeDir() .. "/@PKGNAME@/ding.wav"
SPAM.character_name = ""
SPAM.cond = {}
SPAM.cond["e' in condizioni superbe"] = 1
SPAM.cond["e' in condizioni quasi superbe"] = 2
SPAM.cond["e' in eccellenti condizioni"] = 3
SPAM.cond["e' in condizioni quasi eccellenti"] = 4
SPAM.cond["e' in ottimo stato"] = 5
SPAM.cond["e' in buono stato"] = 6
SPAM.cond["e' un po' rovinato"] = 7
SPAM.cond["e' rovinato"] = 8
SPAM.cond["e' molto rovinato"] = 9
SPAM.cond["e' in cattivo stato"] = 10
SPAM.cond["ha bisogno di riparazioni"] = 11
SPAM.cond["e' in condizioni critiche"] = 12
SPAM.cond["e' quasi inutilizzabile"] = 13
SPAM.cond["sta per cadere a pezzi"] = 14
SPAM.cond["e' a pezzi"] = 15
SPAM.colors =
  {
    "00FF00",
    "5bf400",
    "7de800",
    "96dc00",
    "aad000",
    "bbc300",
    "cab500",
    "d7a700",
    "e29700",
    "eb8700",
    "f27600",
    "f86400",
    "fc4f00",
    "ff3500",
    "FF0000",
  }
-- Contenitore e mini-console per DdE Group
SPAM.ddeGroupContainer = SPAM.ddeGroupContainer or Adjustable.Container:new({name = "DdE Group"})
SPAM.ddeGroupContainer.name = "DdE Group"
SPAM.ddeGroupContainer:unlockContainer()
SPAM.ddeGroupWidget =
  SPAM.ddeGroupWidget or
  Geyser.MiniConsole:new(
    {
      name = "DdE Group",
      x = 0,
      y = 0,
      autoWrap = true,
      color = 'black',
      scrollBar = false,
      fontSize = 12,
      width = "100%",
      height = "100%",
    },
    SPAM.ddeGroupContainer
  )
clearWindow("DdE Group")
SPAM.ddeGroupWidget:echo("\r\n*** DdE Group Caricato.\r\n")
toggle_ddegroup()
-- Contenitore e mini-console per DdE Chat
SPAM.abbilchatContainer = SPAM.abbilchatContainer or Adjustable.Container:new({name = "Abbil Chat"})
SPAM.abbilchatContainer.name = "Abbil Chat"
SPAM.abbilchatContainer:unlockContainer()
SPAM.abbilchatWidget =
  SPAM.abbilchatWidget or
  Geyser.MiniConsole:new(
    {
      name = "Abbil Chat",
      x = 0,
      y = 0,
      autoWrap = true,
      color = 'black',
      scrollBar = false,
      font = getFont(),
      fontSize = getFontSize(),
      width = "100%",
      height = "100%",
    },
    SPAM.abbilchatContainer
  )
clearWindow("Abbil Chat")
SPAM.abbilchatWidget:echo("\r\n*** Abbil Chat Caricato.\r\n")
toggle_abbilchat()
SPAM.class_list = {}
SPAM.class_list["Chierico"] = new_class()
SPAM.class_list["Chierico"].buff.dps = {"benedizione", "aiuto divino"}
SPAM.class_list["Chierico"].buff.base = {"santificazione", "volo"}
--SPAM.class_list["Chierico"].self_buff.tank = {"protezione dal bene","protezione dal male","protezione dal fuoco","resistenza elettrica","protezione dalla energia","resistenza risucchio"}
SPAM.class_list["Chierico"].heal = {"cura critiche", "guarigione", "cure leggere continue"}
SPAM.class_list["Chierico"].move = {"nuovo vigore"}
SPAM.class_list["Paladino"] = new_class()
SPAM.class_list["Paladino"].buff.dps = {"benedizione"}
SPAM.class_list["Paladino"].self_buff.tank = {"aura benefica", "armatura sacra"}
SPAM.class_list["Paladino"].self_buff.dps = {"crociata", "morale"}
SPAM.class_list["Paladino"].heal = {"imposizione delle mani", "martirio"}
SPAM.class_list["Paladino"].command = "prega"
SPAM.class_list["Oscuro"] = new_class()
SPAM.class_list["Oscuro"].self_buff.dps = {"rito oscuro"}
SPAM.class_list["Oscuro"].self_buff.base = {"anima fiammeggiante", "scudo fiammeggiante"}
SPAM.class_list["Oscuro"].command = "prega"
SPAM.class_list["Mago"] = new_class()
SPAM.class_list["Mago"].buff.dps = {"forza"}
SPAM.class_list["Mago"].buff.tank = {"scudo", "armatura"}
SPAM.class_list["Mago"].buff.base = {"volo"}
SPAM.class_list["Mago"].self_buff.base = {"scudo infuocato"}
SPAM.class_list["Mago"].self_buff.tank = {"pelle di pietra"}
SPAM.class_list["Mago"].move = {"ristora"}
SPAM.class_list["Cercatore"] = new_class()
SPAM.class_list["Cercatore"].buff.base = {"santificazione", "volo", "agilita felina"}
SPAM.class_list["Cercatore"].buff.dps = {"benedizione", "forza"}
SPAM.class_list["Cercatore"].buff.tank = {"scudo"}
SPAM.class_list["Cercatore"].self_buff.base = {"scudo di ghiaccio", "cuore di naria"}
SPAM.class_list["Cercatore"].heal = {"cura serie", "guarigione", "brezza di naria"}
SPAM.class_list["Cercatore"].move = {"ristora"}
SPAM.class_list["Vampiro"] = new_class()
SPAM.class_list["Vampiro"].buff.dps = {"forza"}
SPAM.class_list["Vampiro"].buff.tank = {"scudo", "tenebre"}
SPAM.class_list["Vampiro"].buff.base = {"volo"}
SPAM.class_list["Vampiro"].self_buff.tank = {"pelle demoniaca"}
SPAM.class_list["Druido"] = new_class()
SPAM.class_list["Druido"].buff.base = {"volo", "agilita felina"}
SPAM.class_list["Druido"].self_buff.base = {"scudo di ghiaccio", "spirito di naria"}
SPAM.class_list["Druido"].self_buff.tank = {"pelle del drago", "pelle di corteccia"}
SPAM.class_list["Druido"].heal = {"cura critiche", "brezza di naria"}
SPAM.class_list["Druido"].move = {"nuovo vigore"}
SPAM.class_list["Ranger"] = new_class()
SPAM.class_list["Ranger"].buff.base = {"agilita felina"}
SPAM.class_list["Ranger"].self_buff.dps = {"ferocia animale"}
SPAM.class_list["Ranger"].self_buff.tank = {"pelle di corteccia"}
SPAM.class_list["Ranger"].heal = {"cura critiche"}
SPAM.class_list["Ranger"].move = {"nuovo vigore"}
SPAM.class_list["Psionico"] = new_class()
SPAM.class_list["Psionico"].buff.base = {"levitazione"}
SPAM.class_list["Psionico"].self_buff.base = {"scudo di energia"}
SPAM.class_list["Psionico"].self_buff.dps = {"forza psionica"}
SPAM.class_list["Psionico"].self_buff.tank = {"scudo mentale", "sfera protettiva"}
SPAM.class_list["Psionico"].heal = {"nostrum"}
SPAM.class_list["Psionico"].command = "pensa"
SPAM.class_list["Necromante"] = new_class()
SPAM.class_list["Necromante"].buff.base = {"levitazione"}
SPAM.class_list["Necromante"].buff.tank = {"tenebre"}
SPAM.class_list["Necromante"].self_buff.base = {"scudo di ossa"}
SPAM.class_list["Necromante"].self_buff.tank = {"armatura di ombra", "pegno dei vinti"}
SPAM.class_list["Necromante"].command = "evoc"
SPAM.class_list["Necromante"].move = {"ristora"}
