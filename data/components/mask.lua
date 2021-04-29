local concord = require("libraries.concord")

local Mask = concord.component("mask", function(component, func)
    component.func = func
end)

return Mask
