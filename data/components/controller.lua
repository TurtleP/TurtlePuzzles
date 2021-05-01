local concord = require("libraries.concord")
local core    = require("data.core")

local sound = core.sounds

local Controller = concord.component("controller")

local __PLAYER_SPEED__ = 75
local __PUNCH_TIMER__ = nil

function Controller:gamepadaxis(entity, axis, value)
    if axis == "leftx" then
        if value > 0.5 then
            if not entity.state:was("punch") then
                entity.velocity:set(__PLAYER_SPEED__)
                entity.state:set("walk", {"jump", "punch"})
            end
            entity.state:setDirection(1)
        elseif value < -0.5 then
            if not entity.state:was("punch") then
                entity.velocity:set(-__PLAYER_SPEED__)
                entity.state:set("walk", {"jump", "punch"})
            end
            entity.state:setDirection(-1)
        else
            if not entity.state:was("punch") then
                entity.velocity:set(0)
            end
            entity.state:set("idle", {"jump"})
        end
    end
end

function Controller:update(dt)
    if __PUNCH_TIMER__ then
        __PUNCH_TIMER__:update(dt)
    end
end

function Controller:gamepadpressed(entity, button)
    if button == "a" then
        if entity.velocity.y == 0 then
            entity.state:set("jump", {"punch"})
            sound.play("jump")
            entity.velocity.y = -160
        end
    elseif button == "b" then
        if not entity.state:was("punch") then
            entity.state:store(entity)
            if entity.velocity.x == 0 then
                entity.velocity.x = (100 * entity.state.direction)
            end
            entity.state:set("punch")
            sound.play("charge")
            __PUNCH_TIMER__ = timer:new(1, nil, function()
                entity.state:pop(entity)
            end)
        end
    end
end

return Controller
