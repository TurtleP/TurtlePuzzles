function game_load(level)
	gamestate = "game"
	make_objects_tables()
	form_map(level)
	make_objects(level)
	resetcollisionoptions()
	turtlescore = 0
	music:stop("title")
	love.audio.stop(title_intro)
	if audioon then
		music:play(currentlevelmusic)
	end
	paused = false
	gamexscroll = 48
	make_gamegui()
end

function make_gamegui()
	gamegui = {}
	gamegui["menu"] = gui:new("button", screen_width/2.15, screen_height/2.2, 50*scale , 20 * scale, "MENU", menu_load, {false})
end

function unlock(c, a) --coins to give, achievement
	
end

function conditions(c, a) --how to unlock achievements
	for i = 1, #ach do
		if ach[i][1] then
			if achcompleted[a] == false then
				addcoins(c)
				print("okay--")
				achcompleted[a] = true
			end
		end
	end
end

function addcoins(c)
	turtlecoins = turtlecoins+c
end

function game_update(dt)

	conditions()

if not paused then
	for i, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.update then
				w:update(dt)
			end
		end
		gamegui["menu"].click = true
	end
end

for i, v in pairs(gamegui) do
		if v.text then
			v:update(dt)
		else
			for j, w in pairs(v) do
				w:update(dt)
			end
		end
end
		gamegui["menu"].click = true

	
	for i, v in pairs(objects["turtle"]) do
		if v.x > love.graphics.getWidth()*(3/4) and #map > 25  then
			gamexscroll = math.floor(v.x - love.graphics.getWidth()*(3/4))
		end
	end
	
	for i, v in pairs(objects["turtle"]) do
		if firstplay and mode == "DLC" and mappack == "campaign" then
			
			if v.y > screen_height - 30 then
			firstplay = false
				game_load(1)
			end
		end
	end
	
	
	if gamexscroll < 48 then
		gamexscroll = 48
	end
	remove_objects()
	loadphysics(dt)
	
	if packfinish then
		finishtimer = finishtimer - dt
		
		if finishtimer <= 0 then
			menu_load(false)
			finishtimer = 3
			gamestate = "menu"
			packfinish = false
			firstplay = true
			currentlevel = 1
		end
	end
	
end

function remove_objects()
	for i = #objects["coin"], 1, -1 do
		if objects["coin"][i].remove then
			table.remove(objects["coin"], i)
		end
	end
	for i = #objects["key"], 1, -1 do
		if objects["key"][i].kill then
			table.remove(objects["key"], i)
		end
	end
	for i = #objects["gate"], 1, -1 do
		if objects["gate"][i].kill then
			table.remove(objects["gate"], i)
		end
	end
end

function game_draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.push()
	love.graphics.translate(-gamexscroll, 0)
		
	for x = 1, #map do
		for y = 1, #map[x] do
			if map[x][y] ~= 0 then
				love.graphics.drawq(blockquads[map[x][y]].image, blockquads[map[x][y]].quad, x * (16*scale), y * (16*scale), 0, scale)
			end
		end
	end
	
	
		
	for i, v in pairs(objects["door"]) do
		v:draw2()
	end
	
	for i, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.draw then
				w:draw()
			end
		end
	end
	
	if packfinish then
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("THANK YOU FOR" , screen_width/2.5, screen_height/4)
		love.graphics.print("FINISHING THIS MAPPACK" , screen_width/3, screen_height/2.5)
	end
	
	for i,v in pairs(objects["turtle"]) do
		v:drawplayer()
		--v:drawhat()
	end
	
	 for j, w in pairs(objects) do
		if j == "turtle" then
			for i, v in pairs(w) do
			if v.drawhats and v.hats then
				if hatoffsets[j] then 
					offsets = hatoffsets[j] 
				else 
					offsets = hatoffsets["all"] 
				end
					if #hats > 0 then
						if v.dir == "right" then
							hats[11].offsetsX = 0
							hats[12].offsetsX = 0
						else
							hats[11].offsetsX = 8.5
							hats[12].offsetsX = 13
						end
						love.graphics.draw(hats[hat].graphic,v.x+hats[hat].x+offsets[1],v.y+hats[hat].height+offsets[2],0, v.scale, scale, hats[hat].offsetsX)
					end
				end
			end
		end
	end

				
	
	
	
	--love.graphics.setColor(255, 0, 0)
	--love.graphics.setLineWidth(1)
	
	--[[if physicsdebug then
		for i, v in pairs(objects) do
			for j, w in pairs(v) do
				love.graphics.rectangle("line", w.x, w.y, w.width, w.height)
			end
		end
	end]]

	love.graphics.pop()
	
	if paused then
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill", screen_width/2.4, screen_height/3, 92*scale, 100*scale)
		love.graphics.setLineWidth(1)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("PAUSED", screen_width/2.15, screen_height/2.9)
		gamegui["menu"]:draw()
		gamegui["menu"].textcolor = {255, 255, 255}
		--love.graphics.print("MENU", screen_width/2.1, screen_height/2.2)
		love.graphics.rectangle("line", screen_width/2.4, screen_height/3, 92*scale, 100*scale)
	end
