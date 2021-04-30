-- OS Password Program By Ryan
-- Uses sha256 pbkdf2 hash with salt
-- Call it with no arguments to log in, With "makeuser" and A user type (Admin, User, Guest) to make an account. edit pass.word to delete an account
-- Read the "perm" varaible to find out which type of user is logged in
-- IMPORTANT!!! FOR CREATING USERS TO WORK, YOU HAVE TO HAVE "{}" OR ANOTHER SERIALISED TABLE IN "pass.word" OR ELSE IT WONT WORK!!!

--Prevent the user from terminating the program
local oldevent = os.pullEvent
os.pullEvent = os.pullEventRaw
package.path = "/PhileOS/APIs/?.lua;"..package.path

--Setup
local UI = require("/"..OSName.."/APIs/UI")
local sha256 = require("/"..OSName.."/APIs/sha256")
local termexit = false
local args = {...}
local newperm = 1
local Sx, Sy = term.getSize()
local Hx = Sx / 2
local Hy = Sy / 2
function passcheck(user, pass, someTable)
  if someTable[user] then
    tbl = someTable[user]
    local passHash = sha256.pbkdf2(pass,tbl.salt,tbl.iter)
    local passHex = passHash:toHex()
    if passHex == tbl.hash then
      return true, tbl.permlvl
    end
  end
  return false
end
function makepass(pass, iter)
  local salt = randomString(32, 48, 127) 
  local passHash = sha256.pbkdf2(pass, salt, iter)
  local passHex = passHash:toHex()
  return passHex, salt
end
function randomString(length, Si, Ei)
  local ret = ""
  for i = 1,length do
    ret = ret..string.char(math.random(Si, Ei))
  end
  return ret
end

--Let the user exit to the terminal
if args[1] == "makeuser" == false then
  term.setBackgroundColor(colors.black)
  term.clear()
  UI.Display(1, 1, 10, 1, colours.black, colors.red, {"Press Ctrl + T to exit to terminal"})
  UI.Display(Hx, Hy, "Auto", 1, colours.black, colors.white, {OSName}, "MD")
  UI.Display(1, Sy, "Auto", 1, colours.black, colors.white, {"Made by Ryan"})
  os.startTimer(3)
  running = true
  while running do
      event = os.pullEvent()
      if event == "terminate" or event == "timer" then
          running = false
      end
	  if event == "term_resize" then
	    local Sx, Sy = term.getSize()
        local Hx = Sx / 2
        local Hy = Sy / 2
		term.setBackgroundColor(colors.black)
        term.clear()
        UI.Display(1, 1, 10, 1, colours.black, colors.red, {"Press Ctrl + T to exit to terminal"})
        UI.Display(Hx, Hy, "Auto", 1, colours.black, colors.white, {OSName}, "MD")
        UI.Display(1, Sy, "Auto", 1, colours.black, colors.white, {"Made by Ryan"})
	  end
  end
  if event == "terminate" then
      termexit = true
  end
end
term.clear()
if args[1] == "makeuser" == false then
  --error("Hello!")
  UI.Display(1, 1, "Auto", 2, colours.black,  colours.white, {OSName, version})
else
  if args[2] == "Admin" or args[2] == "User" or args[2] == "Guest" then
    UI.Display(1, 1, "Auto", 1, colours.black, colours.white, {"New "..args[2].." Account Setup"})
	if args[2] == "User" then
	  newperm = 2
	end
	if args[2] == "Admin" then
	  newperm = 3
	end
  else
	term.clear()
	term.setCursorPos(1, 1)
    error("Invalid user type!")
  end
end
if termexit then
    UI.Display(Sx - 15,1, "Auto", 1, colors.black, colors.green, {"Exit To Terminal"}, "BR")
end

--Enter Password
perm = 0
while perm == 0 do
    Sx, Sy = term.getSize()
	Hx = Sx / 2
    Hy = Sy / 2
    paintutils.drawFilledBox(1, 3, Sx, Sy)
    term.setTextColour(colors.white)
    term.setCursorPos(Hx - 10, Hy - 2)
    print("Username:")
    term.setCursorPos(Hx - 10,Hy - 1)
    local user = read()
    term.setCursorPos(Hx - 10, Hy + 1)
    print("Password:")
    term.setCursorPos(Hx - 10, Hy + 2)
    local pass = read("*")
	local pass2 = nil
	if args[1] == "makeuser" then
	  term.setCursorPos(Hx - 10, Hy + 4)
	  print("Repeat Password:")
      term.setCursorPos(Hx - 10, Hy + 5)
      pass2 = read("*")
	end
    local pwf = fs.open("/pass.word", "r")
    local passwords = pwf.readAll()
    pwf.close()
    passwords = textutils.unserialise(passwords)
	if args[1] == "makeuser" == false then
	  local passch, permlvl = passcheck(user, pass, passwords)
	  if passch == true then
	    perm = permlvl
	  else
	    term.setCursorPos(Hx - 10, Hy + 6)
        print("Incorrect Username Or Password")
        sleep(2)
	  end
	else
	  if pass == pass2 then
	    local hash, salt = makepass(pass, 100)
	    passwords[user] = {hash = hash, salt = salt, iter = 100, permlvl = newperm}
		local pwf = fs.open("/pass.word", "w")
		pwf.write(textutils.serialise(passwords))
		pwf.close()
	    perm = newperm
	  else
	    term.setCursorPos(Hx - 10, Hy + 6)
        print("Passwords don't match!!")
        sleep(2)
	  end
	end
end
if not termexit and args[1] ~= "makeuser" then
  os.pullEvent = oldevent
  shell.run("/"..OSName.."/OS.lua")
end

--Add back the ability to terminate programs
os.pullEvent = oldevent

term.clear()
term.setCursorPos(1, 1)