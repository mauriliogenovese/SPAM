if SPAM.config.get("compact_room_group") == false then
    return
end

-- Se siamo arrivati al prompt, stampo il riepilogo e resetto
if line:match("^PF:(.+)>$") then
    if SPAM.room_group.present ~= nil and #SPAM.room_group.present > 0 then
        cecho("\n<cyan>GRUPPO PRESENTE: <white>" .. SPAM.string.implode(SPAM.room_group.present, ", "))
        SPAM.room_group.present = nil
    end

    return
end

local member_name = SPAM.room_group.match_member(line)

if member_name == nil then
    return
end

SPAM.room_group.present = SPAM.room_group.present or {}

if SPAM.room_group.present[member_name] == nil then
    table.insert(SPAM.room_group.present, member_name)
    SPAM.room_group.present[member_name] = true
end

deleteLine()