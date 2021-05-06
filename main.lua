local nest = require "libraries.nest"
if nest and nest.load then
    nest.load(nest.flags.USE_CTR_WITH_KEYBOARD)
end

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
end

function love.update(dt)
    save.update(dt)
    state.update(dt)
end

function love.draw(screen)
    state.draw(screen)
end

function love.gamepadpressed(joystick, button)
    if button == "back" then
        love.event.quit()
    end
    state.gamepadpressed(joystick, button)
end

function love.gamepadaxis(joystick, axis, value)
    state.gamepadaxis(joystick, axis, value)
end
