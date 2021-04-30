local function Display(startX, startY, sizeX, sizeY, bgColour, fgColour, text, mode, bol)
	if bol == nil or bol then
		if sizeX == "Auto" then
			sizeX = string.len(text[1])
		end
		local offsetX = startX
		local offsetY = startY
		if mode == "BR" then
			offsetY = offsetY + (sizeY - #text)
		end
		if mode == "MD" then
			offsetY = offsetY + math.floor((sizeY - #text) / 2)
		end
		paintutils.drawFilledBox(startX, startY, startX + sizeX - 1, startY + sizeY - 1, bgColour)
		term.setTextColour(fgColour)
		for i = 1,sizeY do
			offsetX = startX
			if mode == "BR" then
				offsetX = startX + (sizeX - #text[i])
			end
			if mode == "MD" then
				offsetX = startX + math.floor((sizeX - #text[i]) / 2)
			end
			term.setCursorPos(offsetX, offsetY)
			term.write(text[i])
			offsetY = offsetY + 1
		end
	end
end
return { Display = Display }
