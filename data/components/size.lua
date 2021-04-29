local concord = require("libraries.concord")

concord.component("size", function(component, width, height)
    component.width  = width
    component.height = height
end)
