door = class:new()
doorimg = love.graphics.newImage("graphics/door.png")
doorquad = love.graphics.newQuad(0, 0, 16, 32, 16, 32)


function door:init(x, y, name)
	self.x = x
	self.active = true
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 32*scale
	self.xSpeed = 0
	self.y = y
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.passive = false
	self.starty = y
	self.close = 0
	self.name = name
	self.mask = {"turtle"}
	self.passive = false
	self.reverse = false
end

function door:downcollide(v, name)
	if name == "turtle" and self.reverse then
		v:hitdoor("down")
	end
end

function door:upcollide(v, name)
	if name == "turtle" and self.reverse then
		v:hitdoor("up")
	end
end

function door:draw2()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(doorimg, doorquad, self.x, self.y, 0, scale)
	love.graphics.pop()
end