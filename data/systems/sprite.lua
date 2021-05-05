local concord = require("libraries.concord")

SpriteSystem = concord.system({pool = {"sprite"}})

function SpriteSystem:getRenderOffset(entity, scale)
    if scale < 0 then
        return math.abs(entity.size:width() * scale)
    end
    return 0
end

function SpriteSystem:drawAnimation(entity)
    if not entity:has("animation") then
        return
    end

    local quads = entity.sprite:quads()

    local quad = quads[entity.animation:index()]
    local direction = 1
    if entity:has("state") then
        quad, direction = quads[entity.state:current()][entity.animation:index()], entity.state:direction()
    end

    love.graphics.draw(entity.sprite:texture(), quad, entity.position:x(), entity.position:y(), 0, direction, 1, self:getRenderOffset(entity, direction))
end

function SpriteSystem:draw(screen)
    for _, entity in ipairs(self.pool) do
        if entity.screen.name == screen then
            local direction = entity.state:direction() or 1

            if not self:drawAnimation(entity) then

            end
        end
    end
end

return SpriteSystem
