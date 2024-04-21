if SPAM.config.get("aka")==true and SPAM.config.get("aka_list")[string.lower(matches[4])] ~= nil then
    cecho("\t<royal_blue>".. SPAM.string.first_upper(SPAM.config.get("aka_list")[string.lower(matches[4])]))
end