function menu_load(camefromlevel)
	load_menu_level(currentlevel)
	print("menu loaded")
	if audioon and playloop == false then
		playsound(title_intro)
	end

	gamestate = "menu"
	music:stop(currentlevelmusic)
	currpack = 0
	
	mappack = "campaign"
	print(mode)
	if not camefromlevel then
		currentpage = 1
	end

	menuscroll = 48
	menuy = 0
	menumove = ""
	creditsdirection = "right"

	make_menugui()
	hasedited = false

	textcolor = {0, 0, 0, false, false, false}
	textcolorlimit = {}
	textcolorlimit[0] = {228, 214, 0}
	textcolorlimit[1] = {0, 138, 212}
	textcolorlimit[2] = {204, 81, 38}
	textcolorlimit[3] = {155, 0, 138}
	textcolorlimit[4] = {228, 214, 0}
	menulevel = 0

	if camefromlevel then
		menustate = "select"
		levelsactive()
	else
		menustate = "main"
		for i, v in pairs(menugui) do
			if v.text then
				v.active = true
			end
		end
	end
	pageactive()
	textcolorcounter = 1

end


function menu_update(dt)
		
	if textcolorcounter == 1 and not loopedyet then
		textcolor[2] = textcolor[2] + (20 * dt)
		textcolor[3] = textcolor[3] + (30 * dt)
	end
	if textcolorcounter == 2 then
		textcolor[1] = textcolor[1] + (30 * dt)
		textcolor[2] = textcolor[2] - (10 * dt)
		textcolor[3] = textcolor[3] - (30 * dt)
	end
	if textcolorcounter == 3 then
		textcolor[1] = textcolor[1] - (5 * dt)
		textcolor[2] = textcolor[2] - (20 * dt)
		textcolor[3] = textcolor[3] + (15 * dt)
	end
	if textcolorcounter == 4 then
		textcolor[1] = textcolor[1] + (10 * dt)
		textcolor[2] = textcolor[2] + (30 * dt)
		textcolor[3] = textcolor[3] - (20 * dt)
	end
	if textcolorcounter == 1 and loopedyet then
		textcolor[1] = textcolor[1] - (25*dt)
		textcolor[2] = textcolor[2] - (10*dt)
		textcolor[3] = textcolor[3] + (25*dt)
	end

	if menumove == "" and menustate == "main" then
		--menuscroll = menuscroll + (50* dt)
	end

	if title_intro:isStopped() and playloop == false and audioon then
		music:play("title")
		playloop = true
	end

	if menustate == "credits" then
		if creditsrotate > .2 then
			creditsdirection = "left"
		elseif creditsrotate < -.2 then
			creditsdirection = "right"
		end
	end

	if menustate == "credits" then
		if creditsdirection == "right" then
			creditsrotate = creditsrotate + dt/4
		elseif creditsdirection == "left" then
			creditsrotate = creditsrotate - dt/4
		end
	end

	if menuy > 1200 then
		menumove = ""
	end

	if menuscroll > #map*(16*scale) + 16*scale then
		menuscroll = 48
	end

	if menuy < 0 then
		menumove = ""
		menuy = 0
	end

	x, y = love.mouse.getX(), love.mouse.getY()
	properx = x
	propery = y



	fluctuatecolors(dt)

	for i, v in pairs(menugui) do
		if v.text then
			v:update(dt)
		else
			for j, w in pairs(v) do
				w:update(dt)
			end
		end
	end


	showlevel = true

	local levels = #menugui["levels"]

	for i, v in pairs(menugui["levels"]) do
		v:update(dt)
		if v.hoverover then
			if v.level <= currentlevel and i ~= menulevel then
				load_menu_level(v.level)
				menulevel = i
			end
		else
			levels = levels - 1
		end
	end
	if levels == 0 then
		showlevel = false
		if menustate == "select" then
			love.graphics.setBackgroundColor(0, 0, 0)
		end
		menulevel = 0
	end
	--menugui["selectbutton"].text = players .. " PLAYER GAME"
end

function mode_DLC()
	if mode == "DLC" then
		mode = "appdata"
	end
end