end

function game_draw_HUD()
	love.graphics.setColor(255, 0, 0)
	love.graphics.setFont(mediumfont)
	love.graphics.print("Turtle", 100, 20*scale)
	love.graphics.print(turtlescore, 100, 32*scale)
	
	love.graphics.print("Emeralds", 300, 20*scale)
	love.graphics.print(emeraldcount, 350, 32*scale)
	
	
	love.graphics.print("Lives", 600, 20*scale)
	for i, v in pairs(objects["turtle"]) do
	love.graphics.print(v.lives, 650, 32*scale)
	end
	love.graphics.print("Level", 900, 20*scale)
	love.graphics.print(currentlevel, 950, 32*scale)
end

function game_keypressed(key, unicode)
	for i, v in pairs(objects["turtle"]) do
		v:keypressed(key)
	end
	if key == "p" then
		physicsdebug = not physicsdebug
	end
	if key == "e" and hasedited then
		open_editor()
	end
	if key == "escape" then
		paused = not paused
	end
end

function make_objects_tables()
	objects = {}
	objects["turtle"] = {}
	objects["block"] = {}
	objects["button"] = {}
	objects["spawn"] = {}
	objects["ladder"] = {}
	objects["spikes"] = {}
	objects["door"] = {}
	objects["coin"] = {}
	objects["lava"] = {}
	objects["water"] = {}
	objects["exit"] = {}
	objects["gate"] = {}
	objects["key"] = {}
	objects["lever"] = {}
	objects["spring"] = {}
	objects["permabutton"] = {}
	objects["fakewall"] = {}
	objects["invisowall"] = {}
	objects["teleporter"] = {}
	objects["sign"] = {}
	objects["crate"] = {}
	objects["floorbutton"] = {}
	objects["trigger"] = {}
end

function nextlevel()
	currentlevel = currentlevel + 1
	game_load(currentlevel)
end

function game_mousepressed(x, y, button)
	if paused then
		gamegui["menu"]:mousepressed(x, y, button)
	end
	
end

