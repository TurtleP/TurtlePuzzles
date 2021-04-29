local concord = require("libraries.concord")

local Controller = concord.component("controller", function()
end)

local __PLAYER_SPEED__ = 75

function Controller:gamepadaxis(entity, axis, value)
    if axis == "leftx" then
        if value > 0.5 then
            entity.velocity:set(__PLAYER_SPEED__)
        elseif value < -0.5 then
            entity.velocity:set(-__PLAYER_SPEED__)
        else
            entity.velocity:set(0)
        end
    end
end

function Controller:gamepadpressed(entity, button)
    if button == "a" then
        if entity.velocity.y == 0 then
            entity.velocity.y = -160
        end
    end
end

return Controller
