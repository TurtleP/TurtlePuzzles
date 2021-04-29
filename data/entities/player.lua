local collisions = {}

collisions.floor = function(this, other)
end

local playerTexure = love.graphics.newImage("assets/graphics/game/player.png")
local playerQuads = {}

local onUpdate = function(dt)

end

local function Player(entity, screen, x, y)
    entity
    :give("screen", screen)
    :give("position", x, y)
    :give("size", 12, 20)
    :give("velocity")
    :give("mask", function(this, other)
        if other.name == "tile" then
            return "bounce"
        end
    end)
    :give("controller")
    :give("state", "idle", onUpdate)
    :give("collision", collisions)

    entity.name = "player"
end

return Player
