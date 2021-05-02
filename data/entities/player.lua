local collisions = {}

collisions.floor = function(this, other)
    if other:has("climbable") then
        if this.position:getY() < other.position.y then
            if this.controller:moving("down") or this.controller:isOnLadder() then
                return true
            end
        else
            if not this.controller:isOnLadder() then
                return true
            end
        end
    else
        if this.state:isAnyOf("jump") then
            this.state:unlock()
        end
        this.controller:setLadder(nil)
    end

    return false
end

collisions.left = function(this, other)
    if other:has("climbable") then
        return true
    end
end

collisions.right = function(this, other)
    if other:has("climbable") then
        return true
    end
end

collisions.ceil = function(this, other)
    if other:has("climbable") then
        return true
    end
end

collisions.passive = function(this, other)

end

local function onUpdate(state, this, dt)

end

--[[
ladders should be passive if colliding, and:
- have no ladder object
- not passive
--]]
local function mask(this, other)
    if other.name.value == "tile" then
        if not other:has("climbable") then
            return "slide"
        else
            local position = this.position
            if this.controller:isOnLadder() or position:getY() > other.position:getY() then
                return "cross"
            end
            return "slide"
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
    :give("mask", mask)
    :give("controller")
    :give("state", "idle")
    :give("collision", collisions)
    :give("animation", playerTexure, playerQuads)
end

return Player
