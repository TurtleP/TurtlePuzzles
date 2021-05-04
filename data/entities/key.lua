local keyTexture = love.graphics.newImage("assets/graphics/game/entities/key.png")
local keyQuads   = {}

keyQuads.idle = {}
for index = 1, 6 do
    keyQuads.idle[index] = love.graphics.newQuad((index - 1) * 16, 0, 16, 13, keyTexture)
end

local function Key(entity, screen, x, y)
    entity
    :give("screen", screen)
    :give("position", x, y)
    :give("size", 16, 13)
    :give("passive")
    :give("name", "key")
    :give("animation", keyTexture, keyQuads)
    :give("state", "idle")
end

return Key
