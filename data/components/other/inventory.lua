local concord = require("libraries.concord")

local Inventory = concord.component("inventory", function(component)
    component.keys  = 0
    component.lives = 3
end)

function Inventory:addKey(amount)
    self.keys = math.max(self.keys + amount, 0)
end

function Inventory:getKeys()
    return self.keys
end

function Inventory:addLife(amount)
    self.lives = math.max(self.lives + amount, 0)
end

function Inventory:getLives()
    return self.lives
end

return Inventory
