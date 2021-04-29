local nest = require "libraries.nest"
nest.load(nest.flags.USE_CTR_WITH_KEYBOARD)

require("libraries.batteries"):export()

-- "environment" stuff
core = require("data.core")

local state = require("states")
local save  = require("data.core.save")

function love.load()
    state:init()

    love.math.setRandomSeed(os.time())
    love.math.random(); love.math.random()

    state.switch("intro")
    save.initFile(1, {name = "test"})
end

function love.update(dt)
    save.update(dt)
end

function love.gamepadpressed(joystick, button)

end

function love.gamepadaxis(joystick, axis, value)

end
