local concord = require("libraries.concord")

local __NULL__ = function()
    return false
end

concord.component("collision", function(component, callbacks)
    if not callbacks then
        callbacks = {}
    end

    component.ceil    = callbacks.ceil    or __NULL__
    component.floor   = callbacks.floor   or __NULL__
    component.right   = callbacks.right   or __NULL__
    component.left    = callbacks.left    or __NULL__
    component.passive = callbacks.passive or __NULL__
    component.global  = callbacks.global  or __NULL__
end)
