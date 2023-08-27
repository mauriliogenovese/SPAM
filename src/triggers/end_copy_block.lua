setTriggerStayOpen("clipboard_copy_block", 0)
setClipboardText(SPAM.string2clipboard)

if SPAM.config.get("auto_send") == true and string.find(matches[1], "oggetto") then
    local parsed = SPAM.parse_ident(SPAM.string2clipboard)
    local sql = SPAM.ident_to_query(parsed)
    SPAM.send_ident_to_db(sql)
end