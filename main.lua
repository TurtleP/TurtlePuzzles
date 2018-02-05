love.graphics.setDefaultImageFilter("nearest", "nearest") --Make it so images arent blurry when scaled up

--REQUIRE ALL DEM FILES!
require "hatconfigs"



--States
require "States/game"
require "States/intro"
require "States/editor"
require "States/intro"
require "States/menu"
require "States/settings"
require "States/levelscreen"

--Entities/Classes
require "Classes/class"

require "Classes/turtle"
require "Classes/entity"
require "Classes/gui"
require "Classes/quad"
require "Classes/block"
require "Classes/physics"
require "Classes/button"
require "Classes/spawn"
require "Classes/ladder"
require "Classes/spikes"
require "Classes/door"
require "Classes/coin"
require "Classes/lava"
require "Classes/water"
require "Classes/exitdoor"
require "Classes/gate"
require "Classes/key"
require "Classes/lever"
require "Classes/spring"
require "Classes/permabutton"
require "Classes/fakewall"
require "Classes/invisowall"
require "Classes/teleporter"
require "Classes/sign"
require "Classes/crate"
require "Classes/floorbutton"
require "Classes/trigger"

--MISC
require "conf"
require "musicloader"
require "variables"
require "mask"



function love.load()
		
	--achievements--
	ach = { {deaths == 10,50,1,"Die 10 times","It was an accident!"}, {emeralds == 5,100,2,"Collect 5 Emeralds","Emerald digger"}, {bounces == 10, 50, 3, "Bounce on springs 10 times", "Too Much Fun"}}

	achcompleted = {false, false, false}
	
	mappack = "campaign"
	currpack = 1
	--loadconfig()
	
	--HATNINJA'S AWESOME HAT STUFF HERE--
	hatimg = {}
	--hatnames = {"tophat", "pyro", "knight", "scout", "epicvisor", "radio", "mexico", "china", "cowboy", "zespy", "dev", "motherducker"} --Collect strings of filenames!
	--for i = 1, #hatnames do
	--	hatimg[i] = love.graphics.newImage("graphics/hats/" .. hatnames[i] .. ".png") --place the hats inside the table!
	--end
	mappacktable = {}
	hatquads = {} --SHIT SO MANY HAT QUADS!!!!!!!
	hatquads[1] = love.graphics.newQuad(0,0,12,5,12,5)
	hatquads[2] = love.graphics.newQuad(0,0,12,6,12,6)
	hatquads[3] = love.graphics.newQuad(0,0,11,10,12,10)
	hatquads[4] = love.graphics.newQuad(0,0,12,11.5,12,11.5)
	hatquads[5] = love.graphics.newQuad(0,0,13,9,13,9)
	hatquads[6]  = love.graphics.newQuad(0,0,13,10,13,10)
	hatquads[7]  = love.graphics.newQuad(0,0,13,10,13,10)
	hatquads[8]  = love.graphics.newQuad(0,0,14,9,14,9)
	hatquads[9]  = love.graphics.newQuad(0,0,15.5,18.5,15.5,18.5)
	hatquads[10]  = love.graphics.newQuad(0,0,15.5,18,15.5,18)
	hatquads[11]  = love.graphics.newQuad(0,0,14.5,9,14.5,9)
	hatquads[12]  = love.graphics.newQuad(0,0,16.5,13.5,16.5,13.5)
	hatquads[13]  = love.graphics.newQuad(0,0,16,22,16,22)
	
	if love.filesystem.exists("settings.txt") then
		loadconfig()
		firstplay = false --if true, play the intro.
	else
		hat = 0
		volume = 2
		oldsprites = false
		firstplay = true
	end
	
	--[[if love.filesystem.exists("/hats") then
		hatstable = love.filesystem.enumerate("/hats")
		loadhats()
	end]]
	if mode == "DLC" then
	mappackstable = love.filesystem.enumerate("Levels/")
	maxlevels = love.filesystem.enumerate("Levels/" .. mappack)
	else 
	mappackstable = love.filesystem.enumerate("/maps/")
	maxlevels = love.filesystem.enumerate("/maps/" .. mappack)
	end
		menuopened = false

	
	
		--soundenabled = true
	

	--loadconfig()
	--END--
	
	blockimage = love.graphics.newImage("graphics/tileset.png")
	--gamestate = "game"

	scale = 2.5
		playloop = false
	loopedyet = false

	dropdownimage = love.graphics.newImage("graphics/dropdown.png")
	caption = "Turtle: Puzzles "
	love.graphics.setCaption(caption)
	icon = love.graphics.newImage("graphics/icon.png")
	love.graphics.setIcon(icon)
	
	--GRAPHICS--
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

	titlegui =  love.graphics.newImage("graphics/logo.png")
	turtleregister = love.graphics.newImage("graphics/turtleregister.png")
	--AUDIO--
	jumps = love.audio.newSource("sounds/jump.ogg", "static")
	purchase = love.audio.newSource("sounds/purchase.ogg", "static")
	decline = love.audio.newSource("sounds/decline.ogg", "static")
	push = love.audio.newSource("sounds/push.ogg", "static")
	tick = love.audio.newSource("sounds/tick.ogg", "static")
	tock = love.audio.newSource("sounds/tock.ogg", "static")
	death = love.audio.newSource("sounds/death.ogg", "static")
	gameover = love.audio.newSource("sounds/gameover.ogg", "static")
	close = love.audio.newSource("sounds/close.ogg", "static")
	coins = love.audio.newSource("sounds/coin.ogg", "static")
	swimming = love.audio.newSource("sounds/swim.ogg", "static")
	finishmusic = love.audio.newSource("sounds/done.ogg", "static")
	title_intro = love.audio.newSource("sounds/title_intro.ogg", "static")
	teleportsnd = love.audio.newSource("sounds/teleport.ogg", "static")
	springsnd = love.audio.newSource("sounds/spring.ogg", "static")
	gainlife = love.audio.newSource("sounds/1up.ogg", "static")
	--FONT STUFF--
	tinyfont = love.graphics.newFont("Fonts/TTIB.TTF", 3*scale)
	smallfont = love.graphics.newFont("Fonts/TTIB.TTF", 9*scale)
	mediumfont = love.graphics.newFont("Fonts/TTIB.TTF", 13*scale)
	largefont = love.graphics.newFont("Fonts/TTIB.TTF", 15*scale)
	hugefont = love.graphics.newFont("Fonts/TTIB.TTF", 27*scale)

	local find = love.filesystem.exists("/maps")
	if not find then
		love.filesystem.mkdir("/maps")
	end
	print(love.filesystem.getSaveDirectory( ))

	blockquads = {}

	tilesetimg = love.graphics.newImage("graphics/tileset.png") --Make block quads
	local tilesetdata = love.image.newImageData("graphics/tileset.png")
	local imgwidth, imgheight = tilesetimg:getWidth(), tilesetimg:getHeight()
	local width, height = math.ceil(imgwidth/17), math.ceil(imgheight/17)

	for y = 1, height do
		for x = 1, width do
			table.insert(blockquads, quad:new(tilesetimg, tilesetdata, x, y, imgwidth, imgheight)) --Make images for all the blocks
		end
	end

		

	entityquads = {}


	entityimg = love.graphics.newImage("graphics/entityimg.png") --Make entity quads.
	local entitydata = love.image.newImageData("graphics/entityimg.png")
	local imgwidth, imgheight = entityimg:getWidth(), entityimg:getHeight()
	local width, height = math.ceil(imgwidth/17), math.ceil(imgheight/17)


	for y = 1, height do
		for x = 1, width do
			table.insert(entityquads, entity:new(entityimg, entitydata, x, y, imgwidth, imgheight)) --Same but with entities
			entityquads[#entityquads]:settype(#entityquads)
		end
	end
	
	rightcontrol = {}
	leftcontrol = {}
	upcontrol = {}
	downcontrol = {}
	usecontrol = {}
	for i = 1, 4 do
	usecontrol[i] = "f"
	leftcontrol[i] = "a"
	rightcontrol[i] = "d"
	upcontrol[i] = "w"
	downcontrol[i] = "s"
	end
	--game_load()

	screen_height = scale*16*14
	screen_width = scale*16*25
	love.graphics.setMode(screen_width, screen_height) 
	love.graphics.setBackgroundColor(0, 0, 0)
	gamestate = "intro"
	intro_load()
end

function loadhats()
	local s = love.filesystem.read("/hats/" .. hatstable .. ".txt")
	s1 = s:split(";")
		for i = 1, #s1-1 do
			s2 = s1[i]:split(":")
		if s2[1] == "hat" then
			local hatno = tonumber(s2[2])
			table.insert(hatno, hatquads)
		end
		if s2[1] == "graphic" then
			local hatgraphic = s2[2]
			table.insert(hatgraphic, hatnames)
		end
	end
end

function loadconfig()
	local s = love.filesystem.read("settings.txt")
	
	s1 = s:split(";")
	for i = 1, #s1-1 do
		s2 = s1[i]:split(":")
	if s2[1] == "hat" then
		local hatno = tonumber(s2[2])
		hat = hatno
	end
	if s2[1] == "volume" then
		vol = tonumber(s2[2])
		volume = vol
	end
	if s2[1] == "turtlecoins" then
		coins = tonumber(s2[2])
		turtlecoins = coins
	end
	if s2[1] == "oldsprites" then
		local sp = s2[2]
		oldsprites = sp
		if oldsprites == "NEW" then
			oldsprites = false
		else
			oldsprites = true
		end
	end
	if s2[1] == "audio" then
		sp = s2[2]
		audioon = sp
		if audioon == "ON" then
			audioon = true
			soundenabled = true
		else
			audioon = false
			soundenabled = false
		end
	end
	end
end

function love.update(dt)
	if os.getenv("WINDIR") then 
		dt = math.min(0.01666667, dt)
	elseif os.getenv("HOME") then
		--don't allow update min
	end
	if audioenabled then
		soundenabled = true
	else
		soundenabled = false
	end
	love.graphics.setIcon(icon)
	if gamestate == "game" then
		game_update(dt)
	end
	if gamestate == "intro" then
		intro_update(dt)
	end
	if gamestate == "editor" then
		editor_update(dt)
	end
	if gamestate == "menu" then
		menu_update(dt)
	end
	if gamestate == "settings" then
		settings_update(dt)
	end
	if gamestate == "loadlevel" then
		levelscreen_update(dt)
	end
end


function love.draw()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	if gamestate == "game" then
		game_draw()
		game_draw_HUD()
	end
	if gamestate == "intro" then
		intro_draw()
	end
	if gamestate == "editor" then
		editor_draw()
		editor_menu()
		if editmenu == "main" then
		menu_main()
		end
		if editmenu == "tiles" then
		menu_tiles()
		elseif editmenu == "entities" then
		menu_entities()
		elseif editmenu == "settings" then
		menu_settings()
		end
	end
	if gamestate == "menu" then
		menu_draw()
	end
	if gamestate == "loadlevel" then
		levelscreen_draw()
	end
	if gamestate == "settings" then
		settings_draw()
		settings_draw_hats()
		draw_hat()
		if settingsstate == "store" then
			storeopen()
		end
	end
end

function love.keypressed(key, unicode)
	if gamestate == "game" then
		game_keypressed(key, unicode)
	end
	if gamestate == "editor" then
		editor_keypressed(key, unicode)
	end
	if gamestate == "menu" then
		menu_keypressed(key)
	end
	if gamestate == "settings" then
		settings_keypressed(key, unicode)
	end
	if gamestate == "loadlevel" then
		levelscreen_keypress(key, unicode)
	end
end

function love.mousepressed(x, y, button)
	if gamestate == "editor" then
		editor_mousepressed(x, y, button)
	end
	if gamestate == "menu" then
		menu_mousepressed(x, y, button)
	end
	if gamestate == "settings" then
		settings_mousepressed(x, y, button)
	end
	if gamestate == "game" then
		game_mousepressed(x, y, button)
	end
end

--Extra commonly used functions


function string:split(delimiter) --Not by me
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

function round (x)
  if x >= 0 then
    return math.floor (x + 0.5)
  end  -- if positive

  return math.ceil (x - 0.5)
end -- function round