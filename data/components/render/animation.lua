local concord = require("libraries.concord")

local Animation = concord.component("animation", function(component)
    component._time  = 0
    component._index = 1

    component.locked = false
end)

function Animation:update(dt)
    if self.locked then
        return
    end
    self._time = self._time + dt
end

function Animation:time()
    return self._time
end

function Animation:setIndex(index)
    self._index = index
end

function Animation:index()
    return self._index
end

function Animation:reset()
    if self.locked then
        self.locked = false
    end

    self._time  = 0
    self._index = 0
end

function Animation:unlock()
    self.locked = false
end

function Animation:lock()
    self.locked = true
end

return Animation
