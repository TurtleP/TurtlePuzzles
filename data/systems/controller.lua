local concord = require("libraries.concord")

local core    = require("data.core")
local sound   = core.sounds

local PlayerControllerSystem = concord.system({pool = {"position", "velocity", "controller"}})

local __PLAYER__       = nil
local __PUNCH_TIMER__  = nil

local __PLAYER_SPEED__      = 75
local __PLAYER_JUMP_SPEED__ = -160

local controller = nil
local state      = nil
local velocity   = nil
local animation  = nil

function PlayerControllerSystem:init(world)
    self.pool.onEntityAdded = function(_, entity)
        if entity.name:is("player") then
            __PLAYER__ = entity

            controller = __PLAYER__.controller
            state      = __PLAYER__.state
            velocity   = __PLAYER__.velocity
            animation  = __PLAYER__.animation
        end
    end
end

function PlayerControllerSystem:update(dt)
    if __PUNCH_TIMER__ then
        __PUNCH_TIMER__:update(dt)
    end

    if velocity:getY() > 0 then
        if not state:is("jump") then
            state:unlock()
        end
        state:set("jump", true)
    end

    -- horizontal movements
    local speed = 0
    if controller:moving("right") then
        speed = __PLAYER_SPEED__
        state:setDirection(1)
    elseif controller:moving("left") then
        speed = -__PLAYER_SPEED__
        state:setDirection(-1)
    end
    velocity:setX(speed)

    if velocity:getY() == 0 then
        if velocity:getX() ~= 0 and not state:isAnyOf("jump", "punch") then
            state:set("walk", true)
        else
            if state:is("walk") then
                state:unlock()
            end
        end
    end
end

function PlayerControllerSystem:gamepadaxis(axis, value)
    if axis == "leftx" then
        if value > 0.5 then
            controller:move("left",  false)
            controller:move("right", true)
        elseif value < -0.5 then
            controller:move("right", false)
            controller:move("left",  true)
        else
            controller:move("right", false)
            controller:move("left",  false)
        end
    elseif axis == "lefty" then
        if value < -0.5 then
            controller:move("down", false)
            controller:move("up",   true)
        elseif value > 0.5 then
            controller:move("up",   false)
            controller:move("down", true)
        end
    end
end

function PlayerControllerSystem:gamepadpressed(button)
    -- don't allow this on climbing
    if state:is("climb") then
        return
    end

    if button == "a" then
        if velocity.y == 0 then
            -- override walking on jump
            if state:is("walk") then
                state:unlock()
            end
            state:set("jump", true)
            sound.play("jump")
            velocity:setY(__PLAYER_JUMP_SPEED__)
        end
    elseif button == "y" then
        -- override walking on punch
        if state:is("walk") then
            state:unlock()
        end
        state:set("punch", true)
        sound.play("charge")
        __PUNCH_TIMER__ = timer:new(1, nil, function()
            state:unlock()
        end)
    end
end

return PlayerControllerSystem
