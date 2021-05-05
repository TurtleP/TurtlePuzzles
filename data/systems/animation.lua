local concord = require("libraries.concord")

local AnimationSystem = concord.system({pool = {"position", "sprite", "animation"}})

function AnimationSystem:updateState(entity, dt)
    if not entity:has("animation") then
        return
    end

    local quads = entity.sprite:quads()

    if not entity:has("state") then
        return
    end

    local current  = entity.state:current()

    if not quads[current] then
        error("Cannot animate entity '" .. entity.name .. "'! State '" .. tostring(current) .. "' does not exist!")
    end

    local rate = quads[current .. "Rate"] or 8

    entity.animation:update(rate * dt)
    entity.animation:setIndex(math.floor(entity.animation:time() % #quads[current]) + 1)

    if quads[current .. "StopAtEnd"] and entity.animation:index() == #quads[current] then
        return entity.animation:lock()
    end
    entity.animation:unlock()
end

function AnimationSystem:update(dt)
    for _, entity in ipairs(self.pool) do
        if not self:updateState(entity, dt) then

        end
    end
end

return AnimationSystem
