local game = {}

local tiled = require("libraries.tiled").init()

local concord = require("libraries.concord")

local systems = {}
concord.utils.loadNamespace("data/systems", systems)

function game:enter(_, map)
    tiled.loadMap(map)

    self.world = concord.world()
    self.world:addSystem(systems.physics)

    self.world.onEntityAdded = function(_, e)
        self.world:getSystem(systems.physics):onEntityAdded(e)
    end

    for _, screen in ipairs({"top", "bottom"}) do
        local mapData = tiled.getMap(screen)

        if mapData and mapData:getEntities() then
            for _, entity in ipairs(mapData:getEntities()) do
                self.world:addEntity(entity)
            end
        end
    end

    self.world:addSystem(systems.controller)
end

function game:update(dt)
    tiled.update(dt)
    self.world:emit("update", dt)
end

function game:drawTop(depth)
    tiled.drawTop()
    self.world:emit("draw")
end

function game:drawBottom()
    tiled.drawBottom()
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
