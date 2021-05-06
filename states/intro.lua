local intro = {}

-- things we need
local state = require("states")

local textures = core.textures
local sound    = core.sounds

function intro:init()
    self.timer = 0
    sound.play("intro")
end

function intro:update(dt)
    self.timer = self.timer + dt
end

function intro:drawTop(depth)
    if self.timer <= 3 then
        love.graphics.setColor(1, 1, 1, math.abs(math.sin(self.timer) / 0.5))
        love.graphics.draw(textures.intro, 0 - (4.0 * depth), 0)
    elseif self.timer > 4 then
        state.switch("menu")
    end
end

return intro
