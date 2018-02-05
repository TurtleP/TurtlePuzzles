lava = class:new()
lavaimg = love.graphics.newImage("graphics/lava1.png")
watersimg = love.graphics.newImage("graphics/water1.png")
lavaquads = {}
for i = 1, 2 do
	lavaquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 11, 33, 11)
end



function lava:init(x, y, liquid)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 32*scale
	self.xSpeed = 0
	self.y = y + 5*scale
	self.inAir = false
	self.mask = {"turtle"}
	self.static = true
	self.quad = 1
	self.liquid = liquid
	self.offsetX, self.offsetY = 0, 0
	self.passive = false
	self.close = 0
	self.passive = false
	self.timer = 0
end

function lava:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	if self.liquid == 1 then
	love.graphics.drawq(lavaimg, lavaquads[self.quad], self.x, self.y, 0, scale)
	else 
	love.graphics.drawq(watersimg, lavaquads[self.quad], self.x, self.y, 0, scale)
	end
	love.graphics.pop()
end

function lava:update(dt)
	self.timer = self.timer + dt
	if self.timer >= 0 and self.timer < 1 then
		self.quad = 1
	else 
		self.quad = 2
	end
	if self.timer > 2 then
		self.timer = 0
	end
end