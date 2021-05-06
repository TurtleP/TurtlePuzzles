
local path = (...):gsub('%.init$', '')

local states = {}
states.inited = false

states.current = nil
states.flags = { splitRender = true }

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

    states.inited = true
    return states
end

function states.switch(name, ...)
    local switch = assert:type(states.items[name], "table")

    if states.current then
        states.current:exit()
    end
    states.current = switch
    switch:enter(...)
end

function states.update(dt)
    if states.current then
        states.current:update(dt)
    end
end

local function getDepth()
    if love.graphics.get3DDepth then
        return love.graphics.get3DDepth()
    end
    return 0
end

function states.draw(screen)
    if states.current then
        if states.flags.splitRender then
            if screen ~= "bottom" and states.current.drawTop then
                local depth = getDepth()
                if screen == "right" then
                    depth = -depth
                end
                states.current:drawTop(depth)
            end

            if screen == "bottom" and states.current.drawBottom then
                states.current:drawBottom()
            end
        else
            -- handle depth inside the state?
            states.current:draw(screen)
        end
    end
end

function states.gamepadpressed(_, button)
    if states.current then
        states.current:gamepadpressed(button)
    end
end

function states.gamepadaxis(_, axis, value)
    if states.current then
        states.current:gamepadaxis(axis, value)
    end
end

return states
