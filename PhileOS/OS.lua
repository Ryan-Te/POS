-- PhileOS Window Manager
-- Made by Ryan with core made by Level
package.path = "PhileOS/APIs/?.lua;"..package.path
if _G.PhileOS ~= nil then
  error("You can't run PhileOS inside itself!")
  while true do
    sleep(1)
  end
end
local oldOSRun = os.run
local oldOSVersion = os.version
local CurrentWindow = nil
_G.PhileOS = {
  clipboard = "",
  openProgram = function() end,
  promptUser = function() end,
  setTopWin = function() end,
  isTopWin = function() end,
  flashAndPrompt = function() end,
  getTermSize = function() end,
  setName = function() end,
  minimize = function() end,
  stop = function() end,
  getMinimized = function() end,
  setPosition = function() end,
  getPosition = function() end,
  setSize = function() end,
  setCustomMode = function() end,
  setCanResize = function() end,
  getName = function() end,
  cutString = function() end,
  centerString = function() end,
  ID = 1234567,
  theme = {"dont use me"},
  settings = {"dont use me"},
}
--_G.os.run = function(env, path, ...)
--  PhileOS.changeName(string.sub(path, #path + 2 - (string.find(string.reverse(path), "/") or #path + 1), string.find(path, "%.") - 1))
--  local out = oldOSRun(env, path, ...)
--  os.sleep()
--  PhileOS.changeName("rom/rollback")
--  return out
--end

_G.os.version = function()
  return _G.OSName.." ".._G.version
end
local windowTable = {}
local oterm = term.current()
buffer = window.create(term.current(),1,1,term.getSize())
buffer.setVisible(false)
local TaskbarC = {}
local TaskbarW = {}
local makePrompt = false

local tf = fs.open("/PhileOS/Themes/.ActualTheme.theme", "r")
local theme = textutils.unserialize(tf.readAll())
tf.close()
local sf = fs.open("/PhileOS/.settings.set", "r")
local settings = textutils.unserialize(sf.readAll())
sf.close() 
local special = {"Explorer", "Exit to shell", "Reboot", "Shutdown"}

local shortcuts = {}

local function cut(str,len,pad)
  pad = pad or " "
  return str:sub(1,len) .. pad:rep(len - #str)
end

local function limit(str,len)
  return str:sub(1,len)
end

_G.createWindow = function(X, Y, Sx, Sy, Program, ...)
  local ID = nil
  while not ID do
    local IDt = math.random(2000000000)
	local used = false
	for num,win in ipairs(windowTable) do
	  if win.ID == IDt then
	    used = true
	  end
	end
	if not used then ID = IDt end
  end
  local ThemeCopy = {}
  for k,v in pairs(theme) do
    ThemeCopy[k] = v
  end
   local SettingsCopy = {}
  for k,v in pairs(settings) do
    SettingsCopy[k] = v
  end
  local env = setmetatable({
    PhileOS = {
      openProgram = function(name, X, Y, Sx, Sy, ...)
	    local six, siy = oterm.getSize()
		if settings.smallTermMode then
		  Sx = Sx or 25
		  Sy = Sy or 9
		else
		  Sx = Sx or 51
		  Sy = Sy or 19
		end
		X = X or six / 2 - math.floor(Sx / 2)
		Y = Y or siy / 2 - math.floor(Sy / 2)
        return createWindow(X, Y, Sx, Sy, name, table.unpack({...}))
      end,
	  promptUser = function(ID, style, prompt, options, Px, Py)
	    local Wx, Wy, WSx, WSy = 6
		local winnum = 0
		local winname = ""
		for num,win in ipairs(windowTable) do
	      if win.ID == ID then Wx, Wy = win.getPosition() WSx, WSy = win.getSize() winnum = num winname = win.name end
	    end
		local Hx = 17.5
		local Hy = 5
		if settings.smallTermMode then
		  Hx = 12.5
		  Hy = 2.5
		end
		local promptID = 0
	    if style == "button2H" then
			promptID = createWindow(Wx + math.floor(WSx / 2 - Hx), Wy + math.floor(WSy / 2 - Hy), 35, 10, "/PhileOS/Dialogs/Button.lua", windowTable[winnum].name, "1", prompt, options[1], options[2])
		elseif style == "button2V" then
			promptID = createWindow(Wx + math.floor(WSx / 2 - Hx), Wy + math.floor(WSy / 2 - Hy), 35, 10, "/PhileOS/Dialogs/Button.lua", windowTable[winnum].name, "2", prompt, options[1], options[2])
		elseif style == "button4" then
			promptID = createWindow(Wx + math.floor(WSx / 2 - Hx), Wy + math.floor(WSy / 2 - Hy), 35, 10, "/PhileOS/Dialogs/Button.lua", windowTable[winnum].name, "3", prompt, options[1], options[2], options[3], options[4])
		elseif style == "error" then
			promptID = createWindow(Wx + math.floor(WSx / 2 - Hx), Wy + math.floor(WSy / 2 - Hy), 35, 10, "/PhileOS/Dialogs/error.lua", windowTable[winnum].name, winname, prompt, options)
		elseif style == "r-click" then
			promptID = createWindow(Wx - 1 + Px, Wy - 1 + Py, 1, 1, "/PhileOS/Dialogs/RClick.lua", table.unpack(options))
		elseif style == "text" then
			promptID = createWindow(Wx + math.floor(WSx / 2 - Hx), Wy + math.floor(WSy / 2 - Hy), 35, 10, "/PhileOS/Dialogs/Text.lua", windowTable[winnum].name, prompt, options[1])
		else return false end
		local tempwin = windowTable[winnum]
		table.remove(windowTable, winnum)
		table.insert(windowTable,tempwin)
		return promptID
	  end,
	  setTopWin = function(ID, IDtt)
		if ID ~= windowTable[#windowTable].ID then return false end
		for num,win in ipairs(windowTable) do
	      if win.ID == IDtt then 
		    local tempwin = windowTable[num]
			table.remove(windowTable, num)
			table.insert(windowTable,tempwin)
			return true
		  end
	    end
	  end,
	  isTopWin = function(ID)
	    if ID ~= windowTable[#windowTable].ID then return false else return true end
      end,
	  flashAndPrompt = function(ID, PromptID)
	    if ID ~= windowTable[#windowTable].ID then return false end
		local win = windowTable[#windowTable]
		win.CM = true
		sleep(0.1)
		win.CM = false
		sleep(0.1)
		win.CM = true
		sleep(0.1)
		win.CM = false
		sleep(0.1)
		for num,win in ipairs(windowTable) do
	      if win.ID == PromptID then 
		    local tempwin = windowTable[num]
			table.remove(windowTable, num)
			table.insert(windowTable,tempwin)
			return true
		  end
	    end
	  end,
	  getTermSize = function()
		return oterm.getSize()
	  end,
	  setName = function(ID, Name)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then win.name = Name end
	    end
	  end,
	  getName = function(ID)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then return win.name end
	    end
	  end,
	  minimize = function(ID)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then win.state = "Mini" end
	    end
	  end,
	  stop = function(ID)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then table.remove(windowTable, num) end
	    end
	  end,
	  getMinimized = function(ID)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then return win.state == "Mini" end
	    end
	  end,
	  setPosition = function(ID, Nx, Ny)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then win.reposition(Nx, Ny) end
	    end
	  end,
	  getPosition = function(ID)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then return win.getPosition() end
	    end
	  end,
	  getSize = function(ID)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then return win.getSize() end
	    end
	  end,
	  setSize = function(ID, Nx, Ny)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then 
		    local Sx, Sy = win.getPosition() 
			if Nx < 6 then Nx = 6 end
			if Ny < 1 then Ny = 1 end
			win.reposition(Sx, Sy, Nx, Ny) 
		  end
	    end
	  end,
	  setCanResize = function(ID, CR)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then win.CR = CR end
	    end
	  end,
	  setCustomMode =  function(ID, CM)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then win.CM = CM end
	    end
	  end,
	  setTaskbarIcon =  function(ID, TB)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then win.TB = TB end
	    end
	  end,
	  cutString = function(str,len,pad, nddd)
        pad = pad or " "
        return str:sub(1,len) .. pad:rep(len - #str)
      end,
	  centerString = function(str,len, nddd)
	    if not nddd then
          if #str > len then str = str:sub(1, len - 3).."..." end
		end
		local sta = len - #str
        return (string.rep(" ", math.floor(sta / 2))..str..string.rep(" ", math.ceil(sta / 2)))
      end,
	  limitString = function(str, len)
	    return str:sub(1,len)
	  end,
	  getStatus = function(ID)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then return win.status end
	    end
	  end,
	  setStatus = function(ID, newStatus)
	    for num,win in ipairs(windowTable) do
	      if win.ID == ID then win.status = newStatus end
	    end
	  end,
	  ID = ID,
	  theme = ThemeCopy,
	  settings = SettingsCopy,
    }
  }, {__index = _ENV})
  local fn, err = loadfile(Program, nil, env)
  table.insert(windowTable, window.create(term.current(),math.floor(X),math.floor(Y),math.floor(Sx),math.floor(Sy),false))
  windowTable[#windowTable].name = string.sub(Program, #Program + 2 - (string.find(string.reverse(Program), "/") or #Program + 1), string.find(Program, "%.") - 1)
  windowTable[#windowTable].started = false
  windowTable[#windowTable].Arg = {...}
  windowTable[#windowTable].cor = coroutine.create(function(...) if not fn then printError(err) while true do sleep(1) end end  local ok,err = pcall(fn, table.unpack({...})) if not ok then 
    local six, siy = oterm.getSize()
	if err ~= "Terminated" then
	term.clear()
	term.setCursorPos(1, 1)
    printError(err)
	PhileOS.setName(PhileOS.ID, "Error!")
	while true do sleep(1) end
	end
  end end)
  local name = string.sub(Program, #Program + 2 - (string.find(string.reverse(Program), "/") or #Program + 1), string.find(Program, "%.") - 1)
  windowTable[#windowTable].oNames = {}
  windowTable[#windowTable].state = "Normal"
  windowTable[#windowTable].ID = ID
  windowTable[#windowTable].CR = true
  windowTable[#windowTable].CM = false
  windowTable[#windowTable].TB = true
  windowTable[#windowTable].status = ""
  return ID
end
createWindow(1, 1, 1, 1, "/PhileOS/sleep.lua")
windowTable[#windowTable].CM = true
windowTable[#windowTable].TB = false
local bgid = windowTable[1].ID
local startID = false
local Sxe, Sye = oterm.getSize()
local Ex = 49
local Ey = 17
if settings.smallTermMode then
  Ex = 32
  Ey = 9
end
createWindow(Sxe / 2 - math.floor(Ex / 2), Sye / 2 - math.floor(Ey / 2), Ex, Ey, "/PhileOS/explorer.lua")

local function render()
  --if theme ~= _G.PhileOS.theme then _G.PhileOS.theme = theme end
  local Sx, Sy = oterm.getSize()
  --local TaskbarB = ""
  --local TaskbarT = ""
  term.setBackgroundColor(theme.BackgroundColour)
  term.clear()
  TaskbarC = {}
  TaskbarW = {}
  for num,win in ipairs(windowTable) do
    local x,y = win.getPosition()
    local w,h = win.getSize()
	if win.CM ~= true and win.state == "Normal" then
      if num == #windowTable then
        term.setBackgroundColor(theme.ActiveTitleBarColour) -- or whatever color u want the border
        term.setTextColor(theme.ActiveNameColour) -- or whatever color u want the button text
      else
        term.setBackgroundColor(theme.InactiveTitleBarColour)
        term.setTextColor(theme.InactiveNameColour)
      end
      -- draw top bar
      term.setCursorPos(x-1,y-1) -- set cursor position one to the left and one above the windows top left corner
      term.write(string.rep(" ",w+2))
      -- draw buttons
	  term.setCursorPos(x+w-6,y-1)
	  if win.CR == true then
        if num == #windowTable then
          term.setTextColor(theme.ActiveMinimizeButtonColour)
        else
          term.setTextColor(theme.InactiveMinimizeButtonColour)
        end
        term.write(" -")
		term.setCursorPos(x+w-4,y-1)
        if num == #windowTable then
          term.setTextColor(theme.ActiveMaximizeButtonColour)
        else
          term.setTextColor(theme.InactiveMaximizeButtonColour)
        end
        term.write(" +")
	  elseif win.CR == false then
	    if num == #windowTable then
          term.setTextColor(theme.ActiveMinimizeButtonColour)
        else
          term.setTextColor(theme.InactiveMinimizeButtonColour)
        end
        term.write("   -")
	  end
	  term.setCursorPos(x+w-2,y-1)
      if num == #windowTable then
        term.setTextColor(theme.ActiveCloseButtonColour)
      else
        term.setTextColor(theme.InactiveCloseButtonColour)
      end
      term.write(" × ")
	  -- draw more buttons if u want
	  -- draw title
	  local buttonroom = 4
	  if win.CR == true then buttonroom = 6 end
	  if win.CR == "both" then buttonroom = 2 end
	  term.setCursorPos(x,y-1)
	  term.write(cut(win.name, w - buttonroom))
	  if num == #windowTable then
        term.setBackgroundColor(theme.ActiveBorderColour)
      else
        term.setBackgroundColor(theme.InactiveBorderColour)
      end
	  for t=1,h do -- for each line in the window do
		term.setCursorPos(x-1,y+(t-1))
		term.write(" ") -- left border
		term.blit(win.getLine(t)) -- screen contents of this line
	    term.write(" ") -- right border
	  end
	  term.setCursorPos(x-1,y+h)
	  term.write(string.rep(" ",w+2))
	elseif win.state == "Normal" then
	  for t=1,h do -- for each line in the window do
	    term.setCursorPos(x,y-1+(t))
	    term.blit(win.getLine(t)) -- screen contents of this line
	  end
	end
	if settings.smallTermMode and win.TB then
	  table.insert(TaskbarC, limit(win.name, 4))
	  table.insert(TaskbarW, num)
    elseif win.TB then
	  table.insert(TaskbarC, limit(win.name, 14))
	  table.insert(TaskbarW, num)
	end
  end
  if settings.smallTermMode then
    term.setBackgroundColor(theme.TaskbarColour)
	term.setTextColor(theme.TaskbarTimeColour)
	term.setCursorPos(1, Sy)
	term.write(cut("POS", Sx - 5))
	local cursorx = 5
	for i, v in pairs(TaskbarC) do
	  if i == #TaskbarC and windowTable[#windowTable].ID ~= bgid then
	    term.setBackgroundColor(theme.MinimizedWindowColour)
	    term.setTextColor(theme.TaskbarTextColour)
	  end
	  term.setCursorPos(cursorx, Sy)
	  term.write(v)
	  cursorx = cursorx + #v + 1
	end
	term.setCursorPos(Sx - 5, Sy)
	term.setBackgroundColor(theme.TaskbarColour)
	term.write(" ")
  elseif settings.interface == "button" then
    term.setBackgroundColor(theme.TaskbarColour)
	term.setTextColor(theme.BackgroundColour)
	term.setCursorPos(Sx - 10, Sy - 1)
	term.write(string.char(135))
    term.setBackgroundColor(theme.TaskbarColour)
	term.setTextColor(theme.TaskbarTimeColour)
	term.setCursorPos(1, Sy)
	term.write(cut("PhileOS", Sx - 10))
	local cursorx = 9
	for i, v in pairs(TaskbarC) do
	  if i == #TaskbarC and windowTable[#windowTable].ID ~= bgid  then
	    term.setBackgroundColor(theme.MinimizedWindowColour)
	    term.setTextColor(theme.TaskbarTextColour)
	  end
	  term.setCursorPos(cursorx, Sy)
	  term.write(v)
	  cursorx = cursorx + #v + 1
	end
	term.setBackgroundColor(theme.TaskbarColour)
	term.setCursorPos(Sx - 10, Sy)
	term.write(" ")
  else
    term.setBackgroundColor(theme.TaskbarColour)
	term.setTextColor(theme.TaskbarTimeColour)
	term.setCursorPos(1, Sy - 1)
	term.write(cut(" ", Sx - 10))
	term.setCursorPos(1, Sy)
	term.write(cut(" ", Sx - 10))
	local cursorx = 1
	for i, v in pairs(TaskbarC) do
	  if i == #TaskbarC and windowTable[#windowTable].ID ~= bgid  then
	    term.setBackgroundColor(theme.MinimizedWindowColour)
	    term.setTextColor(theme.TaskbarTextColour)
	  end
	  term.setCursorPos(cursorx, Sy)
	  term.write(v)
	  cursorx = cursorx + #v + 1
	end
	local cursorx = 1
	term.setBackgroundColor(theme.TaskbarColour)
	term.setTextColor(theme.TaskbarTimeColour)
	for i = #special, 1, -1 do
	  term.setCursorPos(cursorx, Sy - 1)
	  term.write(special[i])
	  cursorx = cursorx + #special[i] + 2
	end
	cursorx = cursorx - 1
	term.setCursorPos(cursorx, Sy - 1)
	term.write("|")
	cursorx = cursorx + 2
	for i = #shortcuts, 1, -1 do
	  term.setCursorPos(cursorx, Sy - 1)
	  term.write(shortcuts[i])
	  cursorx = cursorx + #shortcuts[i] + 2
	end
	term.setBackgroundColor(theme.TaskbarColour)
	term.setCursorPos(Sx - 10, Sy - 1)
	term.write(" ")
	term.setCursorPos(Sx - 10, Sy)
	term.write(" ")
  end
  term.setBackgroundColor(theme.TaskbarColour)
  term.setTextColor(theme.TaskbarTimeColour)
  local tim = ""
  local dat = ""
  if settings.timemode == "I" and not settings.smallTermMode then
    local igt = os.time("ingame")
	local hours = math.floor(igt)
	local minutes = math.floor((igt - hours) * 60)
	if minutes < 10 then minutes = "0"..minutes end
	local APM = "AM"
	if hours > 11 then APM = "PM" hours = hours - 12 end
	hours = hours + 1
	if #tostring(hours) == 1 then
	  tim = hours..":"..minutes.." "..APM.." IG"
	else
	  tim = hours..":"..minutes..APM.." IG"
	end
	local igd = os.day("ingame")
	local day = igd % 365
	day = day - 1
	local year = (igd - day) / 365
	if year < 10 then year = "0"..year end
	day = cut(tostring(day + 1), 3)
	dat = "D:"..day.." Y:"..string.sub(year, 1, 2)
  elseif settings.timemode == "I24" then
    local igt = os.time("ingame")
	local hours = math.floor(igt)
	local minutes = math.floor((igt - hours) * 60)
	if minutes < 10 then minutes = "0"..minutes end
	if hours < 10 then hours = "0"..hours end
	if settings.smallTermMode then
	  tim = hours..":"..minutes
	else
	  tim = hours..":"..minutes.."   IG"
	end
	local igd = os.day("ingame")
	local day = igd % 365
	day = day - 1
	local year = (igd - day) / 365
	if year < 10 then year = "0"..year end
	day = cut(tostring(day + 1), 3)
	dat = "D:"..day.." Y:"..string.sub(year, 1, 2)
  elseif settings.timemode == "ID" and not settings.smallTermMode then
    local igt = os.time("ingame")
	local hours = math.floor(igt)
	local minutes = math.floor((igt - hours) * 60)
	if minutes < 10 then minutes = "0"..minutes end
	local APM = "AM"
	if hours > 11 then APM = "PM" hours = hours - 12 end
	hours = hours + 1
	if #tostring(hours) == 1 then
	  tim = hours..":"..minutes.." "..APM.." IG"
	else
	  tim = hours..":"..minutes..APM.." IG"
	end
	local igd = os.day("ingame")
	dat = "D:"..cut(tostring(igd), 8)
  elseif settings.timemode == "ID24" and not settings.smallTermMode then
    local igt = os.time("ingame")
	local hours = math.floor(igt)
	local minutes = math.floor((igt - hours) * 60)
	if minutes < 10 then minutes = "0"..minutes end
	if hours < 10 then hours = "0"..hours end
	tim = hours..":"..minutes.."   IG"
	local igd = os.day("ingame")
	dat = "D:"..cut(tostring(igd), 8)
  elseif settings.timemode == "R" and not settings.smallTermMode then
    local utc = os.epoch("utc") / 1000
	local lt = utc + (settings.timezone * 3600)
	if os.date("*t", utc).isdst then lt = lt + 3600 end
	local hour = os.date("!%I", lt)
	local timezone = settings.timezone
	if timezone == -8 then timezone = "PT"
	elseif timezone == -7 then timezone = "MT"
	elseif timezone == -6 then timezone = "CT"
	elseif timezone == -5 then timezone = "ET"
	elseif timezone == -10 then timezone = "-X"
	elseif timezone == -11 then timezone = "-E"
	elseif timezone == -12 then timezone = "-T"
	elseif timezone == 0 then timezone = "GM" 
	elseif timezone == 1 then timezone = "CE"
	elseif timezone > 1 and timezone < 10 then timezone = "+"..timezone
	end
	if tonumber(hour) < 10 then
	  tim = os.date("!"..tonumber(hour)..":%M %p "..timezone, lt)
	else
	  tim = os.date("!"..hour..":%M%p "..timezone, lt)
	end
	dat = os.date("!%m/%d/%Y", lt)
  elseif settings.timemode == "R24" then
    local utc = os.epoch("utc") / 1000
	local lt = utc + (settings.timezone * 3600)
	if os.date("*t", utc).isdst then lt = lt + 3600 end
	local timezone = settings.timezone
	if timezone == -8 then timezone = "PT"
	elseif timezone == -7 then timezone = "MT"
	elseif timezone == -6 then timezone = "CT"
	elseif timezone == -5 then timezone = "ET"
	elseif timezone == -10 then timezone = "-X"
	elseif timezone == -11 then timezone = "-E"
	elseif timezone == -12 then timezone = "-T"
	elseif timezone == 0 then timezone = "GM" 
	elseif timezone == 1 then timezone = "CE"
	elseif timezone > 1 and timezone < 10 then timezone = "+"..timezone
	end
	if settings.smallTermMode then
	  tim = os.date("!%H:%M", lt)
	else
	  tim = os.date("!%H:%M   "..timezone, lt)
	end
	dat = os.date("!%m/%d/%Y", lt)
  elseif not settings.smallTermMode then
    tim = "ERROR: NO "
	dat = "TIME MODE "
  else
    tim = "ERROR"
  end
  if not settings.smallTermMode then
    term.setCursorPos(Sx - 9, Sy - 1)
    term.write(tim)
    term.setCursorPos(Sx - 9, Sy)
    term.write(dat)
  else
    term.setCursorPos(Sx - 4, Sy)
    term.write(tim)
  end
  
  local tWin =  windowTable[#windowTable]
  if tWin.getCursorBlink() then
    local cX,cY = tWin.getCursorPos()
	local WSx, WSy = tWin.getSize()
    local wX,wY = tWin.getPosition()
    term.setCursorPos(wX+(cX-1),wY+(cY-1))
    term.setTextColor(tWin.getTextColor())
	if cX > WSx or cY > WSy or cX < 1 or cY < 1 then term.setCursorBlink(false) else term.setCursorBlink(true) end
  else
    term.setCursorBlink(false)
  end
end

local bWin
local GetNewBWin = true
local winToDel = nil
local priority = {["key"]=true,["key_up"]=true,["char"]=true,["paste"]=true,["terminate"]=true}
local mouseDiff = {0, 0}
local resize = nil
local drag = true
local GlobalwinsMinied = 0
local wintopoen = nil
local function update()
  local Sx, Sy = oterm.getSize()
  if wintopoen ~= nil then
    local six, siy = oterm.getSize()
	local Sx = 0
	local Sy = 0
	if settings.smallTermMode then
	  Sx = 25
	  Sy = 9
	else
	  Sx = 51
	  Sy = 19
	end
	X = X or six / 2 - math.floor(Sx / 2)
	Y = Y or siy / 2 - math.floor(Sy / 2)
    createWindow(X, Y, Sx, Sy, wintopoen)
	wintopoen = nil
  end
  if makePrompt and startID == false then
    local startbl = {table.unpack(shortcuts), false, table.unpack(special)}
    startID = createWindow(1, Sy - #startbl - 1, 1, 1, "/PhileOS/Dialogs/RClick.lua", table.unpack(startbl))
	windowTable[#windowTable].CM = true
	windowTable[#windowTable].TB = false
	makePrompt = false
  elseif makePrompt then
    for num,win in ipairs(windowTable) do
	  if win.ID == startID then table.remove(windowTable, num) startID = false end
    end
    makePrompt = false
  elseif startID ~= false then
    if windowTable[#windowTable].ID == startID then
	  if windowTable[#windowTable].status ~= "" then
	    local option = windowTable[#windowTable].status
		local se = false
		if option == "Shutdown" then
		  os.shutdown()
	    elseif option == "Reboot" then
		  os.queueEvent("filler")
		  os.queueEvent("char", "P")
		  os.queueEvent("char", "O")
		  os.queueEvent("char", "S")
		  os.queueEvent("key", keys.enter)
		  windowTable = {}
		elseif option == "Exit to shell" then
		  windowTable = {}
		elseif option == "Explorer" then
		  se = true
		end
		if #windowTable ~= 0 then table.remove(windowTable, num) end
		if se then
		  local Ex = 49
          local Ey = 17
          if settings.smallTermMode then
            Ex = 32
            Ey = 9
		  end
          createWindow(Sx / 2 - math.floor(Ex / 2), Sy / 2 - math.floor(Ey / 2), Ex, Ey, "/PhileOS/explorer.lua")
		end
		startID = false
	  end
	else
	  for num,win in ipairs(windowTable) do
	    if win.ID == startID then table.remove(windowTable, num) startID = false end
      end
	end
  end
  if winToDel ~= nil then
      GetNewBWin = true
      table.remove(windowTable, #windowTable)
	  bWin = nil
	  winToDel = nil
  end
  local e = table.pack(os.pullEventRaw())
  local tWin
  for num,win in ipairs(windowTable) do
    local resume = false
    local x,y = win.getPosition()
    local w,h = win.getSize()
    if num == #windowTable or not priority[e[1]] then
      if string.find(e[1],"mouse") then
        if type(e[3]) == "number" and type(e[4]) == "number" then
          if e[4] >= Sy - 1 and not settings.smallTermMode then -- If you click the taskbar in big term mode then
		    if num == #windowTable and e[1] == "mouse_click" then
		      local px = e[3]
			  if settings.interface == "button" then 
			    px = px - 8
				if px <= 1 then
			      makePrompt = true
			    end
			  elseif e[4] == Sy - 1 then
			    local px2 = e[3]
				for i = #special, 1, -1 do
			      px2 = px2 - #special[i]
				  if px2 < 1 then
				    local option = special[i]
		            local se = false
		            if option == "Shutdown" then
		              os.shutdown()
	                elseif option == "Reboot" then
		              os.queueEvent("filler")
		              os.queueEvent("char", "P")
		              os.queueEvent("char", "O")
		              os.queueEvent("char", "S")
		              os.queueEvent("key", keys.enter)
		              windowTable = {}
		            elseif option == "Exit to shell" then
		              windowTable = {}
		            elseif option == "Explorer" then
		              wintopoen = "/PhileOS/explorer.lua"
		            end
			        break
				  end
				  px2 = px2 - 2
				  if px2 < 1 then px2 = 1000000 end
			    end
			  end
			  if e[4] == Sy then
			    for i, v in pairs(TaskbarC) do
			      px = px - #v
				  if px < 1 then
				    local num = TaskbarW[i]
				    windowTable[num].state = "Normal"
				    local tempwin = windowTable[num]
				    table.remove(windowTable, num)
				    table.insert(windowTable, tempwin)
			        break
				  end
			    end
			  end
			end
		  elseif e[4] >= Sy and settings.smallTermMode then -- If you click the taskbar in small term mode then
		    if num == #windowTable and e[1] == "mouse_click" then
			  px = e[3] - 4
			  if px <= 1 then
			    makePrompt = true
			  else
			    for i, v in pairs(TaskbarC) do
			      px = px - #v
				  if px < 1 then
				    local num = TaskbarW[i]
				    windowTable[num].state = "Normal"
				    local tempwin = windowTable[num]
				    table.remove(windowTable, num)
				    table.insert(windowTable, tempwin)
			        break
				  end
			    end
			  end
			end
		  elseif e[3] >= x and e[4] >= y and e[3] <= x+(w-1) and e[4] <= y+(h-1) and win.state == "Normal" then -- checks if the mouse event is within the window
            tWin = win
            tWin.n = num
		  elseif e[3] >= x - 1 and e[4] >= y - 1 and e[3] <= x+(w) and e[4] <= y+(h) and GetNewBWin and win.state == "Normal" and not win.CM then
		    bWin = win
			bWin.n = num
          end
        else
          resume = true
        end
      else
        resume = true
      end
      if resume and not (win.sFilter and win.sFilter ~= e[1] and (e[1] ~= "terminate" or win.state == "Mini")) then
        term.redirect(win.cWin or win)
		CurrentWindow = num
		if win.started then
          status, win.sFilter = coroutine.resume(win.cor,table.unpack(e))
		else
		  local numwin = #windowTable
		  status, win.sFilter = coroutine.resume(win.cor,table.unpack(win.Arg))
		  if numwin == #windowTable then windowTable[num].started = true end
		end
		CurrentWindow = nil
        if term.current() ~= win then
          win.cWin = term.current()
        else
          win.cWin = nil
        end
        term.redirect(buffer)
	  end
	  if coroutine.status(win.cor) == "dead" then
        table.remove(windowTable,num)
	  end
    end
  end
  if GetNewBWin and bWin ~= nil then
    GetNewBWin = false
  end
  local vvt = 0
  if tWin then
    vvt = tWin.n
  end
  if bWin and bWin.n >= vvt then
    local x,y = bWin.getPosition()
	local w,h = bWin.getSize()
	local Sx, Sy = oterm.getSize()
    if e[1] == "mouse_click" then
	  if bWin.n < #windowTable then
        table.remove(windowTable,bWin.n)
        table.insert(windowTable,bWin)
        -- moves window to top
      end
	  drag = true
	  if e[3] == x+w-1 and e[4] == y-1 then -- X button
	    winToDel = bWin.n
      elseif e[3] == x+w-3 and e[4] == y-1 and bWin.CR == true then -- Maximize
		drag = false
      elseif e[3] == x+w-5 and e[4] == y-1 and bWin.CR == true then -- Minimize
	    bWin.state = "Mini"
		GlobalwinsMinied = GlobalwinsMinied + 1
		os.queueEvent("term_resize")
		--for num,win in ipairs(windowTable) do
	    --  if win.ID == bgid then 
		--    local miniwin = windowTable[num]
		--    table.remove(windowTable, num)
        --    table.insert(windowTable, miniwin)
		--  end
	    --end
		local miniwin = windowTable[bWin.n]
		table.remove(windowTable, bWin.n)
        table.insert(windowTable, 1, miniwin)
	  elseif e[3] == x+w-3 and e[4] == y-1 and bWin.CR == false then -- Minimize
	    bWin.state = "Mini"
		GlobalwinsMinied = GlobalwinsMinied + 1
		os.queueEvent("term_resize")
		--for num,win in ipairs(windowTable) do
	    --  if win.ID == bgid then 
		--    local miniwin = windowTable[num]
		--	table.remove(windowTable, num)
        --    table.insert(windowTable, miniwin)
		--  end
	    --end
		local miniwin = windowTable[bWin.n]
		table.remove(windowTable, bWin.n)
        table.insert(windowTable, 1, miniwin)
	  elseif e[3] == x+w and e[4] == y+h and bWin.CR and bWin.state ~= "Mini" then -- Start Resizing
	    resize = "BR"
	  elseif e[3] == x-1 and e[4] == y-1 and bWin.CR and bWin.state ~= "Mini" then -- Start Resizing
	    resize = "TL"
		mouseDiff = {x, y, w, h}
	  elseif e[3] == x+w and e[4] == y-1 and bWin.CR and bWin.state ~= "Mini" then -- Start Resizing
	    resize = "TR"
		mouseDiff = {x, y, w, h}
	  elseif e[3] == x-1 and e[4] == y+h and bWin.CR and bWin.state ~= "Mini" then -- Start Resizing
	    resize = "BL"
		mouseDiff = {x, y, w, h}
	  else
	    mouseDiff = {e[3] - x, e[4] - y}
		resize = nil
	  end
	elseif e[1] == "mouse_drag" then --
	  if resize == nil and bWin.state ~= "Mini" then -- Drag
	    if drag then
		  if bWin.oldSize then
		    local xpos = math.floor(bWin.oldSize[3] / 2)
			if xpos < 1 then xpos = 1 end
			if xpos > Sx - bWin.oldSize[3] then xpos = Sx - bWin.oldSize[3] end
		   bWin.reposition(xpos, e[4] - 2, bWin.oldSize[3], bWin.oldSize[4])
		    local x,y = bWin.getPosition()
	        local w,h = bWin.getSize()
		   mouseDiff = {x, y, w, h}
		   bWin.oldSize = nil
		   drag = true
		  end
	      bWin.reposition(e[3] - mouseDiff[1], e[4] - mouseDiff[2])
		end
	  elseif resize == "BR" and bWin.state ~= "Mini"  then -- Resizing
	    local NSx = e[3] - x
		local NSy = e[4] - y
		if NSx < 10 then NSx = 10 end
		if NSy < 5 then NSy = 5 end
	    bWin.reposition(x, y, NSx, NSy)
	  elseif resize == "TL" and bWin.state ~= "Mini"  then -- Resizing
	    local NSx = mouseDiff[3] + (e[3] - mouseDiff[1] + 1) * -1
		local NSy = mouseDiff[4] + (e[4] - mouseDiff[2] + 1) * -1
		local NX = e[3] + 1
		local NY = e[4] + 1
		if NSx < 10 then NSx = 10; NX = mouseDiff[1] + mouseDiff[3] - 10 end
		if NSy < 5 then NSy = 5; NY = mouseDiff[2] + mouseDiff[4] - 5 end
	    bWin.reposition(NX, NY, NSx, NSy)
	  elseif resize == "BL"  and bWin.state ~= "Mini" then -- Resizing
	    local NSx = mouseDiff[3] + (e[3] - mouseDiff[1] + 1) * -1
		local NSy = e[4] - y
		local NX = e[3] + 1
		if NSx < 10 then NSx = 10; NX = mouseDiff[1] + mouseDiff[3] - 10 end
		if NSy < 5 then NSy = 5 end
	    bWin.reposition(NX, y, NSx, NSy)
	  elseif resize == "TR" and bWin.state ~= "Mini"  then -- Resizing
	    local NSx = e[3] - x
		local NSy = mouseDiff[4] + (e[4] - mouseDiff[2] + 1) * -1
		local NX = e[3] + 1
		local NY = e[4] + 1
		if NSx < 10 then NSx = 10 end
		if NSy < 5 then NSy = 5; NY = mouseDiff[2] + mouseDiff[4] - 5 end
	    bWin.reposition(x, NY, NSx, NSy)
	  end
	  if resize ~= nil and bWin.state ~= "Mini"  then os.queueEvent("term_resize") end -- Resizing
	elseif e[1] == "mouse_up" then
	  if e[3] == x+w-3 and e[4] == y-1 and bWin.CR == true then -- Maximize
	    if bWin.oldSize == nil then -- If the window isnt maximized
		  bWin.oldSize = {x, y, w, h}
		  local overhead = 3
		  if settings.smallTermMode then overhead = 2 end
	      bWin.reposition(1, 2, Sx, Sy - overhead)
		else -- If the window is maximized
	      bWin.reposition(table.unpack(bWin.oldSize))
		  bWin.oldSize = nil
		end
	  end
	  bWin = nil
	  GetNewBWin = true
	end
  end
  local vvt = 0
  if bWin then
    vvt = bWin.n
  end
  if tWin and tWin.n >= vvt then
    if e[1] == "mouse_click" then
      if tWin.n < #windowTable then
        table.remove(windowTable,tWin.n)
        table.insert(windowTable,tWin)
        -- moves window to top
      end
    end
    if e[1] ~= "mouse_up" then
      local x,y = tWin.getPosition()
      e[3] = e[3]-(x-1)
      e[4] = e[4]-(y-1)
      term.redirect(tWin.cWin or tWin)
	  CurrentWindow = num
      status, tWin.sFilter = coroutine.resume(tWin.cor,table.unpack(e))
	  CurrentWindow = nil
      if term.current() ~= tWin then
        tWin.cWin = term.current()
      else
        tWin.cWin = nil
      end
      term.redirect(buffer)
    end
  end
end
term.redirect(buffer)
os.startTimer(0.1)
render()
update()
render()
term.redirect(oterm)
buffer.setVisible(true)
buffer.setVisible(false)
windowTable[1].xVel = 1
windowTable[1].yVel = 1
while #windowTable ~= 0 do
  buffer.reposition(1,1,term.getSize())
  term.redirect(buffer)
  update()
  if #windowTable ~= 0 then
    render()
  end
  term.redirect(oterm)
  term.setCursorBlink(false)
  local w,h = buffer.getSize()
  for y=1,h do -- for each line on the screen do
    term.setCursorPos(1,y) -- set cursor pos at the right place
    term.blit(buffer.getLine(y)) -- draw that line on the screen
  end
  term.setCursorBlink(buffer.getCursorBlink()) -- so that it will blink when the user is typing
  term.setTextColor(buffer.getTextColor()) -- so the cursor will blink in the proper color
  term.setCursorPos(buffer.getCursorPos()) -- so the cursor will blink in the proper place
  local Cx, Cy = term.getCursorPos()
  local Sx, Sy = term.getSize()
  if #windowTable > 0 then
    if (Cy >= Sy - 1 and not settings.smallTermMode) or (Cy >= Sy and settings.smallTermMode) or windowTable[#windowTable].state == "Mini" then term.setCursorBlink(false) end
  end
end
_G.PhileOS = nil
_G.os.run = oldOSRun
_G.os.version = oldOSVersion
term.redirect(oterm)
term.setBackgroundColor(colours.black)
term.clear()
term.setCursorPos(1, 1)