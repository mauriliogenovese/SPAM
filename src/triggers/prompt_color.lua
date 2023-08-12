max=tonumber(matches[3])
current=tonumber(matches[2])
ratio=current/max
selectString( matches[2], 1 )
if ratio==1 then fg("green")
elseif ratio>0.9 then setFgColor(51, 204, 51)
elseif ratio>0.7 then setFgColor(115, 230, 0)
elseif ratio>0.4 then fg("yellow")
elseif ratio>0.2 then setFgColor(255, 153, 0)
else fg("red") end
resetFormat()