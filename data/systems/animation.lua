local concord = require("libraries.concord")

local Animation = concord.system({pool = {"position", "animation", "state"}})

function Animation:update(dt)
    for _, entity in ipairs(self.pool) do
        if not entity.animation.quads[entity.state.current] then
            error("Cannot animate entity '" .. entity.name.value .. "'! State '" .. tostring(entity.state.current) .. "' does not exist!")
        end
        local rate = entity.animation.quads[entity.state.current .. "Rate"] or 8

        entity.animation.timer = entity.animation.timer + rate * dt
        if entity.animation.quads[entity.state.current .. "StopAtEnd"] then
            if entity.animation.quadi == #entity.animation.quads[entity.state.current] then
                return
            end
        end
        entity.animation.quadi = math.floor(entity.animation.timer % #entity.animation.quads[entity.state.current]) + 1
    end
end

local function getRenderOffset(entity, scale)
    if scale < 0 then
        return math.abs(entity.size.width * scale)
    end
    return 0
end

function Animation:draw(screen)
    for _, entity in ipairs(self.pool) do
        if entity.screen.name == screen then
            local direction = entity.state.direction or 1
            if #entity.animation.quads[entity.state.current] > 0 then -- draw quads
                local quad = entity.animation.quads[entity.state.current][entity.animation.quadi]
                love.graphics.draw(entity.animation.texture, quad, entity.position.x, entity.position.y, 0, direction, 1, getRenderOffset(entity, direction))
            else
                love.graphics.draw(entity.animation.texture, entity.position.x, entity.position.y, direction, 1, getRenderOffset(entity, direction))
            end
        end
    end
end

return Animation
