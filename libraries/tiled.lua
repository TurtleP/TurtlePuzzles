local tiled = {}
tiled.inited = false

tiled.maps = {}
tiled.currentMap = nil

local assetPath = "data/maps"

local Map = require("data.classes.map")
local core = require("data.core")
local music = core.music

function tiled.init()
    if tiled.inited then
        error("Cannot re-init module")
    end

    local files = love.filesystem.getDirectoryItems(assetPath)
    for index = 1, #files do
        if files[index]:sub(-4) == ".lua" then
            local name = files[index]:gsub(".lua", "")
            tiled.maps[name] = require("data.maps." .. name)
        end
    end

    tiled.inited = true
    return tiled
end

function tiled.loadMap(name)
    assert:type(name, "string")
    local mapData = assert:type(tiled.maps[name], "table")

    local mapSize = {width = mapData.width * 16, height = mapData.height * 16}

    tiled.currentMap = {}

    -- load top screen data
    tiled.currentMap.top = Map(name, mapSize, mapData.layers, mapData.properties)
    if mapData.properties.music then
        music.play(mapData.properties.music)
    end

    -- check for bottom screen data
    if love.filesystem.getInfo("data/maps/" .. name .. "_bottom.lua") then
        mapData, mapSize = tiled.maps[name .. "_bottom"], {width = mapData.width * 16, height = mapData.height * 16}
        tiled.currentMap.bottom = Map(name .. "_bottom", mapSize, mapData.layers, mapData.properties)
    end
end

function tiled.getMap(screen)
    assert:type(screen, "string")
    if tiled.currentMap[screen] then
        return tiled.currentMap[screen]
    end
end

function tiled.getEntities(screen)
    local map = tiled.getMap(screen)
    return map:getEntities()
end

function tiled.getPlayer()
    return Map.Player
end

function tiled.getSize(screen)
    local map = tiled.getMap(screen)
    return map:getSize()
end

function tiled.update(dt)
    if tiled.currentMap then
        for _, value in pairs(tiled.currentMap) do
            value:update(dt)
        end
    end
end

function tiled.drawTop(wrapper)
    if tiled.currentMap then
        tiled.currentMap.top:draw(wrapper)
    end
end

function tiled.drawBottom(wrapper)
    if tiled.currentMap and tiled.currentMap.bottom then
        tiled.currentMap.bottom:draw(wrapper)
    end
end

local function aabb(x, y, width, height, otherX, otherY, otherWidth, otherHeight)
	return x + width > otherX      and
           x < otherX + otherWidth and
           y + height > otherY     and
           y < otherY + otherHeight
end

function tiled.checkRectangle(screen, x, y, width, height, list)
    local entities          =  tiled.getEntities(screen)
    local result, exclude   = {}, nil

    if type(list[1]) == "table" and table.front(list[1]) == "exclude" then
        exclude = list[1][2]
        table.shift(list)
    end

    for _, entity in ipairs(entities) do
        local hasObject = false
        for index = 1, #list do
            if list[index] == entity.name.value then
                hasObject = true
            end
        end

        if hasObject then
            for _, other in ipairs(entities) do
                local skip = false
                if exclude then
                    if other.position == exclude.position then
                        skip = true
                    end
                end

                if not skip then
                    if aabb(x, y, width, height, other.position.x, other.position.y, other.size.width, other.size.height) then
                        table.add_value(result, other)
                    end
                end
            end
        end
    end

    return result
end

return tiled
