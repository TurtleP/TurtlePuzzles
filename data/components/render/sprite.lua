local concord = require("libraries.concord")

local Sprite = concord.component("sprite", function(component, texture, quads)
    component._sprite = texture
    component._quads  = quads
end)

function Sprite:texture()
    return self._sprite
end

function Sprite:quads()
    return self._quads
end

return Sprite
