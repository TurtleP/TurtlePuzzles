button = class:new()
buttonquadimage = love.graphics.newImage("graphics/buttonquads.png")
buttonquads = {}
for i = 1, 2 do
	buttonquads[i] = love.graphics.newQuad((i-1)*13, 0, 12, 9, 25, 9)
end

function button:init(x, y, time, name)
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
	self.time = time
	self.timer = self.time
	self.push = false
	self.pushsnd = 0
	self.ticks = 0
	self.mask = {"turtle"}
	self.outputs = true
	self.name = name
end

function button:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(buttonquadimage, buttonquads[self.quad], self.x, self.y, 0, scale)
	love.graphics.pop()
end

function button:update(dt)
	if self.push and self.pushsnd == 0 then
		playsound(push)
		self.pushsnd = 1 
	end
	
	if self.push then
		self.timer = self.timer - 1*dt
		
		if self.timer <= 0 then
			self.timer = 0
			self.push = false
			self.pushsnd = 0
		end
		
		--fake walls
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
			v.y = v.y + 30*dt
			v.passive = true
			if v.y >= v.starty + 98 then
				v.y = v.starty + 98
			end
			v.close = 0
		end
	end
	
	if self.fakewall then
			local v = objects["fakewall"][self.fakewall]
			if not self.push then
				v.fake = false
			end
	end
	
	if self.door then
		local v = objects["door"][self.door]
		if not self.push then
			v.passive = false
			self.quad = 1
			v.y = v.y - 30*dt
			v.reverse = true
			if v.y <= v.starty then
				v.y = v.starty
				if v.close == 0 then
					playsound(close)
					v.close = 1
					v.reverse = false
				end
			end
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
		
	if self.timer == 0 and not self.push then
		self.timer = self.time
	end
end