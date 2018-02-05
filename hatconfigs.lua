hats = {}
hatoffsets = {}
hatoffsets["all"] = {0, 0}

table.insert(hats, 1, {x = 0, y = 0, height = -6, name = "Pot", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/pot.png") })

table.insert(hats, 2, {x = 0, y = 0, height = -16, name = "Motherducker", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/motherducker.png") })

table.insert(hats, 3, {x = 0, y = 0, height = -6, name = "Knight", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/knight.png") })

table.insert(hats, 4, {x = 0, y = 0, height = -8, name = "Tophat", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/tophat.png") })

table.insert(hats, 5, {x = 0, y = 0, height = -5, name = "Radio", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/radio.png") })

table.insert(hats, 6, {x = 2, y = 0, height = -9, name = "Mexico", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/mexico.png") })

table.insert(hats, 7, {x = 0, y = 0, height = -7, name = "Visor", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/epicvisor.png") })

table.insert(hats, 8, {x = 3, y = 0, height = -8, name = "China", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/china.png") })

table.insert(hats, 9, {x = 5, y = 0, height = -5, name = "Developer", offsetsX = 0, graphic = love.graphics.newImage("graphics/hats/dev.png") })

table.insert(hats, 10, {x = 0, y = 0, height = -8, name = "Pyro", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/pyro.png") })

table.insert(hats, 11, {x = 5, y = 0, height = -8, name = "Spy", offsetsX = 8.5, graphic = love.graphics.newImage("graphics/hats/zespy.png") })

table.insert(hats, 12, {x = 0, y = 0, height = -8, name = "Scout", offsetsX = 13, graphic = love.graphics.newImage("graphics/hats/scout.png") })

for i = 1, #hats do
	hats[i].graphic:setFilter("nearest","nearest")
end