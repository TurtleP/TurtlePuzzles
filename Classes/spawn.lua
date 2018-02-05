spawn = class:new()
spawnimg = love.graphics.newImage("graphics/spawn.png")
spawnquad = love.graphics.newQuad(0, 0, 16, 16, 16, 16)


function spawn:init(x, y)
	self.x = x
	self.active = false
	self.ySpeed = 0
	self.width = 0
	self.height = 0
	self.xSpeed = 0
	self.y = y
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.passive = true
	self.mask = {"turtle"}
end