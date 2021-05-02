local nest = require "libraries.nest"
nest.load(nest.flags.USE_CTR_WITH_KEYBOARD)

require("libraries.batteries"):export()

-- "environment" stuff
core = require("data.core")

local state = require("states")
local save  = require("data.core.save")

love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
    state:init()

    love.math.setRandomSeed(os.time())
    love.math.random(); love.math.random()

    state.switch("game", "test")
    save.initFile(1, {name = "test"})
end

function love.update(dt)
    save.update(dt)
end

function love.gamepadpressed(joystick, button)
    if button == "start" then
        love.event.quit()
    end
end