function form_map(level)
	local config
	local width
	local height = 13
	local numbersettings
	local maptoload
	local xsplit
	local settings
	startx = 32
	starty = 50
	
	if level then
		map = {}
		entitymap = {}
		
	if mode == "DLC" then
		if not love.filesystem.exists("Levels/" .. mappack .. "/" .. level) then
			maptoload = love.filesystem.read("Levels/" .. -1)
			packfinish = true
		else
			maptoload = love.filesystem.read("Levels/" .. mappack .. "/" .. level)
		end
	end
	
	if mode == "appdata" then
		if not love.filesystem.exists("/maps/" .. mappack .. "/" .. level) then
			maptoload = love.filesystem.read("Levels/" .. -1)
			packfinish = true
		else
				maptoload = love.filesystem.read("/maps/" .. mappack .. "/" .. level)
		end
	end
	
	if firstplay and mode == "DLC" and mappack == "campaign" then
		maptoload = love.filesystem.read("Levels/" .. mappack .. "/" .. "intro")
	end
	
	
		config = maptoload:split(";") --Different level configs
		screenxlimit = config[2] * (16*scale)
		width = config[2]
		if gamestate ~= "loadlevel" then
		love.graphics.setBackgroundColor(tonumber(config[3]), tonumber(config[4]), tonumber(config[5])) --Background color!
		end
		for i = 1, config[2] do
			map[i] = {}
			entitymap[i] = {}
			for y = 1, 13 do -- Generates map from map width
				map[i][y] = 0
				entitymap[i][y] = 0
			end
		end
		xsplit = maptoload:split(",")
		if config[7] then
			height = config[7]
			screenylimit = config[7] * (16*scale) - 16*scale
		else
			screenylimit = #map[1] * (16*scale)
		end
		currentlevelmusic = config[6]
		if audioon then
			music:play(music[config[6]])
		end
	else
		height = tonumber(editorgui["mapheight"].text) or 14
		width = #entitymap
		screenxlimit = #map * (16*scale) + 16*scale
		screenylimit = tonumber(editorgui["mapheight"].text) * (16*scale) - 16*scale
		currentlevelmusic = editorgui["musicselect"].value 
		music:play(currentlevelmusic)
	end
	for y = 1, height do
		for x = 1, width do --Make the map image
			local fakesplit
			local split
			if level then
				fakesplit = xsplit[((y-1)*tonumber(config[2]))+x]:split("name")
				split = fakesplit[1]:split("-")
				map[x][y] = tonumber(split[1])
			end
			local hasentity = false
			if split then
				if split[2] then
					hasentity = true
				end
			else
				if entitymap[x][y][1] ~= 0 then
					hasentity = true
				end
			end
			if hasentity then
				if split then
					if split[2] then
						if not split[3] then
							numbersettings = 1
						else
							numbersettings = tonumber(split[3])
						end
					end
				else
					numbersettings = tonumber(entitymap[x][y][2])
				end
				local t
				if split then
					if split[2] then
						t = entityquads[tonumber(split[2])].type
					end
				else
					t = entityquads[tonumber(entitymap[x][y][1])].type
				end
				if rightclickvalues[t] then
					settings = rightclickvalues[t][numbersettings]
				end
				if not fakesplit then
					fakesplit = {}
					fakesplit[2] = entitymap[x][y][3]
				end
				if t == "button" then
					table.insert(objects["button"], button:new(x * (16*scale), y * (16*scale), settings, fakesplit[2]))
				elseif t == "spawn" then
					table.insert(objects["spawn"], spawn:new(x * (16*scale), y * (16*scale)))
					startx = x*16
					starty = y*16-8
				elseif t == "ladder" then
					table.insert(objects["ladder"], ladder:new(x * (16*scale), y * (16*scale)))
				elseif t == "spikes" then
					table.insert(objects["spikes"], spikes:new(x * (16*scale), y * (16*scale), settings))
				elseif t == "door" then
					table.insert(objects["door"], door:new(x * (16*scale), y * (16*scale), fakesplit[2]))
				elseif t == "coin" then
					table.insert(objects["coin"], coin:new(x * (16*scale), y * (16*scale)))
				elseif t == "lava" then
					table.insert(objects["lava"], lava:new(x * (16*scale), y * (16*scale), settings))
				elseif t == "water" then
					table.insert(objects["water"], water:new(x * (16*scale), y * (16*scale), settings))
				elseif t == "exit" then
					table.insert(objects["exit"], exitdoor:new(x * (16*scale), y * (16*scale), settings))
				elseif t == "gate" then
					table.insert(objects["gate"], gate:new(x * (16*scale), y * (16*scale)))
				elseif t == "key" then
					table.insert(objects["key"], key:new(x * (16*scale), y * (16*scale)))
				elseif t == "lever" then
					table.insert(objects["lever"], lever:new(x * (16*scale), y * (16*scale), fakesplit[2]))
				elseif t == "spring" then
					table.insert(objects["spring"], spring:new(x * (16*scale), y * (16*scale)))
				elseif t == "permabutton" then
					table.insert(objects["permabutton"], permabutton:new(x * (16*scale), y * (16*scale), fakesplit[2]))
				elseif t == "fakewall" then
					table.insert(objects["fakewall"], fakewall:new(x * (16*scale), y * (16*scale), fakesplit[2]))
				elseif t == "invisowall" then
					table.insert(objects["invisowall"], invisowall:new(x * (16*scale), y * (16*scale), settings, fakesplit[2]))
				elseif t == "teleporter" then
					table.insert(objects["teleporter"], teleport:new(x * (16*scale), y * (16*scale), settings, fakesplit[2]))
				elseif t == "sign" then
					table.insert(objects["sign"], sign:new(x * (16*scale), y * (16*scale), settings))
				elseif t == "crate" then
					table.insert(objects["crate"], crate:new(x * (16*scale), y * (16*scale), settings))
				elseif t == "floorbutton" then
					table.insert(objects["floorbutton"], floorbutton:new(x * (16*scale), y * (16*scale), fakesplit[2]))
				elseif t == "trigger" then
					table.insert(objects["trigger"], trigger:new(x * (16*scale), y * (16*scale), fakesplit[2]))
				else 
				
				end
			end
		end
	end
end

function make_objects(level)
	for y = 1, #map[1] do
		for x = 1, #map do
			if map[x][y] ~= 0 then
				local passive 
			if blockquads[map[x][y]].passive then
				passive = true
			end
			if not passive then
				table.insert(objects["block"], block:new(x*(16*scale), y*(16*scale), passive)) --Make the map physics.
			end
		end
	end
	
			local players = 1
			if not packfinish then
				if startx then
					for i = 1, players do
						if startx then
							objects["turtle"][i] = turtle:new(startx*scale, starty*scale, 3, 1)
						else
							objects["turtle"][i] = turtle:new(33*scale, 50*scale, 3, 1)
						end
					end
				end
			end
		end
end

function playsound(sound)
	if soundenabled then
		sound:stop()
		sound:rewind()
		sound:play()
	end
end