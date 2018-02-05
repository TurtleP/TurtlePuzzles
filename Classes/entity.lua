entitylist = { --All entities
	"button",
	"spawn",
	"ladder",
	"spikes",
	"door",
	"coin",
	"lava",
	"water",
	"exit",
	"gate",
	"key",
	"lever",
	"spring",
	"permabutton",
	"fakewall",
	"invisowall",
	"teleporter",
	"sign",
	"crate",
	"floorbutton",
	"trigger"
}

rightclickvalues = {}
linkname = {}

linkname["teleporter"] = {"teleport"}
linkname["button"] = {"button"}
linkname["door"] = {"door"}
linkname["lever"] = {"lever"}
linkname["permabutton"] = {"permabutton"}
linkname["fakewall"] = {"fakewall"}
linkname["invisowall"] = {"invisowall"}
linkname["floorbutton"] = {"floorbutton"}
linkname["trigger"] = {"trigger"}

rightclickvalues["spikes"] = {"up", "down"}
rightclickvalues["button"] = {3, 6, 8, 10}
rightclickvalues["lava"] = {1, 2}
rightclickvalues["teleporter"] = {"enter", "exit"}
rightclickvalues["invisowall"] = {"passive", "solid"}
rightclickvalues["sign"] = {"skull", "danger"}

entity = class:new()

function entity:init(image, imagedata, x, y, width, height) --An entity block not an actual entity
	self.type = nil
	self.image = image
	self.x = x
	self.y = y
	self.quad = love.graphics.newQuad((self.x-1) * 17, (self.y-1) * 17, 16, 16, width, height)
end

function entity:settype(j) --List the types
	for i = 1, #entitylist do
		if i == j then
			self.type = entitylist[i]
		end
	end
end