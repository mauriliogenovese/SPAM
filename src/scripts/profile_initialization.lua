initialize_persistent_var("config")
package_name = "@PKGNAME@"
--first profile login
local save_var = false
if persistent_variables["config"]["sounds"] == nil then
  persistent_variables["config"]["sounds"] = true
  save_var = true
end
if persistent_variables["config"]["dde_group"] == nil then
  persistent_variables["config"]["dde_group"] = true
  save_var = true
end
if persistent_variables["config"]["glory_timer"] == nil then
  persistent_variables["config"]["glory_timer"] = true
  save_var = true
end
if persistent_variables["config"]["hide_lost_experience"] == nil then
  persistent_variables["config"]["hide_lost_experience"] = true
  save_var = true
end
if persistent_variables["config"]["hide_immune_shield"] == nil then
  persistent_variables["config"]["hide_immune_shield"] = true
  save_var = true
end
if persistent_variables["config"]["clipboard"] == nil then
  persistent_variables["config"]["clipboard"] = true
  save_var = true
end
if persistent_variables["config"]["mapper"] == nil then
  persistent_variables["config"]["mapper"] = false
  save_var = true
end
if save_var == true then
  save_persistent_var("config")
end
if persistent_variables["config"]["mapper"] then
    enableTrigger("DDE_mapper_Trigger_Group")
    tempTimer(0.5,mod_generic_mapper)
else
    disableTrigger("DDE_mapper_Trigger_Group")
end
--update check
registerAnonymousEventHandler("sysDownloadDone", "spam_eventHandler")
registerAnonymousEventHandler("sysDownloadError", "spam_eventHandler")
spam_downloading = true
downloadFile(getMudletHomeDir() .. "/@PKGNAME@/version", "https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/version")
ding_file = getMudletHomeDir() .. "/@PKGNAME@/ding.wav"
character_name = ""
cond = {}
cond["e' in condizioni superbe"] = 1
cond["e' in condizioni quasi superbe"] = 2
cond["e' in eccellenti condizioni"] = 3
cond["e' in condizioni quasi eccellenti"] = 4
cond["e' in ottimo stato"] = 5
cond["e' in buono stato"] = 6
cond["e' un po' rovinato"] = 7
cond["e' rovinato"] = 8
cond["e' molto rovinato"] = 9
cond["e' in cattivo stato"] = 10
cond["ha bisogno di riparazioni"] = 11
cond["e' in condizioni critiche"] = 12
cond["e' quasi inutilizzabile"] = 13
cond["sta per cadere a pezzi"] = 14
cond["e' a pezzi"] = 15
colors =
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
ddeGroupContainer = ddeGroupContainer or Adjustable.Container:new({name = "DdE Group"})
ddeGroupContainer.name = "DdE Group"
ddeGroupContainer:unlockContainer()
ddeGroupWidget =
  ddeGroupWidget or
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
    ddeGroupContainer
  )
clearWindow("DdE Group")
ddeGroupWidget:echo("\r\n*** DdE Group Caricato.\r\n")
toggle_ddegroup()
class_list = {}
class_list["Chierico"] = new_class()
class_list["Chierico"].buff.dps = {"benedizione", "aiuto divino"}
class_list["Chierico"].buff.base = {"santificazione", "volo"}
--class_list["Chierico"].self_buff.tank = {"protezione dal bene","protezione dal male","protezione dal fuoco","resistenza elettrica","protezione dalla energia","resistenza risucchio"}
class_list["Chierico"].heal = {"cura critiche", "guarigione", "cure leggere continue"}
class_list["Chierico"].move = {"nuovo vigore"}
class_list["Paladino"] = new_class()
class_list["Paladino"].buff.dps = {"benedizione"}
class_list["Paladino"].self_buff.tank = {"aura benefica", "armatura sacra"}
class_list["Paladino"].self_buff.dps = {"crociata", "morale"}
class_list["Paladino"].heal = {"imposizione delle mani", "martirio"}
class_list["Paladino"].command = "prega"
class_list["Oscuro"] = new_class()
class_list["Oscuro"].self_buff.dps = {"rito oscuro"}
class_list["Oscuro"].self_buff.base = {"anima fiammeggiante", "scudo fiammeggiante"}
class_list["Oscuro"].command = "prega"
class_list["Mago"] = new_class()
class_list["Mago"].buff.dps = {"forza"}
class_list["Mago"].buff.tank = {"scudo", "armatura"}
class_list["Mago"].buff.base = {"volo"}
class_list["Mago"].self_buff.base = {"scudo infuocato"}
class_list["Mago"].self_buff.tank = {"pelle di pietra"}
class_list["Mago"].move = {"ristora"}
class_list["Cercatore"] = new_class()
class_list["Cercatore"].buff.base = {"santificazione", "volo", "agilita felina"}
class_list["Cercatore"].buff.dps = {"benedizione", "forza"}
class_list["Cercatore"].buff.tank = {"scudo"}
class_list["Cercatore"].self_buff.base = {"scudo di ghiaccio", "cuore di naria"}
class_list["Cercatore"].heal = {"cura serie", "guarigione", "brezza di naria"}
class_list["Cercatore"].move = {"ristora"}
class_list["Vampiro"] = new_class()
class_list["Vampiro"].buff.dps = {"forza"}
class_list["Vampiro"].buff.tank = {"scudo", "tenebre"}
class_list["Vampiro"].buff.base = {"volo"}
class_list["Vampiro"].self_buff.tank = {"pelle demoniaca"}
class_list["Druido"] = new_class()
class_list["Druido"].buff.base = {"volo", "agilita felina"}
class_list["Druido"].self_buff.base = {"scudo di ghiaccio", "spirito di naria"}
class_list["Druido"].self_buff.tank = {"pelle del drago", "pelle di corteccia"}
class_list["Druido"].heal = {"cura critiche", "brezza di naria"}
class_list["Druido"].move = {"nuovo vigore"}
class_list["Ranger"] = new_class()
class_list["Ranger"].buff.base = {"agilita felina"}
class_list["Ranger"].self_buff.dps = {"ferocia animale"}
class_list["Ranger"].self_buff.tank = {"pelle di corteccia"}
class_list["Ranger"].heal = {"cura critiche"}
class_list["Ranger"].move = {"nuovo vigore"}
class_list["Psionico"] = new_class()
class_list["Psionico"].buff.base = {"levitazione"}
class_list["Psionico"].self_buff.base = {"scudo di energia"}
class_list["Psionico"].self_buff.dps = {"forza psionica"}
class_list["Psionico"].self_buff.tank = {"scudo mentale", "sfera protettiva"}
class_list["Psionico"].heal = {"nostrum"}
class_list["Psionico"].command = "pensa"
class_list["Necromante"] = new_class()
class_list["Necromante"].buff.base = {"levitazione"}
class_list["Necromante"].buff.tank = {"tenebre"}
class_list["Necromante"].self_buff.base = {"scudo di ossa"}
class_list["Necromante"].self_buff.tank = {"armatura di ombra", "pegno dei vinti"}
class_list["Necromante"].command = "evoc"
class_list["Necromante"].move = {"ristora"}