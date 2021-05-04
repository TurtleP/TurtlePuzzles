local Object = require("libraries.classic")
local Map = Object:extend()

local camera = require("libraries.camera")

local core = require("data.core")
local vars = core.vars

local assetPath = "assets/graphics/game/backgrounds/"
local ENTITIES_LAYER_NAME = "entities"

local backgrounds = {}
backgrounds.cave = love.graphics.newImage(assetPath .. "/cave.png")
backgrounds.lava = love.graphics.newImage(assetPath .. "/lava.png")

local concord = require("libraries.concord")
concord.utils.loadNamespace("data/components")

local entities = {}
concord.utils.loadNamespace("data/entities", entities)

function Map:new(name, size, layers, properties)
    self.size = size

    self.player = nil
    self.camera = camera(0, 0, 1.50, 0)

    -- dummy this

    self.tiles = love.graphics.newImage("data/maps/" .. name .. ".png")

    self.screen = name:find("bottom") and "bottom" or "top"
    self.offset = name:find("bottom") and -8 or 0

    self.background = properties.background and backgrounds[properties.background] or backgrounds.cave
    self.windowSize = name:find("bottom") and vars.BOT_SCREEN_SIZE or vars.TOP_SCREEN_SIZE

    self.entities = {}
    for _, value in ipairs(layers) do
        if value.name == ENTITIES_LAYER_NAME then
            self:loadEntities(value.objects)
        end
    end
end

function Map:loadEntities(layerData)
    assert:type(layerData, "table")

    for _, entityData in ipairs(layerData) do
        local name, entity = entityData.name, concord.entity()
        local properties   = entityData.properties

        if name == "tile" then
            entity:assemble(entities.tile,   self.screen, entityData.x + self.offset, entityData.y, entityData.width, entityData.height, properties)
            print(self.screen, entityData.x + self.offset, entityData.x + self.offset + entityData.width)
        elseif name == "spawn" then
            entity:assemble(entities.player, self.screen, entityData.x + self.offset, entityData.y)
            self:setCameraTarget(entity)
        elseif name == "key" then
            entity:assemble(entities.key, self.screen, entityData.x, entityData.y + (16 - 13) * 0.5)
        end

        table.insert(self.entities, entity)
    end
end

function Map:getEntities()
    if #self.entities == 0 then
        error("Entities table is empty!") -- shouldn't happen
    end
    return self.entities
end

function Map:setCameraTarget(target)
    self.target = target
end

function Map:getSize()
    return self.size
end

function Map:updateCamera()
    if not self.target then
        self.camera:lookAt((self.size.width - self.camera.x) / 2, (self.size.height - self.camera.y) / 2)
        return
    end

    if self.target.screen.name ~= self.screen then
        return
    end

    local wvw, wvh = self.windowSize.width / (2 * self.camera.scale), self.windowSize.height / (2 * self.camera.scale)
    local dx, dy = self.target.position:x() - self.camera.x, self.target.position:y() - self.camera.y

    self.camera.x = math.clamp(self.camera.x + dx / 2, 0 + wvw, self.size.width  - wvw)
    self.camera.y = math.clamp(self.camera.y + dy / 2, 0 + wvh, self.size.height - wvh)
end

function Map:update(dt)
    self:updateCamera()
end

function Map:draw(wrapper)
    self.camera:attach()

    love.graphics.draw(self.background)
    love.graphics.draw(self.tiles, self.offset)

    if wrapper then
        wrapper(self.screen)
    end

    self.camera:detach()
end

return Map
