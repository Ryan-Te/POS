PhileOS.setCanResize(PhileOS.ID, "both")
package.path = "/PhileOS/APIs/?.lua;"..package.path
local UI = require("UI")
local args = {...}
PhileOS.setName(PhileOS.ID, args[1])
term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
term.setTextColour(PhileOS.theme.DefaultTextColour)
local reed = nil
if not PhileOS.settings.smallTermMode then
	PhileOS.setSize(PhileOS.ID, 35, 10)
	PhileOS.setTaskbarIcon(PhileOS.ID, false)
	term.setCursorPos(1, 1)
	print(PhileOS.cutString(args[2], 105))
	term.setCursorPos(1, 10)
	term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
	term.write(string.rep(" ", 35))
	term.setCursorPos(1, 10)
	reed = args[3]
	local pos = #args[3] + 1
	local update = true
	while true do
	local e = table.pack(os.pullEvent())
	if update then
		term.setCursorBlink(false)
		term.setCursorPos(1, 10)
		term.write(PhileOS.cutString(reed, 35))
		update = false
		term.setCursorBlink(true)
	end
	term.setCursorPos(pos, 10)
	if e[1] == "key" then
		if e[2] == keys.enter then break
		elseif e[2] == keys.backspace and #reed > 0 then reed = string.sub(reed, 1, pos - 2)..string.sub(reed, pos) pos = pos - 1 update = true
		elseif e[2] == keys.left and pos > 1 then pos = pos - 1
		elseif e[2] == keys.right and pos <= #reed then pos = pos + 1
		end
	elseif e[1] == "char" then
		reed = string.sub(reed, 1, pos - 1)..e[2]..string.sub(reed, pos)
		pos = pos + 1
		update = true
	end
	end
else
	PhileOS.setSize(PhileOS.ID, 25, 5)
	PhileOS.setTaskbarIcon(PhileOS.ID, false)
	term.setCursorPos(1, 1)
	print(PhileOS.cutString(args[2], 75))
	term.setCursorPos(1, 5)
	term.setBackgroundColour(PhileOS.theme.DefaultHighlighedBackgroundColour)
	term.write(string.rep(" ", 25))
	term.setCursorPos(1, 5)
	reed = args[3]
	local pos = #args[3] + 1
	local update = true
	while true do
	local e = table.pack(os.pullEvent())
	if update then
		term.setCursorBlink(false)
		term.setCursorPos(1, 5)
		term.write(PhileOS.cutString(reed, 25))
		update = false
		term.setCursorBlink(true)
	end
	term.setCursorPos(pos, 5)
	if e[1] == "key" then
		if e[2] == keys.enter then break
		elseif e[2] == keys.backspace and #reed > 0 then reed = string.sub(reed, 1, pos - 2)..string.sub(reed, pos) pos = pos - 1 update = true
		elseif e[2] == keys.left and pos > 1 then pos = pos - 1
		elseif e[2] == keys.right and pos <= #reed then pos = pos + 1
		end
	elseif e[1] == "char" then
		reed = string.sub(reed, 1, pos - 1)..e[2]..string.sub(reed, pos)
		pos = pos + 1
		update = true
	end
	end
end
PhileOS.setStatus(PhileOS.ID, reed)
sleep(1)
