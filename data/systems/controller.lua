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

function PlayerControllerSystem:init(world)
    self.pool.onEntityAdded = function(_, entity)
        if entity.name:is("player") then
            __PLAYER__ = entity

            controller = __PLAYER__.controller
            state      = __PLAYER__.state
            velocity   = __PLAYER__.velocity
        end
    end
end

function PlayerControllerSystem:update(dt)
    if __PUNCH_TIMER__ then
        __PUNCH_TIMER__:update(dt)
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
            state:set("jump", true)
            sound.play("jump")
            velocity:setY(__PLAYER_JUMP_SPEED__)
        end
    elseif button == "y" then
        state:set("punch", true)
        sound.play("charge")
        __PUNCH_TIMER__ = timer:new(1, nil, function()
            state:unlock()
        end)
    end
end

return PlayerControllerSystem
