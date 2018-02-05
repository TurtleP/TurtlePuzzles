key = class:new()
keyimg = love.graphics.newImage("graphics/key.png")
keyquad = love.graphics.newQuad(0, 0, 9, 4, 9, 4)


function key:init(x, y)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 9*scale
	self.height = 4*scale
	self.xSpeed = 0
	self.y = y
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.passive = true
	self.mask = {"turtle"}
end

function key:draw()

	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.setColor(255, 255, 255)
	love.graphics.drawq(keyimg, keyquad, self.x, self.y, 0, scale)
		love.graphics.push()
	love.graphics.pop()
end