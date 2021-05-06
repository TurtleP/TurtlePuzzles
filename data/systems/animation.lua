local concord = require("libraries.concord")

local AnimationSystem = concord.system({pool = {"position", "sprite", "animation"}})

function AnimationSystem:updateState(entity, dt)
    local quads, rate = nil, entity.animation:rate()
    if not entity:has("animation") then
        return
    else
        quads = entity.sprite:quads()
        entity.animation:update(rate * dt)

        if not entity:has("state") then
            entity.animation:setIndex(math.floor(entity.animation:time() % #quads) + 1)
        else
            local current  = entity.state:current()

            if not quads[current] then
                error("Cannot animate entity '" .. entity.name.value .. "'! State '" .. tostring(current) .. "' does not exist!")
            end

            rate = quads[current .. "Rate"] or 8

            entity.animation:setIndex(math.floor(entity.animation:time() % #quads[current]) + 1)

            if quads[current .. "StopAtEnd"] and entity.animation:index() == #quads[current] then
                return entity.animation:lock()
            end
            entity.animation:unlock()
        end
    end
end

function AnimationSystem:update(dt)
    for _, entity in ipairs(self.pool) do
        if not self:updateState(entity, dt) then

        end
    end
end

return AnimationSystem
