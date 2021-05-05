local concord = require("libraries.concord")

local GameState = concord.component("gamestate", function(component, value)
    component._current = value or ""
end)

function GameState:set(state)
    self._current = state
end

function GameState:state()
    return self._current
end

function GameState:is(compare)
    return self:state() == compare
end

function GameState:__tostring()
    return self:state()
end

GameState.__mt.__tostring = GameState.__tostring

return GameState
