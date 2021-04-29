local concord = require("libraries.concord")

local Position = concord.component("position", function(component, x, y)
    component.x = x
    component.y = y
end)

function Position:set(x, y)
    self.x = x
    self.y = y
end

return Position
