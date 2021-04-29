    local concord = require("libraries.concord")

local friction = 14
local superfriction = 100
local minSpeed = 0.7

local Velocity = concord.component("velocity", function(component, gravity, maxSpeed)
    component.x = 0
    component.y = 0

    component.gravity = gravity or 240
    component.maxSpeed = maxSpeed or 120
end)

function Velocity:set(speed)
    self.x = speed
end

return Velocity
