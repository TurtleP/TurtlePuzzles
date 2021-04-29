local concord = require("libraries.concord")
local bump    = require("libraries.bump")

local Physics = concord.system({pool = {"position", "size"}})

function Physics:init()
    self.world = bump.newWorld(16)
end

function Physics:onEntityAdded(entity)
    self.world:add(entity, entity.position.x, entity.position.y, entity.size.width, entity.size.height)
end

-- other filter instructions
local otherFilter = function(_, _)
    return "slide"
end

local function screenFilter(this, other)
    if this.screen.name ~= other.screen.name then
        return false
    end
    return otherFilter(this, other)
end

function Physics:update(dt)
    for _, entity in ipairs(self.pool) do
        -- check the entity exists or something
        if not self.world:hasItem(entity) then
            return
        end

        if entity:has("state") then
            entity.state:update(dt)
        end

        -- update velocity
        if entity:has("velocity") then
            entity.velocity.y = math.min(entity.velocity.y + entity.velocity.gravity * dt, entity.velocity.gravity)

            if entity:has("mask") then
               otherFilter = entity.mask.func
            end

            local ax, ay, collisions, len = self.world:move(entity, entity.position.x + entity.velocity.x * dt, entity.position.y + entity.velocity.y * dt, screenFilter)

            -- hit something, resolve
            if entity:has("collision") and #collisions > 0 then
                for index = 1, #collisions do
                    if collisions[index].normal.y ~= 0 then
                        self:resolveVertical(entity, collisions[index])
                    elseif collisions[index].normal.x ~= 0 then
                        self:resolveHorizontal(entity, collisions[index])
                    end
                end
            end

            entity.position:set(ax, ay)
        end
    end
end

function Physics:resolveVertical(entity, against)
    if entity.velocity.y > 0 then
        if entity.collision.floor then
            if not entity.collision.floor(entity, against.other) then
                entity.velocity.y = 0
            end
        else
            entity.velocity.y = 0
        end
    else
        if entity.collision.ceil then
            if not entity.collision.ceil(entity, against.other) then
                entity.velocity.y = 0
            end
        else
            entity.velocity.y = 0
        end
    end
end

function Physics:resolveHorizontal(entity, against)
    if entity.velocity.x > 0 then
        if entity.collision.right then
            if not entity.collision.right(entity, against.other) then
                entity.velocity.x = 0
            end
        else
            entity.velocity.x = 0
        end
    else
        if entity.collision.left then
            if not entity.collision.left(entity, against.other) then
                entity.velocity.x = 0
            end
        else
            entity.velocity.x = 0
        end
    end
end

return Physics
