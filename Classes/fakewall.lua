fakewall = class:new()
fakewallquadimage = love.graphics.newImage("graphics/fakewall.png")
fakewallquads = {}
for i = 1, 2 do
	fakewallquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, 33, 16)
end

function fakewall:init(x, y, name)
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
	self.outputs = false
	self.name = name
	self.passive = false
	self.mask = {"turtle"}
end

function fakewall:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(fakewallquadimage, fakewallquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

function fakewall:update(dt)
	if self.fake then
		self.passive = true
		self.quad = 2
	else
		self.passive = false
		self.quad = 1
	end
end