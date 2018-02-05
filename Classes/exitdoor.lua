exitdoor = class:new()
exitdoorimg = love.graphics.newImage("graphics/exitdoor.png")
exitdoorquad = love.graphics.newQuad(0, 0, 16, 29, 16, 29)


function exitdoor:init(x, y)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 29*scale
	self.xSpeed = 0
	self.y = y + 3*scale
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.passive = true
	self.mask = {"turtle"}
end

function exitdoor:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(exitdoorimg, exitdoorquad, self.x, self.y, 0, scale)
	love.graphics.pop()
end