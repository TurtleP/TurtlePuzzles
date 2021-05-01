local concord = require("libraries.concord")

concord.component("animation", function(component, texture, quads)
    component.texture = texture
    component.quads = quads

    component.timer = 0
    component.quadi = 1
end)
