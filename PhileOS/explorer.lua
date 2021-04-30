--while true do
--  term.clear()
--  term.setCursorPos(1, 1)
--  print("Program to open:")
--  local program = read()
--  if fs.exists(program) then
--    PhileOS.openProgram(program)
--  else
--	term.setCursorPos(1, 3)
--    printError("that is not a valid program, try again")
--	sleep(0.5)
--  end
--end
if not PhileOS then
  error("This Program Requires PhileOS To Run")
end
if not PhileOS.settings.smallTermMode then
  PhileOS.setSize(PhileOS.ID, 49, 17)
else
  PhileOS.setSize(PhileOS.ID, 32, 9)
end

package.path = "/PhileOS/APIs/?.lua;"..package.path
local UI = require("UI")

local function cut(str,len,pad)
  pad = pad or " "
  if #str > len then str = str:sub(1, len - 3).."..." end
  return str:sub(1,len) .. pad:rep(len - #str)
end
local fsnew = function(file)
  assert(fs.open(file,"w")).close()
end
local args = {...}
local dir = args[1] or "/"
local sf = fs.open("/PhileOS/.sysFiles.set", "r")
local sysFiles = textutils.unserialize(sf.readAll())
sf.close()

local function RClickMenu(answers, X, Y)
	local PromptID = PhileOS.promptUser(PhileOS.ID, "r-click", nil, answers, X, Y)
	sleep()
	PhileOS.setTopWin(PhileOS.ID, PromptID)
	local result = ""
	while result == "" do
		result = PhileOS.getStatus(PromptID)
		if PhileOS.isTopWin(PhileOS.ID) then result = nil end
		sleep()
	end
	PhileOS.stop(PromptID)
	return result
end

local function Dialog(style, prompt, answers)
	local PromptID = PhileOS.promptUser(PhileOS.ID, style, prompt, answers)
	sleep()
	PhileOS.setTopWin(PhileOS.ID, PromptID)
	local result = ""
	while result == "" do
		PhileOS.flashAndPrompt(PhileOS.ID, PromptID) -- Optional
		result = PhileOS.getStatus(PromptID)
		sleep()
	end
	PhileOS.stop(PromptID)
	return result
end

--Name:22, File Type: 8, Size:5, Modifcation Date:10
local function DrawFile (PosX, PosY, File, sel)
  local colour = PhileOS.theme.DefaultBackgroundColour
  if sel then colour = PhileOS.theme.DefaultHighlighedBackgroundColour end
  local textC =  PhileOS.theme.DefaultTextColour
  local isSysFile = false
  for _, v in pairs(sysFiles) do
    if File == v then isSysFile = true break end
  end
  if fs.isReadOnly(File) or isSysFile then textC = PhileOS.theme.DefaultNATextColour end
  if fs.isReadOnly(File) then isSysFile = true end
  local name = fs.getName(File)
  local ext = "File"
  if string.find(name, "%.") then
    ext = name
	while string.find(ext, "%.") do
	  ext = string.sub(ext, string.find(ext, "%.") + 1)
	end
  end
  local atts = nil
  pcall(function()
  atts = fs.attributes(File)
  end)
  UI.Display(PosX, PosY, "Auto", 1, colour, textC, {cut(name, 22).." "})
  local typ = ext
  if fs.isDir(File) then
    typ = "Folder"
  end
  UI.Display(PosX + 23, PosY, "Auto", 1, colour, textC, {cut(typ, 8).." "})
  local size = fs.getSize(File)
  if size < 10000 then
    size = string.rep(" ", 4 - #tostring(size))..size.."B"
  elseif size < 100000 then
    size = " "..string.sub(size, 1, 2).."KB"
  elseif size < 1000000 then
    size = string.sub(size, 1, 3).."KB"
  elseif size < 10000000 then
    size = string.sub(size, 1, 1).."."..string.sub(size, 2, 1).."MB"
  elseif size < 100000000 then
    size = " "..string.sub(size, 1, 2).."MB"
  elseif size < 1000000000 then
    size = string.sub(size, 1, 3).."MB"
  end
  if not fs.isDir(File) then
    UI.Display(PosX + 32, PosY, "Auto", 1, colour, textC, {size.." "})
  else
    UI.Display(PosX + 32, PosY, "Auto", 1, colour, textC, {"      "})
  end 
  if atts then
    if atts.modified then
      local mod = atts.modified / 1000
      UI.Display(PosX + 38, PosY, "Auto", 1, colour, textC, {os.date("%Y-%m-%d", mod)})
    else
      UI.Display(PosX + 38, PosY, "Auto", 1, colour, textC, {"       N/A"})
    end
  end
  return isSysFile
end

local buttons = {"New Folder", "New File", "Rename", "Delete", "Grab", "Plop"}
local scroll = 0
local Sx, Sy = term.getSize()
local grabbed = {}
 
local function DrawDir(Dir, selected)
  local folder = fs.list(Dir)
  if selected > #folder then selected = 0 end
  local dirs = {}
  local files = {}
  local isSysFile = {}
  for i, v in pairs(folder) do
    if fs.isDir(Dir..v) then
	  table.insert(dirs, v)
	else
	  table.insert(files, v)
	end
  end
  for i, v in pairs(dirs) do
    local sel = false
    if i == selected then sel = true end
    local isf = DrawFile(1, i + 3 - scroll, Dir..v, sel)
	table.insert(isSysFile, isf)
  end
  for i, v in pairs(files) do
    local sel = false
    if i + #dirs == selected then sel = true end
    local isf = DrawFile(1, i + 3 + #dirs - scroll, Dir..v, sel)
	table.insert(isSysFile, isf)
  end
  term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
  term.setCursorPos(1, #folder + 4)
  term.write("                                                ")
  term.setTextColour(PhileOS.theme.DefaultTextColour)
  term.setCursorPos(1, 1)
  term.write(cut(Dir, Sx - 3).." "..string.char(171))
  term.setCursorPos(1, 2)
  term.write("Name                   Type     Size  Modified  ")
  term.setCursorPos(1, 3)
  term.write("------------------------------------------------")
  paintutils.drawBox(Sx, 1, Sx, Sy, PhileOS.theme.DefaultBackgroundColour)
  term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
  return dirs, files, isSysFile
end

term.setBackgroundColour(PhileOS.theme.DefaultBackgroundColour)
term.clear()
local selectd = 0
local selold = 0
local click = 0
local errtime = 1
local ft = fs.open("/PhileOS/filetypes.lua", "r")
local programs = textutils.unserialize(ft.readAll())
local redraw = true
local dirs = {}
local files = {}
ft.close()
while true do
  Sx, Sy = term.getSize()
  if not fs.isDir(dir) then dir = "/" redraw = true end
  if redraw then
    sleep()
	dirs, files, isSysFile = DrawDir(dir, selectd)
	redraw = false
  end
  local e = table.pack(os.pullEvent())
  term.setCursorPos(1, 20)
  local oldc = click
  if e[1] == "mouse_click" then
    if e[4] > 3  and e[3] ~= Sx then
	  if e[2] < 3 then
	    if selectd <= #dirs and selectd ~= 0 then
			DrawFile(1, selectd + 3 - scroll, dir..dirs[selectd], false)
			term.setCursorPos(Sx, selectd + 3 - scroll)
		elseif selectd <= #dirs + #files and selectd ~= 0 then
			DrawFile(1, selectd + 3 - scroll, dir..files[selectd - #dirs], false)
		end
	    selectd = e[4] - 3 + scroll
		redraw = true
		if selold ~= selectd then click = 0 end
		click = click + 1
		if click == 1 then
		  os.startTimer(1)
		  selold = selectd
		end
		if click >= 2 and e[2] == 1 then
		  if selectd <= #dirs then
		    dir = dir..dirs[selectd].."/"
			redraw = true
			term.clear()
			click = 0
			scroll = 0
		  elseif selectd <= #dirs + #files then
		    local name = fs.getName(files[selectd - #dirs])
			local ext = "File"
			if string.find(name, "%.") then
				ext = string.sub(name, string.find(name, "%.") + 1)
			end
			if programs[ext] then
			  if programs[ext] == "/rom/execute" then
			    PhileOS.openProgram(dir..files[selectd - #dirs], nil, nil, 51, 19)
			  else
			    PhileOS.openProgram(programs[ext], nil, nil, 51, 19, dir..files[selectd - #dirs])
			  end
			end
		  end
		end
	  end
	end
	if e[3] == Sx then selectd = 0 end
	if e[2] == 1 and e[3] == Sx - 1 and e[4] == 1 then
      index = string.find(dir, "/[^/]*$")
	  index = string.find(string.sub(dir, 1, index - 1), "/[^/]*$")
	  dir = string.sub(dir, 1, index)
	  redraw = true
	  click = 0
	  scroll = 0
	  term.clear()
	end
	if e[2] == 2 then
	  if selectd <= #dirs and selectd ~= 0 then
	    DrawFile(1, selectd + 3 - scroll, dir..dirs[selectd], true)
		local result = nil
		if isSysFile[selectd] then
		  result = RClickMenu({"Open", "Open in new window", "Pin to ??? (NF)"}, e[3], e[4])
		else
		  result = RClickMenu({"Open", "Open in new window", "Pin to ??? (NF)", false, "Cut", "Copy", false, "Rename", "Delete", "Move to Bin (NF)"}, e[3], e[4])
		end
		if result == "Open" then
		  dir = dir..dirs[selectd].."/"
		  redraw = true
		  term.clear()
		  click = 0
		  scroll = 0
		elseif result == "Open in new window" then
		  PhileOS.openProgram("/PhileOS/explorer.lua", nil, nil, 49, 17, dir..dirs[selectd].."/")
		elseif result == "Copy" then
		  _G.PhileOS.clipboard = "FileCopy://"..dir..dirs[selectd]..";"..dirs[selectd]
		elseif result == "Cut" then
		  _G.PhileOS.clipboard = "FileCut://"..dir..dirs[selectd]..";"..dirs[selectd]
		elseif result == "Rename" then
		  local newName = nil
		  while newName == nil do
		    result = Dialog("text", "New Name For Folder?", {dirs[selectd]}) -- Text input dialog prompt
		    newName = result
		  end
		  fs.move(dir..dirs[selectd], dir..newName)
		  redraw = true
		elseif result == "Delete" then
		  local delQ = nil
		  while delQ == nil do
		    result = Dialog("button2H", "Do you really want to PERMANENTLY delete "..dirs[selectd].."?", {"Yes", "No"}) 
		    delQ = result
		  end
		  if delQ == "Yes" then fs.delete(dir..dirs[selectd]) end
		end
	  elseif selectd <= #dirs + #files and selectd ~= 0 then
	    DrawFile(1, selectd + 3 - scroll, dir..files[selectd - #dirs], true)
		local result = nil
		if isSysFile[selectd] then
		  result = RClickMenu({"Run","Open with", "Pin to ??? (NF)"}, e[3], e[4])
		else
		  result = RClickMenu({"Run","Open with", "Pin to ??? (NF)", false, "Cut", "Copy", false, "Rename", "Delete", "Move to Bin (NF)"}, e[3], e[4])
	    end
		if result == "Run" then
		  PhileOS.openProgram(dir..files[selectd - #dirs])
		elseif result == "Open with" then
		  local done = false
		  while not done do
		  local program = nil
		  while program == nil do
		    result = Dialog("text", "Program to open with?", {""}) -- Text input dialog prompt
		    program = result
		  end
		  if fs.exists(program) then
		    PhileOS.openProgram(program, nil, nil, nil, nil, dir..files[selectd - #dirs])
			done = true
		  else
		    result = Dialog("error", "That file doesn't exist!")
			if result ~= "Try again" then done = true end
		  end
		  end
		elseif result == "Copy" then
		  _G.PhileOS.clipboard = "FileCopy://"..dir..files[selectd - #dirs]..";"..files[selectd - #dirs]
		elseif result == "Cut" then
		  _G.PhileOS.clipboard = "FileCut://"..dir..files[selectd - #dirs]..";"..files[selectd - #dirs]
		elseif result == "Rename" then
		  local newName = nil
		  while newName == nil do
		    result = Dialog("text", "New Name For File?", {files[selectd - #dirs]}) -- Text input dialog prompt
		    newName = result
		  end
		  fs.move(dir..files[selectd - #dirs], dir..newName)
		  redraw = true
		elseif result == "Delete" then
		  local delQ = nil
		  while delQ == nil do
		    result = Dialog("button2H", "Do you really want to PERMANENTLY delete "..files[selectd - #dirs].."?", {"Yes", "No"}) 
		    delQ = result
		  end
		  if delQ == "Yes" then fs.delete(dir..files[selectd - #dirs]) end
		end
	  else
	    local result = RClickMenu({"Refresh", false, "Paste", false, "New Folder", "New File"}, e[3], e[4])
		if result == "Refresh" then
		 redraw = true
		elseif result == "Paste" then
		  local clipboard = _G.PhileOS.clipboard
		  if clipboard:sub(1, 11) == "FileCopy://" then
		    if not fs.exists(dir..clipboard:sub(clipboard:find(";") + 1)) then
		      fs.copy(clipboard:sub(12, clipboard:find(";") - 1), dir..clipboard:sub(clipboard:find(";") + 1))
			else Dialog("error", "File "..clipboard:sub(clipboard:find(";") + 1).." already exists in destination folder!", false) end
	      elseif clipboard:sub(1, 10) == "FileCut://" then
		    if not fs.exists(dir..clipboard:sub(clipboard:find(";") + 1)) then
  		      fs.copy(clipboard:sub(11, clipboard:find(";") - 1), dir..clipboard:sub(clipboard:find(";") + 1))
			  fs.delete(clipboard:sub(11, clipboard:find(";") - 1))
			else Dialog("error", "File "..clipboard:sub(clipboard:find(";") + 1).." already exists in destination folder!", false) end
		  else result = Dialog("error", "Clipboard does not contain file", false)
		  end
		elseif result == "New Folder" then
		  local newName = nil
		  while newName == nil do
		    result = Dialog("text", "Name For New Folder?", {"New Folder"}) -- Text input dialog prompt
			if newName ~= nil then
			  if fs.exists(dir..newName) then Dialog("error", "File "..newName.." already exists in folder!", false)  newName = nil end
		    end
			newName = result
		  end
		  fs.makeDir(dir..newName)
		  redraw = true
		elseif result == "New File" then
		  local newName = nil
		  while newName == nil do
		    result = Dialog("text", "Name For New File?", {"New File"}) -- Text input dialog prompt
			if newName ~= nil then
		      if fs.exists(dir..newName) then Dialog("error", "File "..newName.." already exists in folder!", false)  newName = nil end
			end
			newName = result
		  end
		  fsnew(dir..newName)
		  redraw = true
		end
	  end
	end
  end
  if e[1] == "mouse_scroll" then
    scroll = scroll + e[2]
	redraw = true
	local Sx, Sy = term.getSize()
	if scroll > #dirs + #files - (Sy - 3) then scroll = #dirs + #files - (Sy - 3) end
	if scroll < 0 then scroll = 0 end
  end
  if e[1] == "term_resize" then
    redraw = true
  end
  if click == oldc and e[1] ~= "mouse_up" then click = 0 end
 end