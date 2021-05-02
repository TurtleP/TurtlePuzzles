local concord = require("libraries.concord")

local Position = concord.component("position", function(component, x, y)
    component.x = x
    component.y = y
end)

function Position:set(x, y)
    self.x = x
    self.y = y
end

function Position:getX()
    return self.x
end

function Position:getY()
    return self.y
end

function Position:__eq(other)
    return self.x == other.x and self.y == other.y
end

function Position:__tostring()
    return string.format("%d, %d", self.x, self.y)
end

return Position
