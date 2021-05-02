local function Tile(entity, screen, x, y, width, height, properties)
    entity
    :give("screen", screen)
    :give("name", "tile")
    :give("position", x, y)
    :give("size", width, height)

    if properties.ladder then
        entity
        :give("climbable")
    end
end

return Tile
