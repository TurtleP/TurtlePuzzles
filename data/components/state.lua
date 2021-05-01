local concord = require("libraries.concord")

local __NULL__ = function(_, _)
end

local State = concord.component("state", function(component, default, onUpdate)
    component.current = default or "" -- default?
    component.run = onUpdate or __NULL__
    component.direction = 1

    component.storedData = nil
end)

function State:update(dt)
    self.run(self, dt)
end

function State:store(entity)
    self.storedData = {entity.velocity.x, entity.velocity.y, entity.state.current}
end

function State:pop(entity)
    if not self.storedData then
        return
    end
    entity.velocity.x = self.storedData[1]
    entity.state:set(self.storedData[3])
end

function State:setDirection(direction)
    if self.direction ~= direction then
        self.direction = direction
    end
end

local function canSwitch(current, ignore)
    for index = 1, #ignore do
        if current == ignore[index] then
            return false
        end
    end
    return true
end

function State:was(name)
    return self.current == name
end

function State:wasAnyOf(...)
    local arg = {...}
    for index = 1, #arg do
        if self.current == arg[index] then
            return true
        end
    end
    return false
end

function State:set(to, ignore)
    ignore = ignore or {}
    if self.current ~= to and canSwitch(self.current, ignore) then
        self.current = to
    end
    return self
end

return State
