if SPAM.config.get("abbrevia_allineamento") and SPAM.alignment[matches[1]] ~= nil then
    selectString( matches[1], 1 )
    replace(SPAM.alignment[matches[1]])
end