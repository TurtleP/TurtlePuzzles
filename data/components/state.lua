local concord = require("libraries.concord")

local __NULL__ = function(_, _)
end

local State = concord.component("state", function(component, default)
    component._current = default or "" -- default?
    component._direction = 1
end)

function State:current()
    return self._current
end

function State:set(to, shouldLock)
    if self:current() ~= to and not self:isLocked() then
        self._current = to
        self:lock(to, shouldLock)
    end
    return self
end

function State:direction()
    return self._direction
end

function State:setDirection(direction)
    if self._direction ~= direction then
        self._direction = direction
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
    return self:current() == name
end

function State:isAnyOf(...)
    local arg = {...}
    for index = 1, #arg do
        if self:current() == arg[index] then
            return true
        end
    end
    return false
end

return State
