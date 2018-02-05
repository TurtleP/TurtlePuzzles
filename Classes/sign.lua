sign = class:new()
signimage = love.graphics.newImage("graphics/sign.png")
signquads = {}

for i = 1, 2 do
	signquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, 33, 16)
end

function sign:init(x, y, types)
	self.x = x
	self.y = y
	self.types = types
	if self.types == "skull" then
	self.quad = 1
	elseif self.types == "danger" then
		self.quad = 2
	end
	self.passive = true
	self.width = 16*scale
	self.height = 16*scale
	self.offsetX, self.offsetY = 0, 0
	self.mask = {"turtle"}
end

function sign:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(signimage, signquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

