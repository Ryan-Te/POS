package.path = "/PhileOS/APIs/?.lua;"..package.path
local UI = require("UI")
local args = {...}
PhileOS.setCustomMode(PhileOS.ID, true)
PhileOS.setSize(PhileOS.ID, 22, #args + 2)
PhileOS.setTaskbarIcon(PhileOS.ID, false)
local Px, Py = PhileOS.getPosition(PhileOS.ID)
local Sx, Sy = PhileOS.getSize(PhileOS.ID)
local Ox, Oy = PhileOS.getTermSize(PhileOS.ID)
if(Px + Sx > Ox) then Px = Ox - Sx + 1 end
local tbw = 2
if PhileOS.settings.smallTermMode == true or PhileOS.settings.interface == "button" then tbw = 1 end
if(Py + Sy > Oy - tbw) then Py = Oy - Sy - (tbw - 1) end
PhileOS.setPosition(PhileOS.ID, Px, Py)
term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
term.clear()
paintutils.drawBox(1, 1, Sx, Sy, PhileOS.theme.ActiveBorderColour)
term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
term.setTextColour(PhileOS.theme.DefaultTextColour)
for i, v in pairs(args) do
  term.setCursorPos(2, i + 1)
  if v == false then term.write(string.rep("-", 20))
  else term.write(PhileOS.cutString(v, 20)) end
end

while true do
  local e = table.pack(os.pullEvent())
  if e[1] == "mouse_click" and e[3] ~= 1 and e[3] ~= 22 and e[4] ~= 1 and e[4] ~= #args + 2 and args[e[4] - 1] ~= false then
    PhileOS.setStatus(PhileOS.ID, args[e[4] - 1])
  end
end