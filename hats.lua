hats = class:new()

function hats:init(image, imagedata, x, y, width, height) --An entity block not an actual entity
	self.type = nil
	self.image = image
	self.x = x
	self.y = y
	self.quad = love.graphics.newQuad((self.x-1) * 17, (self.y-1) * 17, 16, 16, width, height)
end