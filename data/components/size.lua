local concord = require("libraries.concord")

local Size = concord.component("size", function(component, width, height)
    component.width  = width
    component.height = height
end)

function Size:getWidth()
    return self.width
end

function Size:getHeight()
    return self.height
end

function Size:__tostring()
    return string.format("%d, %d", self.width, self.height)
end

Size.__mt.__tostring = Size.__tostring
