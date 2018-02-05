water = class:new()
waterimg = love.graphics.newImage("graphics/water.png")
waterquads = love.graphics.newQuad(0, 0, 16, 16, 16, 16)



function water:init(x, y)
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
	self.timer = 0
	self.mask = {"turtle"}
end

function water:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(waterimg, waterquads, self.x, self.y, 0, scale)
	love.graphics.pop()
end

function water:update(dt)

end