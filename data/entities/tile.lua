local function Tile(entity, screen, x, y, width, height)
    entity
    :give("screen", screen)
    :give("name", "tile")
    :give("position", x, y)
    :give("size", width, height)
end

return Tile
