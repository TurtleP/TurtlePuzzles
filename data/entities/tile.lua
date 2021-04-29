local function Tile(entity, screen, x, y, width, height)
    entity
    :give("screen", screen)
    :give("position", x, y)
    :give("size", width, height)

    entity.name = "tile"
end

return Tile
