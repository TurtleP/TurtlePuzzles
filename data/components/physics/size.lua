local concord = require("libraries.concord")

local Size = concord.component("size", function(component, width, height)
    component._width  = width
    component._height = height
end)

function Size:get()
    return self._width, self._height
end

function Size:set(width, height)
    self._width  = width  or self:width()
    self._height = height or self:height()
end

function Size:width()
    return self._width
end

function Size:height()
    return self._height
end

function Size:__tostring()
    return string.format("%d, %d", self:get())
end

Size.__mt.__tostring = Size.__tostring
