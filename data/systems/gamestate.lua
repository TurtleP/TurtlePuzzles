local concord = require("libraries.concord")

local GameStateSystem = concord.system({pool = {"gamestate"}})

function GameStateSystem:init(world)
    self.world = world
end

function GameStateSystem:update(dt)

end

function GameStateSystem:draw()

end
