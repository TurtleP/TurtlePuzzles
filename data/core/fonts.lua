local fonts = {}
fonts.inited = false

local path = "assets/graphics/fonts"
local assetPath = path .. "/Gohu.ttf"

function fonts.init()
    if fonts.inited then
        error("cannot re-init module")
    end

    fonts.fileSelect    = love.graphics.newFont(assetPath, 14)
    fonts.ui            = love.graphics.newFont(assetPath, 14)
    fonts.fileSelectBig = love.graphics.newFont(assetPath, 28)

    return fonts
end

return fonts
