block = class:new()

function block:init(x, y, passive) --A general block.
	self.x = x
	self.y = y
	self.active = false
	self.ySpeed = 0
	self.width = 16*scale
	self.height = 16*scale
	self.xSpeed = 0
	self.inAir = false
	self.passive = passive
	self.mask = {"turtle", "crate"}
end