SPAM = SPAM or {}
SPAM.package_name = "@PKGNAME@"

SPAM.config = SPAM.config or {}
SPAM.config.globals_savelocation = getMudletHomeDir() .. "/@PKGNAME@_globals.lua"
SPAM.config.characters_savelocation = getMudletHomeDir() .. "/@PKGNAME@_characters.lua"
SPAM.config.globals = {}
SPAM.config.globals["dde_group"] = {
    name = "DdEgroup",
    desc = [[DDEGroup è uno schermo per monitorare i buff dei compagni di gruppo.
Per abilitare/disabilitare DDEGroup usa il comando: <yellow>spam ddegroup on/off<grey>
Per controllare le ulteriori opzioni di DDEGroup usa il comando: <yellow>observe<grey>]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["sounds"] = {
    name = "Suoni",
    desc = [[Alcune funzioni di SPAM potrebbero riprodurre dei suoni.
Per controllare la riproduzione dei suoni usa il comando: <yellow>spam suoni on/off]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["abbil_chat"] = {
    name = "AbbilChat",
    desc = [[AbbilChat è lo schermo sviluppato da Abbil per monitorare le comunicazioni.
Per abilitare/disabilitare AbbilChat usa il comando: <yellow>spam abbilchat on/off<grey>]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["glory"] = {
    name = "Gloria",
    desc = [[La funzione Gloria permette di tenere traccia dei mob gloria uccisi nelle ultime 24 ore.
Per abilitare/disabilitare questa funzione usa il comando: <yellow>spam gloria on/off<grey>
Per mostrare i mob gloria uccisi nelle ultime 24 ore usa il comando: <yellow>gloria]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["hide_lost_experience"] = {
    name = "Nascondi_px_persi",
    desc = [[Per nascondere le righe che notificano la perdita di px oltre il livello usa il comando: <yellow>spam nascondi_px_persi on/off]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["prompt_color"] = {
    name = "Prompt_colorato",
    desc = [[SPAM può colorare i tuoi punti ferita nel prompt con una scala verde-rosso
Per abilitare/disabilitare la colorazione del prompt usa il comando: <yellow>spam prompt_colorato on/off]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["equip_color"] = {
    name = "Equip_colorato",
    desc = [[SPAM può colorare lo stato di usura degli oggetti con una scala verde-rosso
Per abilitare/disabilitare la colorazione dell'usura degli oggetti usa il comando: <yellow>spam equip_colorato on/off]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["hide_immune_shield"] = {
    name = "Nascondi_scudoni",
    desc = [[Per nascondere le righe sugli scudoni che NON colpiscono usa il comando: <yellow>spam nascondi_scudoni on/off]],
    var_type = "bool",
    default = false
}
SPAM.config.globals["clipboard"] = {
    name = "Appunti",
    desc = [[SPAM intercetta i valuta mostri e le identificazioni e li copia negli appunti.
Per controllare l'inserimento negli appunti usa il comando: <yellow>spam appunti on/off]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["mapper"] = {
    name = "Mapper",
    desc = [[SPAM apporta alcune modifiche al mapper di Mudlet per renderlo compatibile con DDE.
Per controllare il mapper usa il comando: <yellow>spam mapper on/off]],
    var_type = "bool",
    default = false
}
SPAM.config.globals["auto_send"] = {
    name = "NariaDB",
    desc = [[SPAM può inviare automaticamente le ientificazioni viste al database oggetti gestito da Nikeb.
Per controllare l'invio automatico delle identificazioni usa il comando: <white>spam NariaDB on/off]],
    var_type = "bool",
    default = false
}
SPAM.config.globals["parse_eval"] = {
    name = "Valutamostri",
    desc = [[SPAM può inviare automaticamente al gruppo suggerimenti sulle armi e sui cast da usare su un mob appena valutato con l'apposito incantesimo.
Per controllare l'invio automatico delìi suggerimenti usa il comando: <white>spam valutamostri on/off]],
    var_type = "bool",
    default = true
}
SPAM.config.globals["fast_login"] = {
    name = "Login",
    desc = [[SPAM può automatizzare la procedura di login per evitare di dover digitare invio e 1 alla connessione.
Per abilitare/disabilitare questa funzione usa il comando: <white>spam login on/off]],
    var_type = "bool",
    default = false
}
SPAM.config.globals["dev"] = {
    name = "dev",
    desc = [[]],
    var_type = "bool",
    default = false,
    hidden = true
}
SPAM.config.globals["debug"] = {
    name = "debug",
    desc = [[]],
    var_type = "bool",
    default = false,
    hidden = true
}
SPAM.config.globals["gdcolor"] = {
    name = "gdcolor",
    desc = [[SPAM ti permette di impostare un suffisso e un prefisso per personalizzare il comando gd
Per impostare un prefisso usa il comando: <yellow>spam gdcolor_prefisso prefisso<grey>
Per impostare un suffisso usa il comando: <yellow>spam gdcolor_suffisso suffisso<grey>

Ad esempio per ottenere questo risultato: <blue>[<white>Seymour<blue>] dice al gruppo '<yellow>**<cyan>ciao<yellow>**<blue>'.
<grey>Dovresti usare i seguenti comandi
<yellow>spam gdcolor_prefisso &Y**&C
spam gdcolor_suffisso &Y**<grey>

Per scoprire i TAG colore disponibili in Dei delle Ere usa il comando: <yellow>aiuto colori<grey>]],
    var_type = "bool",
    default = true,
}
SPAM.config.globals["buff_font_size"] = {
    name = "",
    desc = [[]],
    var_type = "int",
    default = getFontSize(),
    hidden = true
}

SPAM.config.characters = {}
SPAM.config.characters["observe_list"] = {
    name = "",
    desc = [[]],
    var_type = "list",
    default = {},
    hidden = true
}
SPAM.config.characters["optional_buff"] = {
    name = "",
    desc = [[]],
    var_type = "list",
    default = {},
    hidden = true
}
SPAM.config.characters["custom_refresh"] = {
    name = "",
    desc = [[]],
    var_type = "list",
    default = {},
    hidden = true
}
SPAM.config.characters["autocast"] = {
    name = "",
    desc = [[]],
    var_type = "bool",
    default = false,
    hidden = true
}
SPAM.config.characters["glory_timer"] = {
    name = "",
    desc = [[]],
    var_type = "list",
    default = {},
    hidden = true
}
SPAM.config.characters["gd_start"] = {
    name = "gdcolor_prefisso",
    desc = SPAM.config.globals["gdcolor"].desc,
    var_type = "string",
    default = "",
}
SPAM.config.characters["gd_end"] = {
    name = "gdcolor_suffisso",
    desc = SPAM.config.globals["gdcolor"].desc,
    var_type = "string",
    default = "",
}
SPAM.config.characters["mem_helper"] = {
    name = "mem_helper",
    desc = [[Se sei uno stregone, SPAM può tenere traccia dei cast memmati e mostrarli in uno schermino.
Per abilitare/disabilitare questa funzione usa il comando: <yellow>spam mem_helper on/off<grey>
Per sapere come usare la funzione di automem usa il comando: <yellow>automem aiuto]],
    var_type = "bool",
    default = true,
}
SPAM.config.characters["automem"] = {
    name = "automem",
    desc = [[]],
    var_type = "list",
    default = {},
    hidden = true
}

SPAM.config.load_globals()
SPAM.config.load_characters()

if SPAM.config.get("mapper") then
    enableTrigger("DDE_mapper_Trigger_Group")
    tempTimer(0.5,SPAM.mod_mudlet_mapper)
else
    disableTrigger("DDE_mapper_Trigger_Group")
end

--temporary fix for game bug
SPAM.config.set("hide_immune_shield",false)
--update check
registerAnonymousEventHandler("sysDownloadDone", "SPAM.event_handler")
registerAnonymousEventHandler("sysDownloadError", "SPAM.event_handler")
SPAM.downloading = true
local version_file = "https://raw.githubusercontent.com/mauriliogenovese/SPAM/main/version"
if SPAM.config.get("dev") == true then
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
SPAM.dde_group_container = SPAM.dde_group_container or Adjustable.Container:new({name = "DdE Group"})
SPAM.dde_group_container.name = "DdE Group"
SPAM.dde_group_container:unlockContainer()
SPAM.dde_group_widget =
  SPAM.dde_group_widget or
  Geyser.MiniConsole:new(
    {
      name = "DdE Group",
      x = 0,
      y = 0,
      autoWrap = true,
      color = 'black',
      scrollBar = false,
      fontSize = SPAM.config.get("buff_font_size"),
      width = "100%",
      height = "100%",
    },
    SPAM.dde_group_container
  )
clearWindow("DdE Group")
SPAM.dde_group_widget:echo("\n*** DdE Group Caricato.\n")
SPAM.toggle_dde_group()
-- Contenitore e mini-console per Abbil Chat
SPAM.abbil_chat_container = SPAM.abbil_chat_container or Adjustable.Container:new({name = "Abbil Chat"})
SPAM.abbil_chat_container.name = "Abbil Chat"
SPAM.abbil_chat_container:unlockContainer()
SPAM.abbil_chat_widget =
  SPAM.abbil_chat_widget or
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
    SPAM.abbil_chat_container
  )
clearWindow("Abbil Chat")
SPAM.abbil_chat_widget:echo("\n*** Abbil Chat Caricato.\n")
SPAM.toggle_abbil_chat()
-- Contenitore e mini-console per mem_helper
SPAM.mem_container = SPAM.mem_container or Adjustable.Container:new({name = "MEM Helper"})
SPAM.mem_container.name = "MEM Helper"
SPAM.mem_container:unlockContainer()
SPAM.mem_widget =
  SPAM.mem_widget or
  Geyser.MiniConsole:new(
    {
      name = "MEM Helper",
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
    SPAM.mem_container
  )
clearWindow("MEM Helper")
SPAM.mem_container:hide()
SPAM.mem_widget:echo("\n*** MEM Helper Caricato.\n")
SPAM.class_list = {}
SPAM.class_list["Chierico"] = SPAM.new_class()
SPAM.class_list["Chierico"].buff.dps = {"benedizione", "aiuto divino"}
SPAM.class_list["Chierico"].buff.base = {"santificazione", "volo"}
--SPAM.class_list["Chierico"].self_buff.tank = {"protezione dal bene","protezione dal male","protezione dal fuoco","resistenza elettrica","protezione dalla energia","resistenza risucchio"}
SPAM.class_list["Chierico"].heal = {"cura critiche", "guarigione", "cure leggere continue"}
SPAM.class_list["Chierico"].move = {"nuovo vigore"}
SPAM.class_list["Paladino"] = SPAM.new_class()
SPAM.class_list["Paladino"].buff.dps = {"benedizione"}
SPAM.class_list["Paladino"].self_buff.tank = {"aura benefica", "armatura sacra"}
SPAM.class_list["Paladino"].self_buff.dps = {"crociata", "morale"}
SPAM.class_list["Paladino"].heal = {"imposizione delle mani", "martirio"}
SPAM.class_list["Paladino"].command = "prega"
SPAM.class_list["Oscuro"] = SPAM.new_class()
SPAM.class_list["Oscuro"].self_buff.dps = {"rito oscuro"}
SPAM.class_list["Oscuro"].self_buff.base = {"anima fiammeggiante", "scudo fiammeggiante"}
SPAM.class_list["Oscuro"].command = "prega"
SPAM.class_list["Mago"] = SPAM.new_class()
SPAM.class_list["Mago"].buff.dps = {"forza"}
SPAM.class_list["Mago"].buff.tank = {"scudo", "armatura"}
SPAM.class_list["Mago"].buff.base = {"volo"}
SPAM.class_list["Mago"].self_buff.base = {"scudo infuocato"}
SPAM.class_list["Mago"].self_buff.tank = {"pelle di pietra"}
SPAM.class_list["Mago"].move = {"ristora"}
SPAM.class_list["Stregone"] = SPAM.class_list["Mago"]
SPAM.class_list["Cercatore"] = SPAM.new_class()
SPAM.class_list["Cercatore"].buff.base = {"santificazione", "volo", "agilita felina"}
SPAM.class_list["Cercatore"].buff.dps = {"benedizione", "forza"}
SPAM.class_list["Cercatore"].buff.tank = {"scudo"}
SPAM.class_list["Cercatore"].self_buff.base = {"scudo di ghiaccio", "cuore di naria"}
SPAM.class_list["Cercatore"].heal = {"cura serie", "guarigione", "brezza di naria"}
SPAM.class_list["Cercatore"].move = {"ristora"}
SPAM.class_list["Vampiro"] = SPAM.new_class()
SPAM.class_list["Vampiro"].buff.dps = {"forza"}
SPAM.class_list["Vampiro"].buff.tank = {"scudo", "tenebre"}
SPAM.class_list["Vampiro"].buff.base = {"volo"}
SPAM.class_list["Vampiro"].self_buff.tank = {"pelle demoniaca"}
SPAM.class_list["Druido"] = SPAM.new_class()
SPAM.class_list["Druido"].buff.base = {"volo", "agilita felina"}
SPAM.class_list["Druido"].self_buff.base = {"scudo di ghiaccio", "spirito di naria"}
SPAM.class_list["Druido"].self_buff.tank = {"pelle del drago", "pelle di corteccia"}
SPAM.class_list["Druido"].heal = {"cura critiche", "brezza di naria"}
SPAM.class_list["Druido"].move = {"nuovo vigore"}
SPAM.class_list["Ranger"] = SPAM.new_class()
SPAM.class_list["Ranger"].buff.base = {"agilita felina"}
SPAM.class_list["Ranger"].self_buff.dps = {"ferocia animale"}
SPAM.class_list["Ranger"].self_buff.tank = {"pelle di corteccia"}
SPAM.class_list["Ranger"].heal = {"cura critiche"}
SPAM.class_list["Ranger"].move = {"nuovo vigore"}
SPAM.class_list["Psionico"] = SPAM.new_class()
SPAM.class_list["Psionico"].buff.base = {"levitazione"}
SPAM.class_list["Psionico"].self_buff.base = {"scudo di energia"}
SPAM.class_list["Psionico"].self_buff.dps = {"forza psionica"}
SPAM.class_list["Psionico"].self_buff.tank = {"scudo mentale", "sfera protettiva"}
SPAM.class_list["Psionico"].heal = {"nostrum"}
SPAM.class_list["Psionico"].command = "pensa"
SPAM.class_list["Necromante"] = SPAM.new_class()
SPAM.class_list["Necromante"].buff.base = {"levitazione"}
SPAM.class_list["Necromante"].buff.tank = {"tenebre"}
SPAM.class_list["Necromante"].self_buff.base = {"scudo di ossa"}
SPAM.class_list["Necromante"].self_buff.tank = {"armatura di ombra", "pegno dei vinti"}
SPAM.class_list["Necromante"].command = "evoc"
SPAM.class_list["Necromante"].move = {"ristora"}

SPAM.slots = {}
SPAM.slots["armature"] = {"armatura", "corazza", "corpetto", "tunica", "veste", "cotta", "giacca", "camic"}
SPAM.slots["anelli"] = {"anello","anellino"}
SPAM.slots["armi"] = {"spad", "pugnale", "lama", "mazza", "bastone", "daga", "frusta","bastone","ascia"}
SPAM.slots["bacchette"] = {"bacchetta"}
SPAM.slots["bracciali"] = {"bracciale", "braccialetto", "polsiera"}
SPAM.slots["cinture"] = {"cintura", "cinturone", "fascia"}
SPAM.slots["collane"] = {"collana", "collanina"}
SPAM.slots["elmi"] = {"elmo", "corona", "diadema", "copricapo"}
SPAM.slots["gambali"] = {"pantaloni", "gambali", "cavigliere", "calzoni"}
SPAM.slots["guanti"] = {"guanto"}
SPAM.slots["guardiabraccia"] = {"guardiabraccia", "coprispalle", "spallaccio"}
SPAM.slots["luci"] = {"luce", "sfera"}
SPAM.slots["mantelli"] = {"mantello"}
SPAM.slots["occhiali"] = {"occhiali"}
SPAM.slots["orecchini"] = {"orecchin"}
SPAM.slots["pozioni"] = {"pozione"}
SPAM.slots["protezioni"] = {"protezion"}
SPAM.slots["scudi"] = {"scudo"}
SPAM.slots["stivali"] = {"stivali", "sandali", "scarpe", "calzari"}
SPAM.slots["viso"] = {"maschera"}
SPAM.slots["cibo"] = {"cibo"}

SPAM.party_in_fight = false
SPAM.last_autocast = 0
SPAM.last_command = ""
SPAM.last_command_time = os.time()