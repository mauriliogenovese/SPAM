if matches[1] == "" then
  setTriggerStayOpen("clipboard", 0)
  setClipboardText(string2clipboard)
else
  string2clipboard = string2clipboard .. matches[1] .. "\n"
end