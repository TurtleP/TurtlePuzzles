function settings_load()
	for i, v in pairs(menugui) do
		v.active = false
	end
	settingsgui = {}
	settingsgui["maintab"] = gui:new("button", 25*scale, 25*scale, 45 * scale, 25*scale, "MAIN", mainopen, nil, false)
	settingsgui["controlstab"] = gui:new("button", 75*scale, 25*scale, 85* scale, 25*scale, "CONTROLS", controlsopen, nil, false)
	settingsgui["cheatstab"] = gui:new("button", 165*scale, 25 * scale, 60 * scale, 25 * scale, "CHEATS", cheatsopen, nil, false)
	settingsgui["storetab"] = gui:new("button", 230*scale, 25 * scale, 55 * scale, 25 * scale, "STORE", storeopen, nil, false)
	settingsgui["achievetab"] = gui:new("button", 290*scale, 25 * scale, 75 * scale, 25 * scale, "ACHIEVES", achievements, nil, false)
	settingsgui["controlstab"].backgroundcolor = {50, 50, 50}
	settingsgui["maintab"].backgroundcolor = {50, 50, 50}
	settingsgui["cheatstab"].backgroundcolor = {50, 50, 50}
	settingsgui["storetab"].backgroundcolor = {50, 50, 50}
	settingsgui["achievetab"].backgroundcolor = {50, 50, 50}
	local text
	if audioon then
		text = "ON"
	else
		text = "OFF"
	end
	coins = love.graphics.newImage("graphics/turtlecoins.png")
		coinsquads = {}
		for i = 1, 4 do
			coinsquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, 67, 16)
		end
	h = 0
	 timer = 0
	if oldsprites then
		text2 = "OLD"
	else
		text2 = "NEW"
	end
	achievegui = {}
	settingsgui["default"] = gui:new("button", 215 * scale, 57.5 * scale, 140 * scale, 32 * scale, "RESTORE DEFAULTS", makesettingsdefault, nil, false)
	settingsgui["audio"] = gui:new("button", 150 * scale, 57.5 * scale, 50 * scale, 25 * scale, text, switchaudio, nil, true)
	settingsgui["exitbutton"] = gui:new("button", 25 * scale, 200 * scale, 345 * scale, 25 * scale, "RETURN TO MENU", exit_settings, nil, true)
	settingsgui["addvolume"] = gui:new("button", 175 * scale, 137.5 * scale, 16 * scale, 25 * scale, "+", changevolume, {true}, true)
	settingsgui["minusvolume"] = gui:new("button", 125 * scale, 137.5 * scale, 16 * scale, 25 * scale, "-", changevolume, {false}, true)
	settingsgui["addplayer"] = gui:new("button", 175 * scale, 57.5 * scale, 16 * scale, 15 * scale, "+", changeplayers, {true}, true)
	settingsgui["minusplayer"] = gui:new("button", 125 * scale, 57.5 * scale, 16 * scale, 15 * scale, "-", changeplayers, {false}, true)
	settingsgui["leftkey"] = gui:new("button", 200 * scale, 82.5 * scale, 100 * scale, 16 * scale, string.upper(leftcontrol[1]), openkey, {"left", leftcontrol[1]}, true)
	settingsgui["rightkey"] = gui:new("button", 200 * scale, 115 * scale, 100 * scale, 16 * scale, string.upper(rightcontrol[1]), openkey, {"right", rightcontrol[1]}, true)
	settingsgui["upkey"] = gui:new("button", 200 * scale, 182.5 * scale, 100 * scale, 16 * scale, string.upper(upcontrol[1]), openkey, {"up", upcontrol[1]}, true)
	settingsgui["downkey"] = gui:new("button", 200 * scale, 150 * scale, 100 * scale, 16 * scale, string.upper(downcontrol[1]), openkey, {"down", downcontrol[1]}, true)
	settingsgui["addhat"] = gui:new("button", 175*scale, 105*scale, 16 * scale, 25 * scale, "+", add_hat, {true}, true)
	settingsgui["minushat"] = gui:new("button", 125*scale, 105*scale, 16 * scale, 25 * scale, "-", sub_hat, {true}, true)
	settingsgui["sprites"] = gui:new("button", 237.5 * scale, 137.5* scale, 50 * scale, 25 * scale, text2, switchstyle, {true}, true)
	
	
	
	
	for i = 1, #ach do
		local a = tostring(i)
		achievegui["achievement" .. a] = gui:new("button", 240 * scale, ((70+(i*30))-30)*scale, 65 * scale, 25 * scale, "LOCKED", nil, nil, false)
		achievegui["achievement" .. a].describe = ach[i][4]
		
		if achcompleted[i] == true then
			achievegui["achievement" .. a].text = "UNLOCKED"
		end
	end
	--Cheats
	local text, value = cheaton(infinitelives)

	settingsgui["lives"] = gui:new("button", 190 * scale, 70*scale, 50 * scale, 25 * scale, text, togglecheat, {value, infinitelives, "lives", ""}, true)
	settingsgui["hatpack1"] = gui:new("button", 240 * scale, 70*scale, 35 * scale, 25 * scale, "2000", buything, {2000, hatpack1, "hatpack1"}, false)
	for i, v in pairs(settingsgui) do
		v.textcolor = {0, 0, 0}
	end

	gamestate = "settings"
	settingsstate = "main"
	canclick = false
	clicktimer = 0
	currentplayer = 1
