--Oh god this is going to be annoying to comment
--More limes than the game code.
function open_editor() --This is only called if you're haven't allready loaded the editoe.
	gamestate = "editor"
	editor_state = "editing" 
	for i, v in pairs(menugui) do
		if v.text then
			v.active = false
		else
			for j, w in pairs(v) do
				w.active = false
			end
		end
	end
	editor_load()
	love.graphics.setFont(smallfont)
	music:stop("title")
	love.audio.stop(title_intro)
	menuopen = false
	link = false
	editmenu = "main"
end

function editor_load()
	if not hasedited then --Generate a blank map
		map = {}
		entitymap = {}
		for x = 1, 100 do
			map[x] = {}
			entitymap[x] = {}
			for y = 1, 14 do
				map[x][y] = 0
				entitymap[x][y] = {}
				entitymap[x][y][1] = 0
				entitymap[x][y][2] = 1
			end
		end
		drawingx = 16*scale
		drawingy = 0
		love.graphics.setBackgroundColor(255, 255, 255)
		--mousestate = "Blocks"
		editorgui = {} --Creates a bunch of editorgui. Should be self explanatory. Check gui.lua to learn arguments
		editorgui["linkbutton"] = gui:new("button", 300 * scale, 100 * scale, 70 * scale, (16*scale), "Link", switch_link, nil, true)
		editorgui["mapname"] = gui:new("textbox", 18 * scale, 130 * scale, 133 * scale, 33 * scale, "Map Name", "My first map", 30, "all")
		editorgui["mapname"].active = false
		editorgui["packname"] = gui:new("textbox", 18 * scale, 70 * scale, 133 * scale, 33 * scale, "Mappack Name", "Custom pack", 30, "all")
		editorgui["packname"].active = false
		editorgui["exitbutton"] = gui:new("button", 150 * scale, 185 * scale, 75 * scale, (16*scale), "Exit editor", exit_editor, nil, true)
		editorgui["mapwidth"] = gui:new("textbox", 200 * scale, 150 * scale, 50 * scale, 15 * scale, "Map width", 100, 10, "numbers")
		editorgui["mapwidth"].active = false
		editorgui["mapheight"] = gui:new("textbox", 260 * scale, 150 * scale, 50 * scale, 15 * scale, "Map height", 14, 10, "numbers")
		editorgui["mapheight"].active = false
		editorgui["savebutton"] = gui:new("button", 37.5 * scale, 185 * scale, 75*scale, 16 * scale, "Save map", save_map, nil, true)
		editorgui["savebutton"].active = false
		editorgui["loadmapsbutton"] = gui:new("button", 32 * scale, 125 * scale, 125 * scale, 15 * scale, "Show all maps", show_maps, nil, true)
		editorgui["loadmapsbutton"].active = false
		editorgui["testbutton"] = gui:new("button", 260* scale, 185 * scale, 41.65 * scale, (16*scale), "Test", test_level, nil, true)
		editorgui["backgroundcolor"] = {}
		editorgui["scrollspeed"] = gui:new("textbox", 300 * scale, 50 * scale, 12.5 * scale, (16*scale), "Scroll speed", "1", 1, "numbers")
		editorgui["musicselect"] = gui:new("dropdown", 200 * scale, 60 * scale, 75 * scale,  16* scale, "Music", {"none", "overworld", "underground", "difficult"})
		editorgui["musicselect"].active = false
		editorgui["menumaintab"] = gui:new("button", 18 * scale, 34 * scale, 41 * scale, (16*scale), "MAIN", menu_main, nil, true, true)
		editorgui["menusettings"] = gui:new("button", 184 * scale, 34 * scale, 58 * scale, (16*scale), "SETTINGS", menu_settings, nil, true, true)
		editorgui["menutiletab"] = gui:new("button", 70 * scale, 34 * scale, 41 * scale, (16*scale), "TILES", menu_tiles, nil, true, true)
		editorgui["menuentitytab"] = gui:new("button", 122 * scale, 34 * scale, 50 * scale, (16*scale), "ENTITIES", menu_entities, nil, true, true)
		editorgui["backgroundcolor"][1] = gui:new("textbox", 200* scale, 130 * scale, 20 * scale, 17.5 * scale, "Background Color", "255", 3, "numbers")
		editorgui["backgroundcolor"][2] = gui:new("textbox", 230* scale, 130 * scale, 20 * scale, 17.5 * scale, "Background Color", "255", 3, "numbers")
		editorgui["backgroundcolor"][3] = gui:new("textbox", 260* scale, 130 * scale, 20 * scale, 17.5 * scale, "Background Color", "255", 3, "numbers")
		for i = 1, 3 do
		editorgui["backgroundcolor"][i].showtext = false
		end
	end

	local x, y = love.mouse.getX(), love.mouse.getY() --X and y stuff
	properx = x + drawingx
	propery = y + drawingy
	clickx = math.floor(properx/(16*scale))
	clicky = math.floor(propery/(16*scale))

	editor_blockselected = 1 --Block selected
	rightclickfinishtimer = 0
