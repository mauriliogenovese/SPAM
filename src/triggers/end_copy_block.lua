setTriggerStayOpen("clipboard_copy_block", 0)
setClipboardText(string2clipboard)

if persistent_variables["config"]["auto_send"] == true and string.find(matches[1], "oggetto") then
    local parsed = parse_ident(string2clipboard)
    local sql = ident_to_query(parsed)
    send_ident_to_db(sql)
end