function mode_LOCAL()
	if mode == "appdata" then
		mode = "DLC"
	end
end

function menu_draw()
	if menustate == "main" then
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
		love.graphics.setColor(textcolor[1], textcolor[2], textcolor[3])
		love.graphics.setFont(mediumfont)
		love.graphics.setFont(largefont)
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(titlegui, 135 * scale, 10 * scale/2, 0, 2)
		love.graphics.draw(icon, 50 * scale/2, 75 * scale/2, 0, 7)
		love.graphics.setFont(mediumfont)
		love.graphics.push()
		love.graphics.translate(0, menuy)
		love.graphics.setColor(textcolor[1], textcolor[2], textcolor[3])
		love.graphics.print("ARE YOU SURE?", 275, -1000)
		menugui["selectbutton"]:draw()
		menugui["settingsbutton"]:draw()
		menugui["editorbutton"]:draw()
		menugui["creditsbutton"]:draw()
		menugui["addmappack"]:draw()
		menugui["submappack"]:draw()
		if mode == "DLC" then
		menugui["mode"]:draw()
		elseif mode == "appdata" then
		menugui["mode2"]:draw()
		end
		love.graphics.pop() 
	end
	if menustate == "select" then
		love.graphics.setFont(smallfont)
		love.graphics.push()
		love.graphics.translate(-menuscroll, 0)
		for i, v in pairs(menugui["levels"]) do
			if v.active then
				v:draw()
			end
		end
		love.graphics.setColor(255, 255, 255)
		love.graphics.pop()
		love.graphics.setFont(smallfont)
		love.graphics.push()
		love.graphics.translate(-48, 0)
		if menulevel ~= 0 and showlevel then
			for x = 1, #map do
				for y = 1, #map[x] do
					if map[x][y] ~= 0 then
						love.graphics.drawq(blockquads[map[x][y]].image, blockquads[map[x][y]].quad, x * (16*scale), y * (16*scale), 0, scale)
					end
				end
			end
		end
		love.graphics.pop()
		menugui["previousbutton"]:draw()
		menugui["nextbutton"]:draw()
	end
--[[	if menustate == "credits" then
		love.graphics.push()
		local width = love.graphics.getWidth()
   		local height = love.graphics.getHeight()
   		 -- rotate around the center of the screen by angle radians
    	love.graphics.translate(width/2, height/2)
		love.graphics.rotate(creditsrotate)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", -450, -300, 900, 600)
		love.graphics.setColor(textcolor[1], textcolor[2], textcolor[3])
		love.graphics.print("Turtle: Puzzles", -100, -200)
		love.graphics.print("AN AWESOME GAME BY", -400, -100)
		love.graphics.print("WITH MUSIC FROM", -400, 0)
		love.graphics.print("AND ART FROM", -400, 100)
		love.graphics.print("GAME FRAMEWORK/HARD CODE", -450, 200)
		love.graphics.setColor(255, 70, 0)
		love.graphics.print("Jeremy Postelnek", 100, -100)
		love.graphics.print("Hatninja/Kyle_Prior", 50, 0)
		love.graphics.print("Hatninja", -25, 100)
		love.graphics.print("QCode", 250, 200)
		love.graphics.pop()
		menugui["exitcreditsbutton"]:draw()
	end]]
	if menustate == "players" then
		love.graphics.push()
		love.graphics.translate(-48, 0)
		for x = 1, #map do
			for y = 1, #map[x] do
				if map[x][y] ~= 0 then
					love.graphics.drawq(blockquads[map[x][y]].image, blockquads[map[x][y]].quad, x * (16*scale), y * (16*scale), 0, scale)
				end
			end
		end
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(mediumfont)
		love.graphics.setColor(textcolor[1], textcolor[2], textcolor[3])
		love.graphics.print("CHOOSE AMOUNT OF PLAYERS!", 250 * scale/2, 100 * scale/2)
		love.graphics.setFont(largefont)
		love.graphics.print(players, 380 * scale/2, 215 * scale/2)
		love.graphics.setColor(255, 255, 255)
		love.graphics.pop()
		love.graphics.setFont(mediumfont)
		menugui["addplayers"]:draw()
		menugui["minusplayers"]:draw()
		menugui["playbutton"]:draw()
		love.graphics.setColor(255, 255, 255)
		local xs = {}
		xs[1] = 1
		xs[2] = 3
		xs[3] = 5
		xs[4] = 7
		local y = {}
		for i = 1, 4 do
			y[i] = 13 * (16*scale)
		end
		local check = {}
		for x = 1, 4 do
			check[x] = 13
		end
		for x = 1, 4 do
			for i = 1, 15 do
				if map[xs[x]][i] ~= 0 then
					check[x] = check[x] - 1
				end
			end
		end
		for x = 1, 4 do
			if check[x] == 0 then 
				xs[x] = xs[x] + 1
			end
		end
		for x = 1, 4 do
			for i = 15, 3, -1 do
				if map[xs[x]][i] ~= 0 then
					y[x] = i * (16*scale)
				end
			end
		end
		for i = 1, players do
			--[[local different = false
			if i ~= 1 then
				if y[i] ~= y[i-1] then
					different = true
				end
			end
			if different then
				love.graphics.draw(_G["bigheadimg" .. i], (i-1) * (42*scale), y[i] - 48 * scale, 0, 5.3*scale)
			else--]]
				love.graphics.draw(_G["bigheadimg" .. i], (xs[i] - 1) * (16*scale), y[i] - 48 * scale, 0, 5.3*scale)
			--end
		end
	end
	if menustate == "settings" then
		menugui["maintab"]:draw()
	end
