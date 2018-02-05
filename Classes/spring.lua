spring = class:new()
springquadimage = love.graphics.newImage("graphics/spring.png")
springquads = {}
for i = 1, 5 do
	springquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, 67, 16)
end

function spring:init(x, y)
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
	self.timer = 0
	self.push = false
	self.mask = {"turtle", "crate"}
end

function spring:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(springquadimage, springquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

function spring:update(dt)
	if self.push then
		self.timer = self.timer + dt
		if self.timer >= 0 and self.timer < .1 then
			self.quad = 2
		elseif  self.timer >= .1 and self.timer < .2 then
			self.quad = 3
		elseif self.timer >= .2 and self.timer < .3 then
			self.quad = 4
		elseif self.timer >= .3 and self.timer < .4 then
			self.quad = 1
		end
	end
	
	if self.timer >= .4 then
		self.push = false
		self.timer = 0 
	end
end