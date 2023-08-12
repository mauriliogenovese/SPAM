if cond[matches[4]]~= nil then
  thiscolor=colors[cond[matches[4]]]
else
  thiscolor="FF33DA"
end

selectString( matches[4], 1 )

setHexFgColor(thiscolor)
resetFormat()