end

function achievements()
		settingsgui["storetab"].backgroundcolor = {50, 50, 50}
	settingsgui["controlstab"].backgroundcolor = {50, 50, 50}
	settingsgui["cheatstab"].backgroundcolor = {50, 50, 50}
	settingsgui["maintab"].backgroundcolor = {50, 50, 50}
		settingsgui["achievetab"].backgroundcolor = {122, 122, 122}
		achievegui["achievement1"].border = false
		settingsstate = "achievements"
end

function storeopen()
	settingsgui["storetab"].backgroundcolor = {122, 122, 122}
	settingsgui["controlstab"].backgroundcolor = {50, 50, 50}
	settingsgui["cheatstab"].backgroundcolor = {50, 50, 50}
	settingsgui["maintab"].backgroundcolor = {50, 50, 50}
		settingsgui["achievetab"].backgroundcolor = {50, 50, 50}
	settingsstate = "store"
	love.graphics.setColor(255, 255, 255)
	love.graphics.push()
	love.graphics.draw(turtleregister, 50*scale, 120*scale, 0, scale*scale+1, scale*scale+1)
	love.graphics.pop()
end

function settings_update(dt)
	for i, v in pairs(settingsgui) do
		v:update(dt)
	end
		for i, v in pairs(achievegui) do
		v:update(dt)
	end
	properx, propery = love.mouse.getX(), love.mouse.getY()
	clicktimer = clicktimer + dt
	if clicktimer > .5 then 
		canclick = true
	end
	
	if title_intro:isStopped() and playloop == false then
		music:play("title")
		playloop = true
	end
	
			timer = timer + dt
		if timer >= 0 and timer < .1 then
			h = 1
		elseif  timer >= .1 and timer < .2 then
			h = 2
		elseif timer >= .2 and timer < .3 then
			h = 3
		elseif timer >= .3 and timer < .4 then
			h = 4
		end
		
		if timer >= .4 then
			timer = 0
		end
end

