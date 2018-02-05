quad = class:new() --Make a blockquad

function quad:init(image, imgdata, x, y, width, height)
	self.image = image
	self.endblock = false
	self.ice = false
	self.passive = false
	self.quad = love.graphics.newQuad((x-1) * 17, (y-1) * 17, 16, 16, width, height)
	
	 local _, _, _, a = imgdata:getPixel(((x*17-1)), (y-1)*16)

	 if a > 127 then
		self.passive = true
	 end
end