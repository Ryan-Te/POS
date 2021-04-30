PhileOS.setCanResize(PhileOS.ID, "both")
package.path = "/PhileOS/APIs/?.lua;"..package.path
local UI = require("UI")
local args = {...}
PhileOS.setName(PhileOS.ID, args[1])
term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
term.setTextColour(PhileOS.theme.DefaultTextColour)
PhileOS.setTaskbarIcon(PhileOS.ID, false)
if PhileOS.settings.smallTermMode == false then
	if args[2] == "1" then
		PhileOS.setSize(PhileOS.ID, 35, 10)
		term.setCursorPos(1, 1)
		print(PhileOS.cutString(args[3], 105))
		term.setCursorPos(1, 10)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[4], 17).." "..PhileOS.centerString(args[5], 17))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		term.setCursorPos(18, 10)
		term.write(" ")
		while true do
			local e = table.pack(os.pullEvent())
			if e[1] == "mouse_click" and e[4] == 10 then
				if e[3] < 18 then PhileOS.setStatus(PhileOS.ID, args[4]) end
				if e[3] > 18 then PhileOS.setStatus(PhileOS.ID, args[5]) end
			end
		end
	elseif args[2] == "2" then
		PhileOS.setSize(PhileOS.ID, 35, 10)
		term.setCursorPos(1, 1)
		print(PhileOS.cutString(args[3], 105))
		term.setCursorPos(1, 8)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[4], 35))
		term.setCursorPos(1, 10)
		term.write(PhileOS.centerString(args[5], 35))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		while true do
			local e = table.pack(os.pullEvent())
			if e[1] == "mouse_click" then
				if e[4] == 8 then PhileOS.setStatus(PhileOS.ID, args[4]) end
				if e[4] == 10 then PhileOS.setStatus(PhileOS.ID, args[5]) end
			end
		end
	elseif args[2] == "3" then
		PhileOS.setSize(PhileOS.ID, 35, 10)
		term.setCursorPos(1, 1)
		print(PhileOS.cutString(args[3], 105))
		term.setCursorPos(1, 8)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[4], 17).." "..PhileOS.centerString(args[5], 17))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		term.setCursorPos(18, 8)
		term.write(" ")
		term.setCursorPos(1, 10)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[6], 17).." "..PhileOS.centerString(args[7], 17))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		term.setCursorPos(18, 10)
		term.write(" ")
		while true do
			local e = table.pack(os.pullEvent())
			if e[1] == "mouse_click" and e[4] == 8 then
				if e[3] < 18 then PhileOS.setStatus(PhileOS.ID, args[4]) end
				if e[3] > 18 then PhileOS.setStatus(PhileOS.ID, args[5]) end
			elseif e[1] == "mouse_click" and e[4] == 10 then
				if e[3] < 18 then PhileOS.setStatus(PhileOS.ID, args[6]) end
				if e[3] > 18 then PhileOS.setStatus(PhileOS.ID, args[7]) end
			end
		end
	else 
		PhileOS.stop(PhileOS.ID) 
		--print("wut")
		--sleep(5)
	end
else
	if args[2] == "1" then
		PhileOS.setSize(PhileOS.ID, 25, 5)
		term.setCursorPos(1, 1)
		print(PhileOS.cutString(args[3], 50))
		term.setCursorPos(1, 5)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[4], 12).." "..PhileOS.centerString(args[5], 12))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		term.setCursorPos(13, 5)
		term.write(" ")
		while true do
			local e = table.pack(os.pullEvent())
			if e[1] == "mouse_click" and e[4] == 5 then
				if e[3] < 13 then PhileOS.setStatus(PhileOS.ID, args[4]) end
				if e[3] > 13 then PhileOS.setStatus(PhileOS.ID, args[5]) end
			end
		end
	elseif args[2] == "2" then
		PhileOS.setSize(PhileOS.ID, 25, 5)
		term.setCursorPos(1, 1)
		print(PhileOS.cutString(args[3], 50))
		term.setCursorPos(1, 3)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[4], 25))
		term.setCursorPos(1, 5)
		term.write(PhileOS.centerString(args[5], 25))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		while true do
			local e = table.pack(os.pullEvent())
			if e[1] == "mouse_click" then
				if e[4] == 3 then PhileOS.setStatus(PhileOS.ID, args[4]) end
				if e[4] == 5 then PhileOS.setStatus(PhileOS.ID, args[5]) end
			end
		end
	elseif args[2] == "3" then
		PhileOS.setSize(PhileOS.ID, 25, 5)
		term.setCursorPos(1, 1)
		print(PhileOS.cutString(args[3], 50))
		term.setCursorPos(1, 3)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[4], 12).." "..PhileOS.centerString(args[5], 12))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		term.setCursorPos(13, 3)
		term.write(" ")
		term.setCursorPos(1, 5)
		term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
		term.write(PhileOS.centerString(args[6], 12).." "..PhileOS.centerString(args[7], 12))
		term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
		term.setCursorPos(13, 5)
		term.write(" ")
		while true do
			local e = table.pack(os.pullEvent())
			if e[1] == "mouse_click" and e[4] == 3 then
				if e[3] < 13 then PhileOS.setStatus(PhileOS.ID, args[4]) end
				if e[3] > 13 then PhileOS.setStatus(PhileOS.ID, args[5]) end
			elseif e[1] == "mouse_click" and e[4] == 5 then
				if e[3] < 13 then PhileOS.setStatus(PhileOS.ID, args[6]) end
				if e[3] > 13 then PhileOS.setStatus(PhileOS.ID, args[7]) end
			end
		end
	else 
		PhileOS.stop(PhileOS.ID) 
		--print("wut")
		--sleep(5)
	end
end