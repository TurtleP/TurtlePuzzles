local concord = require("libraries.concord")

local Name = concord.component("name", function(component, name)
    component.value = name
end)

function Name:is(compare)
    return self.value == compare
end

function Name:__tostring()
    return self.value
end

Name.__mt.__tostring = Name.__tostring

return Name
