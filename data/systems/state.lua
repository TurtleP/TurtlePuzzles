local concord = require("libraries.concord")

local State = concord.system({pool = {"state"}})

function State:update(dt)
    for _, entity in ipairs(self.pool) do
        entity.state:update(entity, dt)
    end
end

return State