end

function menu_mousepressed(x, y, button)
	if menustate == "main" then
		menugui["selectbutton"]:mousepressed(x, y, button)
		menugui["settingsbutton"]:mousepressed(x, y, button)
		menugui["editorbutton"]:mousepressed(x, y, button)
		menugui["creditsbutton"]:mousepressed(x, y, button)
		menugui["addmappack"]:mousepressed(x, y, button)
		menugui["submappack"]:mousepressed(x, y, button)
		if mode == "DLC" then
		menugui["mode"]:mousepressed(x, y, button)
		elseif mode == "appdata" then
		menugui["mode2"]:mousepressed(x, y, button)
		end
	end
	if menustate == "credits" then
		menugui["exitcreditsbutton"]:mousepressed(x, y, button)
	end
	if menustate == "players" then
		menugui["addplayers"]:mousepressed(x, y, button)
		menugui["minusplayers"]:mousepressed(x, y, button)
		menugui["playbutton"]:mousepressed(x, y, button)
	end
	if menustate == "select" then
		if menugui then
			for i, v in pairs(menugui["levels"]) do
				v:mousepressed(x,y, button)
			end
		end
		menugui["previousbutton"]:mousepressed(x, y, button)
		if currentlevel > 5 then
			menugui["nextbutton"]:mousepressed(x, y, button)
		end
	end
	if menustate == "settings" then
		
	end
end

function fluctuatecolors(dt)
	for i = 1, #textcolorlimit do
		if textcolorcounter == i then
			if loopedyet then
				if textcolorlimit[i][1] > textcolorlimit[i-1][1] then
					if textcolor[1] >= textcolorlimit[i][1] then
						textcolor[1] = textcolorlimit[i][1]
						textcolor[4] = true
					end
				else
					if textcolor[1] <= textcolorlimit[i][1] then
						textcolor[1] = textcolorlimit[i][1]
						textcolor[4] = true
					end
				end
				if textcolorlimit[i][2] > textcolorlimit[i-1][2] then
					if textcolor[2] >= textcolorlimit[i][2] then
						textcolor[2] = textcolorlimit[i][2]
						textcolor[5] = true
					end
				else
					if textcolor[2] <= textcolorlimit[i][2] then
						textcolor[2] = textcolorlimit[i][2]
						textcolor[5] = true
					end
				end
				if textcolorlimit[i][3] > textcolorlimit[i-1][3] then
					if textcolor[3] >= textcolorlimit[i][3] then
						textcolor[3] = textcolorlimit[i][3]
						textcolor[6] = true
					end
				else
					if textcolor[3] <= textcolorlimit[i][3] then
						textcolor[3] = textcolorlimit[i][3]
						textcolor[6] =  true
					end
				end
			else
				if textcolor[1] >= textcolorlimit[i][1] then
					textcolor[1] = textcolorlimit[i][1]
					textcolor[4] = true
				end
				if textcolor[2] >= textcolorlimit[i][2] then
					textcolor[2] = textcolorlimit[i][2]
					textcolor[5] = true
				end
				if textcolor[3] >= textcolorlimit[i][3] then
					textcolor[3] = textcolorlimit[i][3]
					textcolor[6] = true
				end
			end
		end
	end
	if textcolor[4] and textcolor[5] and textcolor[6] then
		textcolorcounter = textcolorcounter + 1
		loopedyet = true
		textcolor[4], textcolor[5], textcolor[6] = false, false, false
	end
	if textcolorcounter > 4 then
		textcolorcounter = 1
		loopedyet = true
	end