end

function menu_settings()
if menuopen then
	if (editorgui["backgroundcolor"][1].text ~= "" and editorgui["backgroundcolor"][2].text ~= "" and editorgui["backgroundcolor"][3].text ~= "") then
			love.graphics.setBackgroundColor(tonumber(editorgui["backgroundcolor"][1].text), tonumber(editorgui["backgroundcolor"][2].text), tonumber(editorgui["backgroundcolor"][3].text))
		else
			love.graphics.setBackgroundColor(255, 255, 255)
	end
	editmenu = "settings"
	editorgui["loadmapsbutton"].active = true
	editorgui["loadmapsbutton"].textcolor = {255, 255, 255}
	for i = 1, 3 do
		editorgui["backgroundcolor"][i]:draw()
		editorgui["backgroundcolor"][i].textcolor = {255, 255, 255}
	end
	if editorgui["loadmapsbutton"].active then
			editorgui["loadmapsbutton"]:draw()
		end
	
	love.graphics.setColor(0, 0, 0)
		love.graphics.print("Music", 400*scale + 150*scale/2, 86*scale - 16*scale)
		love.graphics.setColor(255, 255, 255)
		--Background color
		if (editorgui["backgroundcolor"][1].text ~= "" and editorgui["backgroundcolor"][2].text ~= "" and editorgui["backgroundcolor"][3].text ~= "") then
			love.graphics.setColor(tonumber(editorgui["backgroundcolor"][1].text), tonumber(editorgui["backgroundcolor"][2].text), tonumber(editorgui["backgroundcolor"][3].text))
			love.graphics.rectangle("fill", 700*scale, 140*scale, (16*scale), 16*scale)
		end
		
		if editorgui["filebutton"] then
			for i, v in pairs(editorgui["filebutton"]) do
				if v.active then
					v:draw() --File buttons
				end
			end
		end
end
end

function menu_main()
if menuopen then
editmenu = "main"
editorgui["testbutton"].textcolor = {255, 255, 255}
editorgui["linkbutton"].textcolor = {255, 255, 255}
editorgui["exitbutton"].textcolor = {255, 255, 255}
editorgui["savebutton"].textcolor = {255, 255, 255}
editorgui["mapname"].textcolor = {255, 255, 255}
editorgui["packname"].textcolor = {255, 255, 255}
editorgui["musicselect"].textcolor = {255, 255, 255}
editorgui["mapwidth"].textcolor = {255, 255, 255}
editorgui["mapheight"].textcolor = {255, 255, 255}
editorgui["mapwidth"].textcolor = {255, 255, 255}
editorgui["mapheight"].textcolor = {255, 255, 255}
editorgui["scrollspeed"].textcolor = {255, 255, 255}
editorgui["testbutton"]:draw()
editorgui["linkbutton"]:draw()
editorgui["exitbutton"]:draw()
editorgui["mapname"].active = true
editorgui["packname"].active = true
editorgui["musicselect"].active = true
editorgui["mapwidth"].active = true
editorgui["mapheight"].active = true
editorgui["savebutton"].active = true
editorgui["testbutton"].active = true
if editorgui["savebutton"].active then
			editorgui["savebutton"]:draw()
		end
		
		if editorgui["mapname"].active then
			editorgui["mapname"]:draw()
		end
		if editorgui["packname"].active then
			editorgui["packname"]:draw()
		end
		if editorgui["musicselect"].active then
			editorgui["musicselect"]:draw()
		end
		if editorgui["mapwidth"].active then 
			editorgui["mapwidth"]:draw()
		end
		if editorgui["scrollspeed"].active then
			editorgui["scrollspeed"]:draw()
		end
		if editorgui["mapheight"].active then
			editorgui["mapheight"]:draw()
		end
		
	end
