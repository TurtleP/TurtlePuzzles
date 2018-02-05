invisowall = class:new()
invisowallquadimage = love.graphics.newImage("graphics/invisiblewall.png")
invisowallquads = {}
for i = 1, 2 do
	invisowallquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, 33, 16)
end

function invisowall:init(x, y, solid, name)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 16*scale
	self.xSpeed = 0
	self.y = y
	self.inAir = false
	self.static = true
	self.offsetX, self.offsetY = 0, 0
	self.outputs = false
	self.name = name
	self.solid = solid
	self.state = 0
	if self.solid == "passive" then
		self.passive = true
		self.fake = true
		self.quad = 2
	elseif self.solid == "solid" then
		self.passive = false
		self.fake = false
		self.quad = 1
	end
	self.mask = {"turtle"}
end

function invisowall:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(invisowallquadimage, invisowallquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

function invisowall:update(dt)
	
	if self.state == "solid" then
		self.quad = 1
	else
		self.quad = 2
	end
	
	if self.fake then
		self.passive = true
		self.quad = 2
	else
		self.passive = false
		self.quad = 1
	end
	
	
end