coin = class:new()
coinimage = love.graphics.newImage("graphics/coin.png")
coinquad = love.graphics.newQuad(0, 0, 16, 16, 16, 16)

function coin:init(x, y, time, name)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 16*scale
	self.xSpeed = 0
	self.y = y 
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.passive = true
	self.mask = {"turtle"}
	self.remove = false
end

function coin:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(coinimage, coinquad, self.x, self.y, 0, scale)
	love.graphics.pop()
end