end

function menu_tiles()
	if menuopen then
		editmenu = "tiles"
		local numrows = 1
		local y = 1
		for i = 1, #blockquads do
			local is20 = false
			if math.ceil(i/20) == i/20 then
				is20 = true
			end
			if math.ceil(i/21) == i/21 then
				y = y+1
			end

			local number

			if not is5 then
				number = i-(math.floor(i/20)*20)
			else
				number = 20
			end

			offset = ((number-1)) * (17*scale)
		
			local x = offset + 16*scale
			local y = 50*scale + ((y-1)*17) --move it down on the y
		
			love.graphics.drawq(blockquads[i].image, blockquads[i].quad, x, y, 0, scale, scale)
		end
	end
	
end

function menu_entities()
	if menuopen then
		editmenu = "entities"
		local numrows = 1
		local y = 1
		for i = 1, #entityquads do
			local is22 = false
			if math.ceil(i/22) == i/22 then
				is22 = true
			end

			local number

			if not is22 then
				number = i-(math.floor(i/22)*22)
			else
				y = y+1
				number = i-(math.floor(i/22)*22)
				print(number)
			end

			offset = ((number-1)) * (17*scale)
		
			local x = offset + 16*scale
			local y = 50*scale + ((y-1)*17*scale) --move it down on the y
		
			love.graphics.drawq(entityquads[i].image, entityquads[i].quad, x, y, 0, scale, scale)
		end
end
	
	
end

