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