end


function enterplay()
	menustate = "select"
	for i, v in pairs(menugui["levels"]) do
		v.active = false
	end
	for i = 1, 5 do
		menugui["levels"][i].active = true
	end
	if currentpage < 2 and currentlevel > 5  then
		menugui["previousbutton"].backgroundcolor = {0, 0, 0}
		menugui["nextbutton"].backgroundcolor = {50, 50, 50}
	elseif currentpage > 1 and currentlevel > 5 then
		menugui["previousbutton"].backgroundcolor = {50, 50, 50}
		menugui["nextbutton"].backgroundcolor = {0, 0, 0}
	end
	menuscroll = 0
	love.graphics.setBackgroundColor(0, 0, 0)
end

function load_menu_level(level)
	if mode == "DLC" then
		if love.filesystem.exists("Levels/" .. mappack .. "/" .. level) then
			level = level
			maptoload = love.filesystem.read("Levels/" .. mappack .. "/" .. level)
		else
			level = level - 1
			
		end
	elseif mode == "appdata" then
		if love.filesystem.exists("/maps/" .. mappack .. "/" .. level) then
			level = level
			maptoload = love.filesystem.read("/maps/" .. mappack .. "/" .. level)
		else
			level = level - 1
			maptoload = love.filesystem.read("Levels/" .. -1)
		end
			
	end
	
	if mode == "DLC" and firstplay and mappack == "campaign" then
		maptoload = love.filesystem.read("Levels/" .. mappack .. "/" .. "intro")
	elseif mode == "DLC" and not firstplay and mappack == "campaign" then
		if love.filesystem.exists("Levels/" .. mappack .. "/" .. level) then
			level = level
			maptoload = love.filesystem.read("Levels/" .. mappack .. "/" .. level)
		else
			level = level - 1
			maptoload = love.filesystem.read("Levels/" .. -1)
		end
	end
	
	local config = maptoload:split(";") --Different level configs
	map = {}
	love.graphics.setBackgroundColor(tonumber(config[3]), tonumber(config[4]), tonumber(config[5])) --Background color!
	for i = 1, config[2] do
		map[i] = {}
		for y = 1, 14 do -- Generates map from map width
			map[i][y] = 0
		end
	end
	local xsplit = maptoload:split(",")
	for y = 1, 14 do
		for x = 1, tonumber(config[2]) do --Make the map image
			local split = xsplit[((y-1)*tonumber(config[2]))+x]:split("-")
			map[x][y] = tonumber(split[1])
		end
	end
end

function menu_keypressed(key)
	if key == "escape" then
		if menustate == "select" then
			menustate = "main"
			for i, v in pairs(menugui) do
				if v.text then
					v.active = true
				end
			end
			for i, v in pairs(menugui["levels"]) do
				v.active = false
			end
			menuscroll = 48
			load_menu_level(currentlevel)
		elseif menustate == "main" then
			love.event.push("quit")
		elseif menustate == "players" then
			menustate = "select"
			menugui["playbutton"].active, menugui["addplayers"].active, menugui["minusplayers"].active = false, false, false
			levelsactive()
			pageactive()
			menugui["nextbutton"].active = true
			menugui["previousbutton"].active = true
		end
	end
	if key == "right" then
		if menustate == "main" then
			if players < 4 then
				players = players + 1
			end
		end
	end
	if key == "left" then
		if menustate == "main" then
			if players > 1 then
				players = players - 1
			end
		end
	end