function editor_update(dt)
	for i, v in pairs(editorgui) do
		if v.active and v.update then
			v:update(dt) --Update everything
		end
	end

	rightclickfinishtimer = rightclickfinishtimer + dt --Fixes bug where youd place a block after exiting the right click menu
	

	local x, y = love.mouse.getX(), love.mouse.getY()
	properx = x
	propery = y
	clickx = math.floor((drawingx + x)/(16*scale))
	clicky = math.floor((drawingy + y)/(16*scale))

	for i = 1, 3 do
		if editorgui["backgroundcolor"][i].text ~= "" then
			if tonumber(editorgui["backgroundcolor"][i].text) > 255 then
				editorgui["backgroundcolor"][i].text = 255
			end
		end
		if editorgui["backgroundcolor"][i].active then
			editorgui["backgroundcolor"][i]:update(dt)
		end
	end
	-- ^ Update background color
	
	if editorgui["linkbutton"].text == "Linking.." and 	mousestate == "Blocks" then
		editorgui["linkbutton"].text = "Link"
	end
	
	

	if love.mouse.isDown("l") then --Placing tiles
		if editor_state == "editing" then
			local check = true
			local x, y = love.mouse.getX(), love.mouse.getY()
			
			if editorgui["rightclick"] then
				if x > editorgui["rightclick"].x-drawingx and x < editorgui["rightclick"].x-drawingx + editorgui["rightclick"].width and y > editorgui["rightclick"].y and y < editorgui["rightclick"].y + editorgui["rightclick"].height * (#editorgui["rightclick"].items + 14) then
					check = false
				end
			end
			if check then
				if not editorgui["rightclick"] and rightclickfinishtimer > 0.5 then
					place_tile( clickx, clicky) --Place tile
				end
				setrightclicksettings()
			end
		end
	end
	if love.mouse.isDown("r") then --Removing tiles
		if mousestate == "Blocks" then
			map[clickx][clicky] = 0
		elseif mousestate == "Entities" then
			local bla = entitylist[editor_blockselected]
			if not rightclickvalues[bla] then
				entitymap[clickx][clicky][1] = 0
				entitymap[clickx][clicky][2] = 1
			end
		end
	end
	--Update the filebuttons
	if editorgui["filebutton"] then
		for i, v in pairs(editorgui["filebutton"]) do
			v:update(dt)
		end
	end

	mapmaxX = tonumber(editorgui["mapwidth"].text)
	--Cant move past the first block
	if drawingx < 16*scale and editor_state == "editing" then
		drawingx = 16*scale
	end
	--Left and right
	if love.keyboard.isDown("right") and editor_state == "editing" then
		drawingx = drawingx + 300 * tonumber(editorgui["scrollspeed"].text) * dt
	end
	if love.keyboard.isDown("left") and editor_state == "editing" then
		drawingx = drawingx - 300 * tonumber(editorgui["scrollspeed"].text) * dt
	end
	if love.keyboard.isDown("down") and editor_state == "editing" and drawingy < tonumber(editorgui["mapheight"].text) * (16*scale) - love.graphics.getHeight() then
		drawingy = drawingy + 300 * tonumber(editorgui["scrollspeed"].text) * dt
	end
	if love.keyboard.isDown("up") and editor_state == "editing" and drawingy > 0 then
		drawingy = drawingy - 300 * tonumber(editorgui["scrollspeed"].text) * dt
	end
end

function editor_mousepressed(x, y, button)
	editorgui["savebutton"].actionargs = {"maps/" .. editorgui["packname"].text .. "/" .. editorgui["mapname"].text} --Make sure the savebutton arguments are updated.
	for i, v in pairs(editorgui) do
		if v.active and v.mousepressed and not v.rightclick then
			v:mousepressed(x, y, button) --Pushing buttons.
		end
	end
	if editorgui then
		if editorgui["rightclick"] then
			editorgui["rightclick"]:mousepressed(x, y, button)
		end
	end
	if editorgui then --Background color pressed
		for i = 1, 3 do
			if editorgui["backgroundcolor"][i].active then
				editorgui["backgroundcolor"][i]:mousepressed(x, y, button) --Backgroundcolor buttons
			end
		end
	end
	if editorgui and editorgui["filebutton"] then
		for i, v in pairs(editorgui["filebutton"]) do --Load file buttons
			v:mousepressed(x, y, button)
		end
	end
	
	if button == "wd" then
		editor_blockselected = editor_blockselected - 1 --Move down
		if mousestate == "Blocks" then
			if editor_blockselected < 0 then
				editor_blockselected = #blockquads
			end
		elseif mousestate == "Entities" then
			if editor_blockselected < 0 then
				editor_blockselected = #entityquads
			end
		end
	elseif button == "wu" then
		editor_blockselected = editor_blockselected + 1 --Move up
		if mousestate == "Blocks" then
			if editor_blockselected > #blockquads then
				editor_blockselected = 0
			end
		elseif mousestate == "Entities" then
			if editor_blockselected > #entityquads then
				editor_blockselected = 0
			end
		end
	end
	
	if editor_state == "editing" then
		if button == "l" then --Placing blocks Does a bunch of checks first though
			local check = true
			if editorgui then
				if editorgui["rightclick"] then
					local x, y = love.mouse.getX(), love.mouse.getY()
					if x > editorgui["rightclick"].x - drawingx and x < editorgui["rightclick"].x-drawingx + editorgui["rightclick"].width and y > editorgui["rightclick"].y and y < editorgui["rightclick"].y + editorgui["rightclick"].height * (#editorgui["rightclick"].items + 1) then
						check = false
					end
				end
				if check then
					if not editorgui["rightclick"] and rightclickfinishtimer > 0.5 then
						place_tile(clickx, clicky)
					end
					setrightclicksettings()
				end
			end
		elseif button == "r" and y > 16*scale then --Erase/rightclick
			local bla = entitymap[clickx][clicky][1]
			local tile = entitylist[bla]
			if rightclickvalues[tile] and mousestate == "Entities" then
				editorgui["rightclick"] = gui:new("dropdown", clickx * (16*scale), clicky * (16*scale), 150 * scale, 33 * scale, tile, rightclickvalues[tile])
				editorgui["rightclick"].value = rightclickvalues[tile][entitymap[clickx][clicky][2]]
				editorgui["rightclick"].rightclick = true
				editorgui["rightclick"].open = true
			end
			if mousestate == "Blocks" then
				map[clickx][clicky] = 0
			end
			if mousestate == "link" and linkname[tile] then
				print(clickx, clicky)
				print(entitymap[clickx][clicky][3])
				editorgui["linkname"] = gui:new("textbox", clickx * (16*scale), clicky * (16*scale), 133 * scale, 33 * scale, "Link Name", entitymap[clickx][clicky][3], 30, "all")
				print("LET'S LINK THIS BITCH")
			end
		end
	end
	if editorgui then
		if editorgui["rightclick"] then
			if editorgui["rightclick"].kill then
				rightclickfinishtimer = 0
				setrightclicksettings()
				editorgui["rightclick"] = nil
			end
		end
	end
	if menuopen then
		if x > 17*scale and y > 48*scale then
			local x = math.floor(love.mouse.getX()/(16*scale))
			local y = math.floor(love.mouse.getY()/(16*scale))-2
			if editmenu == "blocks" then
				if x+((y-1)*1) <= #blockquads then
					editor_blockselected = x((y-1)*22)
				end
			else
				if x+((y-1)*1) <= #entityquads then
					editor_blockselected = x+((y-1)*22)
				end
			end
		end
	end
end

function editor_draw()

	
		


	if editor_state == "editing" then
		love.graphics.push()
		love.graphics.translate(-drawingx, -drawingy) --Move the map forward and backward.
		love.graphics.setColor(0,0,0)
		love.graphics.setColor(255, 255, 255) 
		--Draw the block at the mouse position.
		if editor_blockselected ~= 0 and mousestate == "Blocks" and editor_blockselected <= #blockquads then
			love.graphics.drawq(blockquads[editor_blockselected].image, blockquads[editor_blockselected].quad, (clickx * (16*scale)), (clicky * (16*scale)), 0, scale)
		end
		if editor_blockselected > #blockquads and mousestate == "Blocks" then
			editor_blockselected = math.min(#blockquads, editor_blockselected)
		end
		
		if editor_blockselected ~= 0 and mousestate == "Entities" then
			local check = true
			if editorgui["rightclick"] then
				local x, y = love.mouse.getX(), love.mouse.getY()
				if x > editorgui["rightclick"].x-drawingx and x < editorgui["rightclick"].x-drawingx + editorgui["rightclick"].width and y > editorgui["rightclick"].y and y < editorgui["rightclick"].y + editorgui["rightclick"].height * #editorgui["rightclick"].items then
					check = false
				end
			end
			if check and editor_blockselected <= #entityquads  then
				love.graphics.drawq(entityquads[editor_blockselected].image, entityquads[editor_blockselected].quad, (clickx * (16*scale)), (clicky * (16*scale)), 0, scale)
			end
			if check and editor_blockselected > #entityquads and mousestate == "Entities" then
			editor_blockselected = math.min(#entityquads, editor_blockselected)
			end
		end
		
		
		--Draw map
		for x = 1, #map do
			for y = 1, #map[x] do
				local number = map[x][y]
				if number ~= 0 then
					love.graphics.drawq(blockquads[number].image, blockquads[number].quad, x * 16 * scale, y * 16 * scale, 0, scale) --Draw the whole map
				end
			end
		end
		--Draw entitymap
		love.graphics.setColor(255, 255, 255, 150)
		for x = 1, #entitymap do
			for y = 1, #entitymap[x] do
				local number = entitymap[x][y][1]
				if number ~= 0 then
					love.graphics.drawq(entityquads[number].image, entityquads[number].quad, (x * 16)*scale, (y * 16)*scale, 0, scale) --Draw the entity map
				end
			end
		end
		
	
	
		love.graphics.pop()
		
		
		love.graphics.setColor(0, 0, 0)
		love.graphics.push()
		love.graphics.translate(-drawingx, 0) --Not translating these effeciently but oh well.
		love.graphics.rectangle("fill", (editorgui["mapwidth"].text * (16*scale)) + 16*scale, 0, 64, love.graphics.getHeight())
		love.graphics.print("This is the map end. Blocks placed along or beyond the black line will not be saved.", (editorgui["mapwidth"].text*(16*scale)) + 140, 400 )
		if editorgui["rightclick"] then
			editorgui["rightclick"]:draw()
		end
		if editorgui["linkname"] then
			editorgui["linkname"]:draw()
		end
		love.graphics.print(#map, love.graphics.getWidth()-10*scale, love.graphics.getHeight()-20*scale)
		love.graphics.print(#map[1], love.graphics.getWidth()-10 * scale, love.graphics.getHeight()-10*scale)
		love.graphics.pop()
	end
	
	if editor_state == "menu" then
		
		
	end
	
	
end

function editor_menu()
	if menuopen then
		open_menu()
		editorgui["menumaintab"].textcolor = {255, 255, 255}
		editorgui["menutiletab"].textcolor = {255, 255, 255}
		editorgui["menuentitytab"].textcolor = {255, 255, 255}
		editorgui["menusettings"].textcolor = {255, 255, 255}
		editorgui["menumaintab"]:draw()
		editorgui["menutiletab"]:draw()
		editorgui["menuentitytab"]:draw()
		editorgui["menusettings"]:draw()
		editorgui["menumaintab"].active = true
		editorgui["menutiletab"].active = true
		editorgui["menuentitytab"].active = true
		editorgui["menusettings"].active = true
	end
end

function editor_switchstates(state)
	if state == "menu" then
		editor_state = "editing"
		--reset buttons and stuff
		
		editorgui["mapwidth"].active = false
		editorgui["savebutton"].active = false
		editorgui["mapname"].active = false
		editorgui["packname"].active = false
	
		editorgui["mapheight"].active = true
		editorgui["menumaintab"].active = false
		editorgui["menutiletab"].active = false
		editorgui["menuentitytab"].active = false
		
	elseif state == "editing" then
		editor_state = "menu"
		love.graphics.setBackgroundColor(255, 255, 255)
		for i, v in pairs(editorgui) do
			v.active = true
		end
		editorgui["testbutton"].active = false
	end
end

function open_menu()
	mousestate = "menu"
	love.graphics.rectangle("fill", 12*scale, 28*scale, 376*scale, 184*scale)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", 16*scale, 32*scale, 368*scale, 176*scale)
end

function editor_keypressed(key, unicode)
	for i, v in pairs(editorgui) do
		if v.keypressed and v.active then
			v:keypressed(key, unicode) --Pressing some keys
		end		
	end
	for i = 1, 3 do
		if editorgui["backgroundcolor"][i].active then
			editorgui["backgroundcolor"][i]:keypressed(key, unicode)
		end
	end
	if key == "q" then
		menuopen = not menuopen
		if not menuopen then
			editorgui["menumaintab"].active = false
			editorgui["menutiletab"].active = false
			editorgui["menuentitytab"].active = false
			if editmenu == "tiles" then
				mousestate = "Blocks"
			else
				mousestate = "Entities"
			end
			if editorgui["linkbutton"].text == "Linking.." then
				mousestate = "link"
			end
		end
	end
	if key == "return" then --Remake map
		if editorgui["mapwidth"].selected or editorgui["mapheight"].selected then
			editorgui["mapwidth"].selected = false
			editorgui["mapheight"].selected = false
			if #map > tonumber(editorgui["mapwidth"].text) then
				print(true)
				print(tonumber(editorgui["mapwidth"].text), #map)
				for x = #map, tonumber(editorgui["mapwidth"].text),  -1 do
					print("lol")
					table.remove(map, x)
				end
			end
			for x = 1, tonumber(editorgui["mapwidth"].text) do
				--Onky make a new block if one doesnt exist.
				if not entitymap[x] then
					entitymap[x] = {}
				end
				if not map[x] then
					map[x] = {}
				end
				for y = 1, tonumber(editorgui["mapheight"].text) do
					if not entitymap[x][y] then
						entitymap[x][y] = {}
						entitymap[x][y][1] = 0
						entitymap[x][y][2] = 1
					end
					if not map[x][y] then
						map[x][y] = 0
					end
				end
			end
		end
		if editorgui["linkname"] then
			local x, y = math.floor(editorgui["linkname"].x/(16*scale)), math.floor(editorgui["linkname"].y/(16*scale))
			entitymap[x][y][3] = editorgui["linkname"].text
			print(editorgui["linkname"].text)
			editorgui["linkname"] = nil
		end
		local number = #entitymap+1
		map[number] = {}
		entitymap[number] = {}
		for i = 1, tonumber(editorgui["mapheight"].text) do
			map[number][i] = 0
			entitymap[number][i] = {}
			entitymap[number][i][1] = 0
			entitymap[number][i][2] = 1
		end
		drawingy = tonumber(editorgui["mapheight"].text) * (16*scale) - love.graphics.getHeight()
	end

end

function exit_editor()
	gamestate = "menu" --Stop editor stuff
	editorgui = nil
	for i, v in pairs(menugui) do
		if v.text then
			v.active = true
		end
	end
	menu_load(false)
	playloop = false
	hasedited = false
	drawingx = 0
end

function load_map(file) --Self explanatory --What ross? This isnt self explanatory. I have no idea what i WAS THINKING.
	local loadmap = love.filesystem.read("/maps/" .. editorgui["packname"].text .. "/" .. file)
	local config = loadmap:split(";")
	--Reset all gui with new config.
	for i = 1, 3 do
		editorgui["backgroundcolor"][i].text = tostring(config[i+2])
	end
	editorgui["mapwidth"].text = config[2]
	if config[6] then
		editorgui["musicselect"].value = config[6]
	end
	if config[7] then
		editorgui["mapheight"].text = config[7]
	else
		editorgui["mapheight"].text = "14"
	end
	--Blank map/
	map = {}
	for x = 1, tonumber(editorgui["mapwidth"].text) do
		map[x] = {}
		entitymap[x] = {}
		for y = 1, tonumber(editorgui["mapheight"].text) do
			map[x][y] = 0
			entitymap[x][y] = {}
			entitymap[x][y][1] = 0
			entitymap[x][y][2] = 1
		end
	end
	editorgui["mapname"].text = file
	local xsplit = loadmap:split(",")
	for y = 1, tonumber(editorgui["mapheight"].text) do
		for x = 1, tonumber(editorgui["mapwidth"].text) do
			--Gets current y * the width + the current block
			local fakesplit = xsplit[((y-1)*tonumber(editorgui["mapwidth"].text))+x]:split("name") --Hard algorithim is hard.
			local split = fakesplit[1]:split("-")
			map[x][y] = tonumber(split[1])
			if split[2] then
				entitymap[x][y][1] = tonumber(split[2])
			else
				entitymap[x][y][1] = 0
			end
			if split[3] then
				entitymap[x][y][2] = tonumber(split[3])
			else
				entitymap[x][y][2] = 1
			end
			if fakesplit[2] then
				entitymap[x][y][3] = fakesplit[2]
			end
		end
	end
end

function show_maps()
	editor_showfiles = love.filesystem.enumerate("/maps/" .. editorgui["packname"].text)
	editorgui["filebutton"] = {}
	for i = 1, #editor_showfiles do
		if editor_showfiles[i] ~= ".DS_Store" then
			table.insert(editorgui["filebutton"], gui:new("button", (((i-1) * 150) + 8*scale) * scale, 150 * scale, 200, 17.5*scale, editor_showfiles[i], load_map, {editor_showfiles[i]}, false))
		end
	end
	for i, v in pairs(editorgui["filebutton"]) do
		v.active = true
	end
	for i = 1, #editorgui["filebutton"] do
		editorgui["filebutton"][i].textcolor = {255, 255, 255}
		if i == 1 then
			editorgui["filebutton"][i].width = string.len(editorgui["filebutton"][i].text) * 8 * scale
			editorgui["filebutton"][i].x = 8*scale
		else
			editorgui["filebutton"][i].x = editorgui["filebutton"][i-1].x + editorgui["filebutton"][i-1].width + 8*scale
			editorgui["filebutton"][i].width = string.len(editorgui["filebutton"][i].text) * 15* scale
		end
	end
end

function save_map(file)
	local s = ""
	s = s .. "name=" .. editorgui["packname"].text .. "\n"
	love.filesystem.mkdir( "/maps/" .. editorgui["packname"].text)
	
	local smap = love.filesystem.newFile(file) --Save map
	local open = smap:open("w")
	for y = 1, tonumber(editorgui["mapheight"].text) do
		for x = 1, tonumber(editorgui["mapwidth"].text) do
			if entitymap[x][y][1] ~= 0 then
				if entitymap[x][y][2] ~= 0 then
					if entitymap[x][y][3] then
						smap:write(map[x][y] .. "-" .. entitymap[x][y][1] .. "-" .. entitymap[x][y][2] .. "name" .. entitymap[x][y][3] .. ",")
					else
						smap:write(map[x][y] .. "-" .. entitymap[x][y][1] .. "-" .. entitymap[x][y][2] .. ",")
					end
				else
					smap:write(map[x][y] .. "-" .. entitymap[x][y][1] .. ",")
				end
			else
				smap:write(map[x][y] .. ",")
			end
		end
	end
	smap:write(";" .. tonumber(editorgui["mapwidth"].text))
	for i = 1, 3 do
		smap:write(";" .. tonumber(editorgui["backgroundcolor"][i].text))
	end
	smap:write(";" .. editorgui["musicselect"].value)
	smap:write(";" .. editorgui["mapheight"].text)
	print(file)
end

function fillmap()
	for y = 1, tonumber(editorgui["mapheight"].text) do
		for x = 1, tonumber(editorgui["mapwidth"].text) do
			map[x][y] = editor_blockselected
		end
	end
end

function erasemap()
	for y = 1, tonumber(editorgui["mapheight"].text) do
		for x = 1, tonumber(editorgui["mapwidth"].text) do
			map[x][y] = 0
			entitymap[x][y][2] = 1
			entitymap[x][y][1] = 0
		end
	end
end

function test_level()
	editormode = true
	gamestate = "game"
	hasedited = true
	game_load()
end

function switch_link()
	link = not link
	if mousestate == "Entities" or mousestate == "menu" then
		editorgui["linkbutton"].text = "Linking.."
		mousestate = "link"
	else
		editorgui["linkbutton"].text = "Link"
		mousestate = ""
	end
end

function place_tile(x, y)
	if mousestate == "Blocks" then
		map[x][y] = editor_blockselected
	end
	if mousestate == "Entities" then
		if y ~= 0 then
			entitymap[x][y][1] = editor_blockselected
			entitymap[x][y][2] = 1
			local number = entitymap[x][y][1]
			local name = entitylist[number]
			if linkname[name] then
				entitymap[x][y][3] = linkname[name][1]
				print(entitymap[x][y][3], linkname[name][1])
			end
		end
	end
	
end

function setrightclicksettings()
	if editorgui["rightclick"] then
		local x, y = math.floor(editorgui["rightclick"].x/(16*scale)), math.floor(editorgui["rightclick"].actualy/(16*scale))
		local bla = entitymap[x][y][1]
		local tile = entitylist[bla]
		for i = 1, #editorgui["rightclick"].items do
			if editorgui["rightclick"].items[i] == editorgui["rightclick"].value then
				entitymap[x][y][2] = i
				break
			end
		end
		editorgui["rightclick"] = nil
	end
end