local concord = require("libraries.concord")

local Position = concord.component("position", function(component, x, y)
    component._x = x
    component._y = y
end)

function Position:get()
    return self._x, self._y
end

function Position:set(x, y)
    self._x = x or self:x()
    self._y = y or self:y()
end

function Position:x()
    return self._x
end

function Position:y()
    return self._y
end

function Position:__eq(other)
    return self._x == other._x and self._y == other._y
end

function Position:__tostring()
    return string.format("%d, %d", self:get())
end

Position.__mt.__tostring = Position.__tostring
Position.__mt.__eq       = Position.__eq

return Position