end


function fullexit()
	love.event.push("quit")
	--
end


function menufromcredits()
	for i, v in pairs(menugui) do
		if v.text then
			v.active = true
		end
	end
	menugui["exitcreditsbutton"].active = false
	menustate = "main"
	load_menu_level(currentlevel)
end

function entercredits()
	menustate = "credits"
	for i, v in pairs(menugui) do
		if v.text then
			v.active = false
		end
	end
	levelscreen_load("credits")
end

function addplayers()
	if players < 4 then
		players = players + 1
	end
end

function minusplayers()
	if players > 1 then
		players = players - 1
	end
end

function enter_players(level)
	for i, v in pairs(menugui) do
		if v.text then
			v.active = false
		else
			for j, w in pairs(v) do
				w.active = false
			end
		end
	end
	menugui["playbutton"].actionargs = {level}
	menugui["addplayers"].active = true
	menugui["minusplayers"].active = true 
	menugui["playbutton"].active = true
	menustate = "players"
end

function entersettings()
	settings_load()
	--
end

function nextpack()
	currpack = currpack + 1
	if mode == "DLC" then
	levels2 = love.filesystem.enumerate("Levels/")
	else
	levels2 = love.filesystem.enumerate("/maps/")
	end
	print("lol")
	if currpack > #levels2 then
		currpack = #levels2
	end
	mappack = levels2[currpack]
	print(mappack)
	load_menu_level(currentlevel)
end

function prevpack()
	currpack = currpack - 1
	if mode == "DLC" then
	levels3 = love.filesystem.enumerate("Levels/")
	else
	levels3 = love.filesystem.enumerate("/maps/")
	end
	print("lol")
	if currpack < 1 then
		currpack = 1
	end
	mappack = levels3[currpack]
	print(mappack)
	load_menu_level(currentlevel)
end

