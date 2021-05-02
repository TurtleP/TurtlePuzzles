    local concord = require("libraries.concord")

local friction = 14
local superfriction = 100
local minSpeed = 0.7

local Velocity = concord.component("velocity", function(component, gravity, maxSpeed)
    component.x = 0
    component.y = 0

    component.gravity = gravity or 240
    component.maxSpeed = maxSpeed or 120

    component.defaultGravity = component.gravity
end)

function Velocity:setGravity(gravity)
    self.gravity = gravity
end

function Velocity:resetGravity()
    self.gravity = self.defaultGravity
end

function Velocity:set(x, y)
    if type(x) == "table" then
        self.x, self.y = unpack(x)
    end

    self.x = assert:type(x, "number")
    self.y = assert:type(y, "number")
end

function Velocity:stopped()
    return self.x == 0 and self.y == 0
end

function Velocity:get()
    return self.x, self.y
end

function Velocity:getX()
    return self.x
end

function Velocity:getY()
    return self.y
end

function Velocity:setX(x)
    self.x = x
end

function Velocity:setY(y)
    self.y = y
end

function Velocity:__tostring()
    return string.format("%d, %d", self.x, self.y)
end

Velocity.__mt["__tostring"] = Velocity.__tostring

return Velocity
