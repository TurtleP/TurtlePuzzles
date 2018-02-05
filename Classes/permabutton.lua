permabutton = class:new()
permabuttonquadimage = love.graphics.newImage("graphics/buttonquads2.png")
permabuttonquads = {}
for i = 1, 2 do
	permabuttonquads[i] = love.graphics.newQuad((i-1)*13, 0, 12, 9, 25, 9)
end

function permabutton:init(x, y, name)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 12*scale
	self.height = 9*scale
	self.xSpeed = 0
	self.y = y + 7*scale
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.push = false
	self.pushsnd = 0
	self.ticks = 0
	self.outputs = true
	self.name = name
	self.mask = {"crate", "turtle"}
end

function permabutton:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(permabuttonquadimage, permabuttonquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

function permabutton:update(dt)
	if self.push and self.pushsnd == 0 then
		playsound(push)
		self.pushsnd = 1 
	end
	
	if self.push then
		if self.fakewall then
			local v = objects["fakewall"][self.fakewall]
			v.fake = true
		end
		
		if self.invisowall then
			local v = objects["invisowall"][self.invisowall]
			if v.state == 0 then
				v.fake = not v.fake
				v.state = 1
			end
		end
		
		--door
		if self.door then
			local v = objects["door"][self.door]
			v.y = v.y + 1
			v.passive = true
			if v.y >= v.starty + 98 then
				v.y = v.starty + 98
			end
			v.close = 0
		end
	end
	
end