local concord = require("libraries.concord")

local __NULL__ = function(_, _)
end

local State = concord.component("state", function(component, default)
    component.current = default or "" -- default?
    component.direction = 1

    component.storedData = nil
end)

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

-- lock state to current
function State:lock(before, locked)
    self.lockedState = before
    self.locked = locked
end

-- release state
function State:unlock()
    self.locked = false

    if self.lockedState then
        self:set(self.lockedState)
    end
end

function State:isLocked()
    return self.locked
end

function State:is(name)
    return self.current == name
end

function State:isAnyOf(...)
    local arg = {...}
    for index = 1, #arg do
        if self.current == arg[index] then
            return true
        end
    end
    return false
end

function State:set(to, shouldLock)
    local before = self.current

    if self.current ~= to and not self:isLocked() then
        self.current = to
        self:lock(before, shouldLock)
    end
    return self
end

return State
