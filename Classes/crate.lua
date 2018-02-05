crate = class:new()
crateimage = love.graphics.newImage("graphics/crate.png")
cratequads = love.graphics.newQuad(0, 0, 16, 16, 16, 16)

function crate:init(x, y)
	self.x = x
	self.y = y
	self.passive = false
	self.static = false
	self.width = 16*scale
	self.height = 16*scale
	self.offsetX, self.offsetY = 0, 0
	self.xSpeed = 0
	self.ySpeed = 0
	self.inAir = true
	self.active = true
	self.mask = {"door", "block", "permabutton"}
end

function crate:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(crateimage, cratequads, self.x, self.y, 0, scale)
	love.graphics.pop()
end

function crate:update(dt)
	if self.active  then
		self.ySpeed = self.ySpeed + 500 * dt
	end
	if self.active then
		self.y = self.y + self.ySpeed * dt
	end
	
	--check for tile underneath
	if self.inAir then
		if self.ySpeed == 0 then
			self.ySpeed = 250 + (50*scale)
		end
	end
	
	if not self.inAir then
		self.ySpeed = 0
	end
end


function crate:downcollide(v, name)
	
	if name == "button" or name == "permabutton" then
		v.push = true
		v.quad = 2
		self.offsetY = 10
	else
		--nothing?
	end
	
	if name == "floorbutton" then
		v.push = true
		v.quad = 2
		self.offsetY = 13
	else
	
	end
	
	print(name)
		
	if name == "block" then
		self.inAir = false
		self.ySpeed = 0
	end
end