function add_hat()
	hat = hat + 1
	if hat > #hats then
	 hat = math.min(#hats,hat)
	end
	--table.insert(objects["turtle"][1].hats,hat)
	print(hat)
end

function sub_hat()
	hat = hat - 1
	if hat < 0 then
		 hat = math.max(0,hat)
	end
	--table.remove(objects["turtle"][1].hats,hat)
	print(hat)
end

function draw_hat()
	if settingsstate == "main" then
	--[[if hat == 0 then
		
	else
		if hat == 1 then
				love.graphics.translate(0, -8)
			elseif hat == 2 then
				love.graphics.translate(0,-9)
			elseif hat == 3 then
				love.graphics.translate(2,-10)
			elseif hat == 4 then
				love.graphics.translate(3,-9)
			elseif hat == 5 then
				love.graphics.translate(0,-9)
			elseif hat == 6 then
				love.graphics.translate(4,-8)
			elseif hat == 7 then
				love.graphics.translate(0,-8)
			elseif hat == 8 then
				love.graphics.translate(3,-7)
			elseif hat == 9 then
				love.graphics.translate(2,-9.5)
			elseif hat == 10 then
				love.graphics.translate(2,-7)
			elseif hat == 11 then
				love.graphics.translate(4,-7)
			end
			love.graphics.setColor(255, 255, 255)
		love.graphics.drawq(hatimg[hat], hatquads[hat], 300*scale/2, 220*scale/2, 0, 3.5, 3.5)
		love.graphics.push()	
		love.graphics.pop()
		end
		
			
	end]]
	end
end

function settings_draw_hats()
	if settingsstate == "main" then
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(standright, 300*scale/2, 220*scale/2, 0, 3.5, 3.5)
	love.graphics.push()	
	love.graphics.pop()
	end
end

function settings_draw()
	love.graphics.setFont(mediumfont)
	love.graphics.push()
	love.graphics.translate(-menuscroll, menuy)
	love.graphics.setColor(255, 255, 255)
	for x = 1, #map do
		for y = 1, #map[x] do
			if map[x][y] ~= 0 then
				love.graphics.drawq(blockquads[map[x][y]].image, blockquads[map[x][y]].quad, x * (16*scale), y * (16*scale), 0, scale)
			end
		end
	end

	love.graphics.pop()
	love.graphics.setColor(255, 255, 255, 200)
	love.graphics.rectangle("fill", 50 * scale/2, 50 * scale/2, 345 * scale, 375 * scale)
	settingsgui["maintab"]:draw()
	settingsgui["controlstab"]:draw()
	settingsgui["cheatstab"]:draw()
	settingsgui["storetab"]:draw()
	settingsgui["achievetab"]:draw()
	settingsgui["exitbutton"]:draw()
	if settingsstate == "main" then
		settingsgui["audio"]:draw()
		settingsgui["addvolume"]:draw()
		settingsgui["minusvolume"]:draw()
		settingsgui["default"]:draw()
		settingsgui["addhat"]:draw()
		settingsgui["minushat"]:draw()
		settingsgui["sprites"]:draw()
		love.graphics.print("AUDIO:", 100 * scale/2, 125 * scale/2)
		love.graphics.print("VOLUME:", 100 * scale/2, 285 * scale/2)
		love.graphics.print(volume, 300 * scale/2, 285 * scale/2)
		love.graphics.print("HAT: ", 100*scale/2, 220*scale/2)
		love.graphics.print("PLAYER SPRITE STYLE: ", 400*scale/2, 220*scale/2)
	end
	if settingsstate == "controls" or settingsstate == "selecting" then
		settingsgui["leftkey"]:draw()
		settingsgui["rightkey"]:draw()
		settingsgui["upkey"]:draw()
		settingsgui["downkey"]:draw()
		settingsgui["addplayer"]:draw()
		settingsgui["minusplayer"]:draw()
		love.graphics.print("LEFT CONTROL:", 100 * scale/2, 175 * scale/2)
		love.graphics.print("RIGHT CONTROL:", 100 * scale/2, 235 * scale/2)
		love.graphics.print("JUMP CONTROL", 100 * scale/2, 375 * scale/2)
		love.graphics.print("DOWN CONTROL:", 100 * scale/2, 300 * scale/2)
		love.graphics.print(currentplayer, 300 * scale/2, 125 * scale/2)
		love.graphics.print("PLAYER", 100 * scale/2, 125 * scale/2)
	end
	if settingsstate == "selecting" then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 475 * scale/2, 100 * scale/2, 300 * scale, 150 * scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("PRESS KEY FOR " .. currentkey, 480 * scale/2, 120 * scale/2)
		love.graphics.print("PRESS ESCAPE TO CANCEL", 480 * scale/2, 225 * scale/2)
	end
	if settingsstate == "cheats" then
		settingsgui["lives"]:draw()
		love.graphics.setColor(0, 0, 0)
		if currentlevel ~= #menugui["levels"] then
			love.graphics.print("BEAT THE GAME TO UNLOCK THESE CHEATS", 50 * scale/2, 100 * scale/2)
		end
		love.graphics.print("INFINITE LIVES:", 50 * scale, 75 * scale)
		if settingsgui["lives"].hoverover then
			love.graphics.print("Gives you infinite lives!", 50*scale, 180*scale)
		end
	end
	if settingsstate == "store" then
		love.graphics.setColor(0, 0, 0)
		love.graphics.print("Hat Pack 1:", 150 * scale, 75 * scale)
		love.graphics.print("x " .. turtlecoins, 85*scale, 90*scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.push()
		love.graphics.drawq(coins, coinsquads[h], 65*scale, 90*scale, 0, scale, scale)
		love.graphics.pop()
		
		settingsgui["hatpack1"]:draw()
			if settingsgui["hatpack1"].hoverover then
		love.graphics.print("Purchase to unlock hats 1-4", 50*scale, 180*scale)
	end
	end
	if settingsstate == "achievements" then
		for i = 1, #ach do
			love.graphics.print(ach[i][5], 100 * scale, ((75+(25*i))-25) * scale)
			achievegui["achievement" .. tostring(i)]:draw()
		end
		for i, v in pairs(achievegui) do
				if v.hoverover then
					love.graphics.print(v.describe, 50*scale, 180*scale)
				end
		end
	end
end

function settings_keypressed(key, unicode)
	if key == "escape" and settingsstate ~= "selecting" then
		exit_settings()
	elseif key == "escape" and settingsstate == "selecting" then
		settingsstate = "controls"
	end
	if unicode > 31 and unicode < 127 and settingsstate == "selecting" or key == "right" and settingsstate == "selecting" or key == "left" and settingsstate == "selecting" or key == "up" and settingsstate == "selecting" or key == "down" and settingsstate == "selecting" then
		_G[currentcontrol .. "control"][currentplayer] = key
		settingsgui[currentcontrol .. "key"].text = string.upper(key)
		settingsstate = "controls"
	end
end

function settings_mousepressed(x, y, button)
	if canclick then
		settingsgui["maintab"]:mousepressed(x, y, button)
		settingsgui["controlstab"]:mousepressed(x, y, button)
		settingsgui["cheatstab"]:mousepressed(x, y, button)
		settingsgui["exitbutton"]:mousepressed(x, y, button)
		settingsgui["storetab"]:mousepressed(x, y, button)
		settingsgui["achievetab"]:mousepressed(x, y, button)
		if settingsstate == "main" then
			settingsgui["audio"]:mousepressed(x, y, button)
			settingsgui["addvolume"]:mousepressed(x, y, button)
			settingsgui["minusvolume"]:mousepressed(x,y,button)
			settingsgui["default"]:mousepressed(x, y, button)
			settingsgui["addhat"]:mousepressed(x, y, button)
			settingsgui["minushat"]:mousepressed(x, y, button)
			settingsgui["sprites"]:mousepressed(x, y, button)
		end
		if settingsstate == "controls" then
			settingsgui["leftkey"]:mousepressed(x, y, button)
			settingsgui["rightkey"]:mousepressed(x, y, button)
			settingsgui["upkey"]:mousepressed(x, y, button)
			settingsgui["downkey"]:mousepressed(x, y, button)
			settingsgui["addplayer"]:mousepressed(x, y, button)
			settingsgui["minusplayer"]:mousepressed(x, y, button)
		end
		if settingsstate == "cheats" and currentlevel == #menugui["levels"] then
			settingsgui["lives"]:mousepressed(x, y, button)
			settingsgui["jetpack"]:mousepressed(x, y, button)
			settingsgui["minecraft"]:mousepressed(x, y, button)
			settingsgui["baddiespam"]:mousepressed(x, y, button)
			settingsgui["laser"]:mousepressed(x, y, button)
		end
		if settingsstate == "store" then
			settingsgui["hatpack1"]:mousepressed(x, y, button)
		end
	end
end

function buything(cost, i, gui)
	if turtlecoins < cost then 
		i = false
		settingsgui[gui].text = cost
		settingsgui[gui].actionargs = {2, i, gui}
		print("not enough turtlecoins!")
	else
		i = true
		turtlecoins = turtlecoins - cost
		settingsgui[gui].text = "PURCHASED"
		settingsgui[gui].width = 90*scale
		settingsgui[gui].actionargs = {0, i, gui}
		print("purchase successful!")
	end
end

function togglecheat(cheatison, cheat, gui)
	cheatison = not cheatison
	if not cheatison then
		cheat = false
		settingsgui[gui].text = "OFF"
		settingsgui[gui].actionargs = {false, cheat, gui}
	else
		cheat = true
		settingsgui[gui].text = "ON"
		settingsgui[gui].actionargs = {true, cheat, gui, ""}
	end
end

function makesettingsdefault()
	audioon = true
	soundenabled = true
	oldsprites = false
	scale = 3
	love.graphics.setMode(screen_width, screen_height) 
	volume = 2
	rightcontrol = {}

	rightcontrol[1] = "right"
	rightcontrol[2] = "d"
	rightcontrol[3] = "h"
	rightcontrol[4] = "l"

	leftcontrol = {}
	leftcontrol[1] = "left"
	leftcontrol[2] = "a"
	leftcontrol[3] = "f"
	leftcontrol[4] = "j"

	upcontrol = {}
	upcontrol[1] = "up"
	upcontrol[2] = "w"
	upcontrol[3] = "t"
	upcontrol[4] = "i"
	settings_load()
end

function controlsopen()
	settingsgui["controlstab"].backgroundcolor = {122, 122, 122}
	settingsgui["maintab"].backgroundcolor = {50, 50, 50}
	settingsgui["cheatstab"].backgroundcolor = {50, 50, 50}
	settingsgui["storetab"].backgroundcolor = {50, 50, 50}
	settingsgui["achievetab"].backgroundcolor = {50, 50, 50}
	settingsstate = "controls"
end

function mainopen()
	settingsgui["maintab"].backgroundcolor = {122, 122, 122}
	settingsgui["controlstab"].backgroundcolor = {50, 50, 50}
	settingsgui["storetab"].backgroundcolor = {50, 50, 50}
	settingsgui["cheatstab"].backgroundcolor = {50, 50, 50}
		settingsgui["achievetab"].backgroundcolor = {50, 50, 50}
	settingsstate = "main"
end

function cheatsopen()
	settingsgui["maintab"].backgroundcolor = {50, 50, 50}
	settingsgui["controlstab"].backgroundcolor = {50, 50, 50}
	settingsgui["storetab"].backgroundcolor = {50, 50, 50}
	settingsgui["cheatstab"].backgroundcolor = {122, 122, 122}
		settingsgui["achievetab"].backgroundcolor = {50, 50, 50}
	settingsstate = "cheats"
end

function exit_settings() --Save settings on exit.
	gamestate = "menu"
	local localmenuscroll = menuscroll
	menu_load()
	menuscroll = localmenuscroll
	savesettings()
	infinitelives = settingsgui["lives"].actionargs[1]
end

function savesettings()
	local smap = love.filesystem.newFile("settings.txt") --Save map
	local open = smap:open("w")
	--Audio,  scale, volume, players controls (left, right, up)
	smap:write("audio:" .. settingsgui["audio"].text .. ";")
	smap:write(scale .. ";")
	smap:write("volume:" .. volume .. ";")
	smap:write("hat:" .. hat .. ";")
	smap:write("turtlecoins:" .. turtlecoins .. ";")
	smap:write("oldsprites:" .. settingsgui["sprites"].text .. ";")
	for i = 1, 4 do
		smap:write(leftcontrol[1] .. ";")
		smap:write(rightcontrol[1] .. ";")
		smap:write(upcontrol[1] .. ";")
		smap:write(downcontrol[1] .. ";")
	end
end

function switchstyle()
	oldsprites = not oldsprites
	if oldsprites then
		settingsgui["sprites"].text = "OLD"
		settingsgui["sprites"].center = true
	else
		settingsgui["sprites"].text = "NEW"
		settingsgui["sprites"].center = false
	end
	
	if oldsprites then
	standright = love.graphics.newImage("graphics/player/old/stand.png")
	walk1 = love.graphics.newImage("graphics/player/old/walk1.png")
	walk2 = love.graphics.newImage("graphics/player/old/walk2.png")
	walk3 = love.graphics.newImage("graphics/player/old/walk3.png")
	jump = love.graphics.newImage("graphics/player/old/jump.png")
	climb1 = love.graphics.newImage("graphics/player/old/climb.png")
	climb2 = love.graphics.newImage("graphics/player/old/climbL.png")
	dead = love.graphics.newImage("graphics/player/old/dead.png")
	finish = love.graphics.newImage("graphics/player/old/finish.png")
	dying = love.graphics.newImage("graphics/player/old/death.png") 
	swimquadimage = love.graphics.newImage("graphics/player/old/swim.png")
	push1 = love.graphics.newImage("graphics/player/old/push1.png")
	push2 = love.graphics.newImage("graphics/player/old/push2.png")
	push3 = love.graphics.newImage("graphics/player/old/push3.png")
	else 
	standright = love.graphics.newImage("graphics/player/new/stand.png")
	walk1 = love.graphics.newImage("graphics/player/new/walk1.png")
	walk2 = love.graphics.newImage("graphics/player/new/walk2.png")
	walk3 = love.graphics.newImage("graphics/player/new/walk3.png")
	jump = love.graphics.newImage("graphics/player/new/jump.png")
	climb1 = love.graphics.newImage("graphics/player/new/climb.png")
	climb2 = love.graphics.newImage("graphics/player/new/climbL.png")
	dead = love.graphics.newImage("graphics/player/new/dead.png")
	finish = love.graphics.newImage("graphics/player/new/finish.png")
	dying = love.graphics.newImage("graphics/player/new/death.png") 
	swimquadimage = love.graphics.newImage("graphics/player/new/swim.png")
	push1 = love.graphics.newImage("graphics/player/new/push1.png")
	push2 = love.graphics.newImage("graphics/player/new/push2.png")
	push3 = love.graphics.newImage("graphics/player/new/push3.png")
	end
end

function switchaudio()
	audioon = not audioon
	soundenabled = not soundenabled
	if audioon then
		if music:ispaused("title") then
			music:resume("title")
		else
			music:play("title")
		end
		settingsgui["audio"].text = "ON"
		settingsgui["audio"].center = true
	else
		music:pause("title")
		settingsgui["audio"].text = "OFF"
		settingsgui["audio"].center = false
	end
end


function changevolume(add)
	if add then
		volume = volume + 1
	else
		volume = volume - 1
	end
	if volume > 5 then
		volume = 5
	end
	if volume < 0 then
		volume = 0
	end
	love.audio.setVolume(volume)
end

function openkey(control, key)
	currentkey = string.upper(key)
	settingsstate = "selecting"
	currentcontrol = control
end

function changeplayers(add)
	if add and currentplayer < 4 then
		currentplayer = currentplayer + 1
	elseif not add and currentplayer > 1 then
		currentplayer = currentplayer - 1
	end
	settingsgui["leftkey"].text = string.upper(leftcontrol[currentplayer])
	settingsgui["rightkey"].text = string.upper(rightcontrol[currentplayer])
	settingsgui["upkey"].text = string.upper(upcontrol[currentplayer])
	settingsgui["downkey"].text = string.upper(downcontrol[currentplayer])
end

function cheaton(cheat)
	local text, value
	cheat = not cheat
	if not cheat then
		text = "ON"
		value = true
	else
		text = "OFF"
		value = false
	end
	return text, value
end