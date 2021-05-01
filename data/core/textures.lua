local textures = {}
textures.inited = false

local path = "assets/graphics"

local function generateQuads(count, texture, spacing, xSize, ySize)
    local quads = {}

    spacing = spacing or xSize
    for index = 1, count do
        table.insert(quads, love.graphics.newQuad((index - 1) * spacing, 0, xSize, ySize, texture))
    end

    return quads
end

function textures.init()
    if textures.inited then
        error("Cannot re-init module")
    end

    -- intro
    textures.intro = love.graphics.newImage(path .. "/intro/love.png")

    -- menu
    textures.menu = {}

    textures.menu.left   = love.graphics.newImage(path .. "/menu/backdrop.png")
    textures.menu.bottom = love.graphics.newImage(path .. "/menu/saves.png")

    textures.menu.clouds = {}
    for index = 1, 4 do
        textures.menu.clouds[index] = love.graphics.newImage(path .. "/menu/cloud" .. index .. ".png")
    end

    textures.menu.title = love.graphics.newImage(path .. "/menu/title.png")

    textures.menu.saveFiles = love.graphics.newImage(path .. "/menu/saveicons.png")
    textures.menu.saveQuads = generateQuads(3, textures.menu.saveFiles, 36, 36, 28)

    -- game
    textures.game = {}

    textures.game.gems = love.graphics.newImage(path .. "/menu/gems.png")
    textures.game.gemQuads = generateQuads(4, textures.game.gems, 9, 8, 13)

    textures.inited = true
    return textures
end

function textures.centerX(tex, width)
    local textureWidth = tex:getWidth()

    if width > textureWidth then
        return (width - textureWidth) * 0.5
    end
    return (textureWidth - width) * 0.5
end

function textures.centerY(tex, height)
    local textureHeight = tex:getHeight()

    if height > textureHeight then
        return (height - textureHeight) * 0.5
    end
    return (textureHeight - height) * 0.5
end

return textures
