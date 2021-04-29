local concord = require("libraries.concord")

local ControllerSystem = concord.system({pool = {"position", "velocity", "controller"}})

function ControllerSystem:gamepadaxis(axis, value)
    for _, entity in ipairs(self.pool) do
        entity.controller:gamepadaxis(entity, axis, value)
    end
end

function ControllerSystem:gamepadpressed(button)
    for _, entity in ipairs(self.pool) do
        entity.controller:gamepadpressed(entity, button)
    end
end

return ControllerSystem
