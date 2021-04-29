local concord = require("libraries.concord")

local __NULL__ = function(dt)
end

local State = concord.component("state", function(component, default, onUpdate)
    component.current = default or "" -- default?
    component.run = onUpdate or __NULL__
end)

function State:update(dt)
    self.run(dt)
end

function State:set(name)
    if self.current ~= name then
        self.current = name
    end
end

return State
