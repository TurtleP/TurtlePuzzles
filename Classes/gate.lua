gate = class:new()
gateimg = love.graphics.newImage("graphics/gate.png")
gatequad = love.graphics.newQuad(0, 0, 16, 32, 16, 32)


function gate:init(x, y)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 32*scale
	self.xSpeed = 0
	self.y = y
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.passive = false
	self.starty = y
	self.close = 0
	self.mask = {"turtle"}
	self.name = name
	self.passive = false
	self.locked = true
end

function gate:draw()
	love.graphics.translate(self.offsetX, self.offsetY)
	if self.locked then
		love.graphics.setColor(255, 255, 255)
		love.graphics.drawq(gateimg, gatequad, self.x, self.y, 0, scale)
	else
		
	end
		love.graphics.push()	
		love.graphics.pop()
end

function gate:update(dt)
	if not self.locked then
		self.passive = true
	end	
end