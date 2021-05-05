local gamestate = require "gamestate"
local game = {}

local tiled = require("libraries.tiled").init()

local concord = require("libraries.concord")

-- load components
local items = { "", "/physics", "/properties", "/render",
                "/other" }

for _, namespace in ipairs(items) do
    concord.utils.loadNamespace("data/components" .. namespace)
end

-- load systems
local systems = {}
concord.utils.loadNamespace("data/systems", systems)

-- singleton entity
local gameState = concord.entity():give("gamestate")

function game:enter(_, map)
    tiled.loadMap(map)

    self.world = concord.world()
    self.world:addSystem(systems.physics)

    for _, screen in ipairs({"top", "bottom"}) do
        local mapData = tiled.getMap(screen)

        if mapData and mapData:getEntities() then
            for _, entity in ipairs(mapData:getEntities()) do
                self.world:addEntity(entity)
            end
        end
    end

    self.world:addEntity(gamestate)

    local worldSystems = { systems.debug, systems.controller, systems.sprite,
                           systems.animation, systems.interface }

    self.world:addSystems(unpack(worldSystems))
end

function game:update(dt)
    tiled.update(dt)
    self.world:emit("update", dt)
end

function game:drawTop(depth)
    tiled.drawTop(function()
        self.world:emit("draw", "top", depth)
    end)
end

function game:drawBottom()
    tiled.drawBottom(function()
        self.world:emit("draw", "bottom")
    end)
end

function game:gamepadpressed(_, button)
    self.world:emit("gamepadpressed", button)
end

function game:gamepadaxis(_, axis, value)
    self.world:emit("gamepadaxis", axis, value)
end

function game:leave()

end

return game
