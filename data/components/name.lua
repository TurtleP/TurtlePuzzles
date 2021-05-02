local concord = require("libraries.concord")

local Name = concord.component("name", function(component, name)
    component.value = name
end)

function Name:is(compare)
    return self.value == compare
end
