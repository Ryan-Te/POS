PhileOS.setCanResize(PhileOS.ID, "both")
package.path = "/PhileOS/APIs/?.lua;"..package.path
local UI = require("UI")
local args = {...}
PhileOS.setName("Error!")
if not PhileOS.settings.smallTermMode then
	term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
	PhileOS.setSize(PhileOS.ID, 35, 10)
	PhileOS.setTaskbarIcon(PhileOS.ID, false)
	term.setCursorPos(1, 1)
	term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
	term.write(PhileOS.cutString("There was an Error in "..args[2]..": ", 35))
	term.setCursorPos(1, 2)
	term.setTextColour(colours.red)
	print(PhileOS.cutString(args[3], 70))
	term.setCursorPos(1, 10)
	term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
	term.setTextColour(PhileOS.theme.DefaultTextColour)
	if args[4] ~= false then
	term.write(PhileOS.centerString("Ok", 17).." "..PhileOS.centerString("Try again", 17))
	else
	term.write(PhileOS.centerString("Ok", 17))
	end
	term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
	term.setCursorPos(18, 10)
	term.write(" ")
	while true do
		local e = table.pack(os.pullEvent())
		if e[1] == "mouse_click" and e[4] == 10 then
			if e[3] < 18 then PhileOS.setStatus(PhileOS.ID, "Ok") end
			if e[3] > 18 and args[4] ~= false then PhileOS.setStatus(PhileOS.ID, "Try again") end
		end
	end
else
	term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
	PhileOS.setSize(PhileOS.ID, 25, 5)
	PhileOS.setTaskbarIcon(PhileOS.ID, false)
	term.setCursorPos(1, 1)
	term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
	term.write(PhileOS.cutString("There was an Error in "..args[2]..": ", 25))
	term.setCursorPos(1, 2)
	term.setTextColour(colours.red)
	print(PhileOS.cutString(args[3], 50))
	term.setCursorPos(1, 5)
	term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
	term.setTextColour(PhileOS.theme.DefaultTextColour)
	if args[4] ~= false then
	term.write(PhileOS.centerString("Ok", 12).." "..PhileOS.centerString("Try again", 12))
	else
	term.write(PhileOS.centerString("Ok", 12))
	end
	term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
	term.setCursorPos(13, 5)
	term.write(" ")
	while true do
		local e = table.pack(os.pullEvent())
		if e[1] == "mouse_click" and e[4] == 5 then
			if e[3] < 13 then PhileOS.setStatus(PhileOS.ID, "Ok") end
			if e[3] > 13 and args[4] ~= false then PhileOS.setStatus(PhileOS.ID, "Try again") end
		end
	end
end
