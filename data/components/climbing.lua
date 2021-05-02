local concord = require("libraries.concord")

local Climbing = concord.component("climbing", function(component)
    component.value = nil
end)

function Climbing:set(object)
    self.value = object
end

function Climbing:get()
    return self.value
end