function make_menugui()
	menugui = {}
	
	if mode == "DLC" then
		maptypes = "DLC"
	elseif mode == "appdata" then
		maptypes = "local"
	end
	
	menugui["selectbutton"] = gui:new("flashybutton",  162 * scale, 105 *scale , 50*scale , 20 * scale , "PLAY!", nil, levelscreen_load, {"next", 1})
	menugui["settingsbutton"] = gui:new("flashybutton",  163 * scale/2, 132 * scale, 200 * scale, 20 * scale, "OPTIONS", nil, entersettings)
	menugui["levels"] = {}
	menugui["editorbutton"] = gui:new("flashybutton",  100 * scale/2, 160* scale, 266 * scale, 60, "EDITOR", nil, open_editor)
	menugui["creditsbutton"] = gui:new("flashybutton",  100 * scale/2, 190 * scale, 266 * scale, 60, "CREDITS", nil, entercredits)
	menugui["exitcreditsbutton"] = gui:new("flashybutton",  100 * scale/2, 150 * scale, 400*scale, 30, "I GET IT LET ME PLAY THE GAME", nil, menufromcredits)
	menugui["addplayers"] = gui:new("button",  100 * scale/2, 200 * scale, 175*scale, 40*scale, "+", addplayers, nil, true)
	menugui["minusplayers"] = gui:new("button",  100 * scale/2, 200 * scale, 200*scale, 40*scale, "-", minusplayers, nil, true)
	menugui["addmappack"] = gui:new("flashybutton",  232 * scale, 103 * scale, 16*scale, 16*scale, "+", nil, nextpack, nil)
	menugui["submappack"] = gui:new("flashybutton",  136 * scale, 103 * scale, 16*scale, 16*scale, "-", nil, prevpack, nil)
	menugui["mode"] = gui:new("flashybutton",  176 * scale, 80 * scale, 16*scale, 16*scale, "DLC", nil, mode_DLC, nil)
	menugui["mode2"] = gui:new("flashybutton",  176 * scale, 80 * scale, 16*scale, 16*scale, "LOCAL", nil, mode_LOCAL, nil)
	
	--Type, x, y, width, height, text, direction, function, args
	menugui["addplayers"].active = false
	menugui["minusplayers"].active = false
	local reallevels = {}
	
	if mode == "DLC" then
	 levels = love.filesystem.enumerate("/Levels")
	elseif mode == "appdata" then
	 levels = love.filesystem.enumerate("/maps/")
	end
	
	local real = true
	for i = 1, #levels do
		real = true
		if levels[i] == ".DS_Store" then
			real = false
		end
		local split1 = levels[i]:split(".rtf")
		local split2 = levels[i]:split(".txt")
		if split1[2] or split2[2] then
			real = false
		end
		local split = levels[i]:split("-")
		if #split < 2 and real then
			table.insert(reallevels, i)
		end
	end
  	if unlockedlevels then
  		currentlevel = #reallevels
  	end

  	creditsrotate = 0
	local offset = 0
	local loop = 1
	local loopedyet = false
	local properi = 1
	for i = 1, #reallevels do
		local is5 = false
		if math.ceil(i/5) == i/5 then
			is5 = true
		end

		local number

		if not is5 then
			number = i-(math.floor(i/5)*5)
		else
			number = 5
		end

		offset = ((((number-1)) * 159 + 3) * scale)
		menugui["levels"][i] = gui:new("button", offset, 3, 159 * scale, 16*scale, "Level " .. i, enter_players, {i}, true)
		menugui["levels"][i].level = i
		menugui["levels"][i].active = false
	end
	for i, v in pairs(menugui["levels"]) do
		v.active = false
	end
	menugui["previousbutton"] = gui:new("button", 0, (love.graphics.getHeight() - (16*scale) * 2), (16*scale)*4, 16*scale*2, "PREVIOUS PAGE", changepage, {false}, false)
	menugui["previousbutton"].textcolor = {255, 255, 255}
	menugui["nextbutton"] = gui:new("button", love.graphics.getWidth() - (16*scale) * 4, (love.graphics.getHeight() - (16*scale) * 2), (16*scale*4), 16*scale*2, "NEXT PAGE", changepage, {true}, true)
	menugui["nextbutton"].textcolor = {255, 255, 255}
end

function changepage(up)
	if not up then
		if currentpage > 1 then
			currentpage = currentpage - 1
			levelsactive()
			pageactive()
			if currentpage == 1 then
				menugui["nextbutton"].backgroundcolor = {50, 50, 50}
				menugui["previousbutton"].backgroundcolor = {0, 0, 0}
			end
		end
	else
		if currentpage < math.ceil(#menugui["levels"]/5) then
			currentpage = currentpage + 1
			levelsactive()
			pageactive()
			if currentpage*5 == #menugui["levels"] then
				menugui["nextbutton"].backgroundcolor = {0, 0, 0}
				menugui["previousbutton"].backgroundcolor = {50, 50, 50}
			end
		end
	end
end

function levelsactive()
	for i, v in pairs(menugui["levels"]) do
		v.active = false
	end
	local number
	if currentpage == math.ceil(#menugui["levels"]/5) then
		if math.floor(#menugui["levels"]/5) == #menugui["levels"]/5 then
			number = 5
		else
			number = #menugui["levels"] - (currentpage-1)*5
		end
	else
		number = 5
	end
	for i = (currentpage-1)*5+1, (currentpage-1)*5 + number do
		menugui["levels"][i].active = true
	end
end

function pageactive()
	if currentlevel >= currentpage*5+1 and currentpage < math.ceil(#menugui["levels"]/5) then
		menugui["nextbutton"].backgroundcolor = {50, 50, 50}
	elseif currentlevel < currentpage*5 or currentpage > math.ceil(#menugui["levels"]/5)-1 then
		menugui["nextbutton"].backgroundcolor = {0, 0, 0}
	end
	if currentpage > 1 then
		menugui["previousbutton"].backgroundcolor = {50, 50, 50}
	else
		menugui["previousbutton"].backgroundcolor = {0, 0, 0}
	end
end
