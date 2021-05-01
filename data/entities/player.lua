local collisions = {}

collisions.floor = function(this, other)
    if this.state:wasAnyOf("jump", "punch") then
        if this.velocity.x == 0 then
            this.state:set("idle")
        else
            this.state:set("walk")
        end
    end
end

local playerTexure = love.graphics.newImage("assets/graphics/game/player.png")
local playerQuads = {}

-- IDLE --
playerQuads.idle = {}
playerQuads.idleRate = 6

for i = 1, 4 do
    playerQuads.idle[i] = love.graphics.newQuad((i - 1) * 12, 0, 12, 20, playerTexure)
end

-- WALK --
playerQuads.walk = {}
playerQuads.walkRate = 6
for i = 1, 4 do
    playerQuads.walk[i] = love.graphics.newQuad((i - 1) * 12, 20, 12, 20, playerTexure)
end

-- JUMP --
playerQuads.jump = {}
playerQuads.jumpRate = 6
playerQuads.jumpStopAtEnd = true
for i = 1, 3 do
    playerQuads.jump[i] = love.graphics.newQuad((i - 1) * 12, 40, 12, 20, playerTexure)
end

-- PUNCH --
playerQuads.punch = {}
for i = 1, 4 do
    playerQuads.punch[i] = love.graphics.newQuad((i - 1) * 12, 140, 12, 20, playerTexure)
end

local function Player(entity, screen, x, y)
    entity
    :give("screen", screen)
    :give("name", "player")
    :give("position", x, y)
    :give("size", 12, 20)
    :give("velocity")
    :give("mask", function(this, other)
        if other.name.value == "tile" then
            return "slide"
        end
    end)
    :give("controller")
    :give("state", "idle")
    :give("collision", collisions)
    :give("animation", playerTexure, playerQuads)
end

return Player
