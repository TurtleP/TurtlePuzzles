local function Ladder(entity, screen, x, y, width, height)
    entity
    :give("screen", screen)
    :give("name", "ladder")
    :give("position", x, y)
    :give("size", width, height)
    :give("climbable")
    :give("passive")
end

return Ladder
