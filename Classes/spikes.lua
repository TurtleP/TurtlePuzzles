spikes = class:new()
spikeimg = love.graphics.newImage("graphics/spikes.png")
spikequad = love.graphics.newQuad(0, 0, 16, 16, 16, 16)


function spikes:init(x, y, dirs)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 16
	self.height = 16
	self.xSpeed = 0
	self.y = y
	self.inAir = false
	self.static = true
	self.quad = 1
	self.dir = dirs
	self.offsetX, self.offsetY = 0, 0
	self.passive = false
	self.img = spikeimg
	self.mask = {"turtle"}
end

function spikes:draw()
	love.graphics.push()
	
	if self.dir == "up" then
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(self.img, spikequad, self.x, self.y, 0, scale)
	else
	love.graphics.translate(self.offsetX, 16*scale)
	love.graphics.drawq(self.img, spikequad, self.x, self.y, 0, scale, -scale)
	end
	love.graphics.pop()
end