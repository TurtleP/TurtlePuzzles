local concord = require("libraries.concord")

concord.component("name", function(component, name)
    component.value = name
end)
