teleport = class:new()

teleportquadimage = love.graphics.newImage("graphics/teleporterentrance.png")
teleportquadimage2 = love.graphics.newImage("graphics/teleporterexit.png")
teleportquads = {}
for i = 1, 2 do
	teleportquads[i] = love.graphics.newQuad((i-1)*17, 0, 16, 16, 33, 16)
end

function teleport:init(x, y, types, name)
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
	self.sound = 0
	self.name = name
	self.passive = true
	self.image = teleportquadimage
	self.types = types
	self.parent = nil
	if self.types == "enter" then
		self.image = teleportquadimage
	else
		self.image = teleportquadimage2
	end
	self.teleported = false
	self.mask = {"turtle"}
end

function teleport:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(self.image, teleportquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

function teleport:update(dt)
	self.timer = self.timer + dt
	
	if self.timer >= 0 and self.timer < .5 then
		self.quad = 1
	elseif self.timer >= .5 and self.timer < .7 then
		self.quad = 2
	end
	
	if self.teleporter and self.teleported == false then
			local v = objects["teleporter"][self.teleporter]
			self.parent.x = v.x
			self.parent.y = v.y
			self.teleported = true
	end
	
	if self.teleported then
		local v = objects["teleporter"][self.teleporter]
		if self.parent.x > v.x + 1*scale or self.parent.x < self.x - 1*scale then
			self.teleported = false
		end
	end
		
		
	if self.timer > .7 then
		self.timer = 0
	end
end
