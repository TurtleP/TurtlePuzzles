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

return tiled
