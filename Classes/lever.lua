lever = class:new()
leverquadimage = love.graphics.newImage("graphics/lever.png")
leverquads = {}
for i = 1, 2 do
	leverquads[i] = love.graphics.newQuad((i-1)*15, 0, 14, 12, 29, 12)
end

function lever:init(x, y, name)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 14*scale
	self.height = 12*scale
	self.xSpeed = 0
	self.y = y + 4*scale
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.push = false
	self.pushsnd = 0
	self.ticks = 0
	self.outputs = true
	self.mask = {"crate", "turtle"}
	self.name = name
end

function lever:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(leverquadimage, leverquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

function lever:update(dt)
	if self.push and self.pushsnd == 0 then
		playsound(push)
		self.pushsnd = 1 
		self.quad = 2
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
	if self.door then
		local v = objects["door"][self.door]
		if not self.push then
			v.passive = false
			self.quad = 1
			v.y = v.y - 1
			if v.y <= v.starty then
				v.y = v.starty
				if v.close == 0 then
					playsound(close)
					v.close = 1
				end
			end
		end
	end
	if self.fakewall then
			local v = objects["fakewall"][self.fakewall]
			if not self.push then
				v.fake = false
			end
	end
	if self.invisowall then
			local v = objects["invisowall"][self.invisowall]
			if not self.push then
			if v.state == 1 then
				v.fake = not v.fake
				v.state = 0
			end
			end
		end
end