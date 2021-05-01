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

--[[
    TODO:

    Entity Loading
    Player
]]

local DEBUG_DRAW = true

function Map:new(name, size, layers, properties)
    self.width  = size.width
    self.height = size.height

    self.player = nil
    self.camera = camera(0, 0, 1.50, 0)

    -- dummy this

    self.tiles = love.graphics.newImage("data/maps/" .. name .. ".png")

    self.screen = name:find("bottom") and "bottom" or "top"

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

        if name == "tile" then
            entity:assemble(entities.tile,   self.screen, entityData.x, entityData.y, entityData.width, entityData.height)
        elseif name == "spawn" then
            entity:assemble(entities.player, self.screen, entityData.x, entityData.y)
            self:setCameraTarget(entity)
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

local target = {}
function Map:updateCamera()
    if not self.target then
        return
    end

    if self.target.screen.name ~= self.screen then
        return
    end

    local s = 1 / self.camera.scale -- zoom or scale of the camera

    local wvw, wvh = self.windowSize.width / (2 * self.camera.scale), self.windowSize.height / (2 * self.camera.scale)
    local dx, dy = self.target.position.x - self.camera.x, self.target.position.y - self.camera.y

    self.camera.x = math.clamp(self.camera.x + dx / 2, 0 + wvw, self.width  - wvw)
    self.camera.y = math.clamp(self.camera.y + dy / 2, 0 + wvh, self.height - wvh)
end

function Map:update(dt)
    self:updateCamera()
end

function Map:debugDraw()
    for _, entity in ipairs(self.entities) do
        love.graphics.rectangle("line", entity.position.x, entity.position.y, entity.size.width, entity.size.height)
    end
end

function Map:draw(wrapper)
    self.camera:attach()

    love.graphics.draw(self.background)
    love.graphics.draw(self.tiles)

    if DEBUG_DRAW then
        self:debugDraw()
    end

    if wrapper then
        wrapper()
    end

    self.camera:detach()
end

return Map
