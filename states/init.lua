
local path = (...):gsub('%.init$', '')

local states = {}
states.inited = false

local manager = require("libraries.state")

states.items = {}
function states.init()
    if states.inited then
        error("Cannot re-init module")
    end

    local items = love.filesystem.getDirectoryItems(path)
    table.remove_value(items, "init.lua")

    for index = 1, #items do
        local name = items[index]:gsub(".lua", "")
        local success, value = pcall(require, path .. "." .. name)

        if success then
            states.items[name] = value
        else
            error(value)
        end
    end

    manager.registerEvents()

    states.inited = true
    return states
end

function states.switch(name, ...)
    local value = states.items[name]
    assert(type(value) == "table", "gamestate must be a table, got " .. type(value))

    return manager.switch(value, ...)
end

return states
