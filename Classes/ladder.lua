ladder = class:new()
ladderimg = love.graphics.newImage("graphics/ladder.png")
ladderquad = love.graphics.newQuad(0, 0, 16, 16, 16, 16)


function ladder:init(x, y)
	self.x = x
	self.active = false
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 16*scale
	self.xSpeed = 0
	self.y = y
	self.inAir = false
	self.static = true
	self.quad = 1
	self.offsetX, self.offsetY = 0, 0
	self.passive = true
	self.mask = {"turtle"}
end

function ladder:draw()
	love.graphics.push()
	love.graphics.translate(self.offsetX, self.offsetY)
	love.graphics.drawq(ladderimg, ladderquad, self.x, self.y, 0, scale)
	love.graphics.pop()
end