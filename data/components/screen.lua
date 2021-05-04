local concord = require("libraries.concord")

local Screen = concord.component("screen", function(component, name)
    component.name = name
end)

function Screen:set(name, callback)
    if self.name ~= name then
        if callback then
            assert:type(callback, "function")()
        end
        self.name = name
    end
end

function Screen:is(name)
    return self.name == name
end

function Screen:__tostring()
    return self.name
end

function Screen:__eq(other)
    return self.name == other.name
end

Screen.__mt.__tostring = Screen.__tostring
Screen.__mt.__eq = Screen.__eq
