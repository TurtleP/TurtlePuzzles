local concord = require("libraries.concord")
local core    = require("data.core")

local PlayerController = concord.component("controller", function(component)
    local move = {"left", "right", "up", "down"}
    for _, value in ipairs(move) do
        component[value] = false
    end

    component.onLadder = false
    component.lastLadder = nil
    component.jumping = false
end)

-- Set @direction (string) to @move (bool)
function PlayerController:move(direction, move)
    assert:type(direction, "string")
    assert:type(self[direction], "boolean")
    assert:type(move, "boolean")

    self[direction] = move
end

-- check if @direction is in use or not
function PlayerController:moving(direction)
    assert:type(direction, "string")
    assert:type(self[direction], "boolean")

    return self[direction]
end

-- check if on a ladder
function PlayerController:isOnLadder()
    return self.onLadder
end

function PlayerController:getLadder()
    return self.lastLadder
end

function PlayerController:setLadder(object)
    self.lastLadder = object
    self.onLadder = (object ~= nil)
end

return PlayerController
