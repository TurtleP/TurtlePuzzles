local collisions = {}

collisions.floor = function(this, other)
    if this.state:is("jump") then
        this.state:unlock()
    end
    return false
end

collisions.passive = function(this, other)
    if other:has("climbable") then
        if this:has("climbing") then
            this.climbing:set(other)
            if this.state:was("climb") then
                this.velocity:setGravity(0)
            end
        else
            this:give("canclimb")
        end
    end
end

local function onUpdate(state, this, dt)

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

-- CLIMB --
playerQuads.climb = {}
for i = 1, 6 do
    playerQuads.climb[i] = love.graphics.newQuad((i - 1) * 12, 160, 12, 20, playerTexure)
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
            if not this.state:is("climb") then
                return "slide"
            end
            return false
        elseif other.name.value == "ladder" then
            return "cross"
        end
    end)
    :give("controller")
    :give("state", "idle", onUpdate)
    :give("collision", collisions)
    :give("animation", playerTexure, playerQuads)
end

return Player
