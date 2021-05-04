local concord = require("libraries.concord")
local bump    = require("libraries.bump")

local tiled   = require("libraries.tiled")

local Physics = concord.system({pool = {"position", "size"}})

function Physics:init()
    self.world = bump.newWorld(16)

    self.pool.onEntityAdded = function(_, entity)
        self.world:add(entity, entity.position:x(), entity.position:y(), entity.size:width(), entity.size:height())
    end

    self.pool.onEntityRemoved = function(_, entity)
        self.world:remove(entity)
    end

    self.speedFactor = 1
end

-- other filter instructions
local otherFilter = function(_, _)
    return "slide"
end

function Physics:gamepadpressed(button)
    if button == "leftshoulder" then
        self.speedFactor = math.max(self.speedFactor - 0.2, 1)
    elseif button == "rightshoulder" then
        self.speedFactor = math.min(self.speedFactor + 0.2, 4)
    end
end

local function screenFilter(this, other)
    if this.screen ~= other.screen then
        return false
    end
    return otherFilter(this, other)
end

--[[
    for physics collisions to work, entities require position, velocity, and collision

    if an entity is passive, make sure that it's in the entity mask and returns "cross"
    otherwise it .. won't do anything
--]]
function Physics:update(dt)
    dt = dt / self.speedFactor
    for _, entity in ipairs(self.pool) do
        -- check the entity exists or something
        if not self.world:hasItem(entity) then
            return
        end

        -- update velocity
        if entity:has("velocity") and entity.velocity.gravity ~= 0 then
            entity.velocity.y = math.min(entity.velocity.y + entity.velocity.gravity * dt, entity.velocity.gravity)
        end

        if entity:has("collision") then
            if entity:has("mask") then
               otherFilter = entity.mask.func
            end

            local ax, ay, collisions, len
            if entity:has("velocity") then
                if not self:resolveScreenChange(entity, dt) then
                    ax, ay, collisions, len = self.world:move(entity, entity.position:x() + entity.velocity.x * dt, entity.position:y() + entity.velocity.y * dt, screenFilter)
                end
            end

            -- hit something, resolve
            if len and len > 0 then
                for index = 1, #collisions do
                    if not collisions[index].other:has("passive") then
                        if collisions[index].normal.y ~= 0 then
                            self:resolveVertical(entity, collisions[index])
                        elseif collisions[index].normal.x ~= 0 then
                            self:resolveHorizontal(entity, collisions[index])
                        end
                    else
                        entity.collision.passive(entity, collisions[index].other)
                    end
                end
            end

            -- set new position
            if ax and ay then
                entity.position:set(ax, ay)
            end
        end
    end
end

function Physics:resolveScreenChange(entity, dt)
    if not entity:has("velocity") then
        return
    end

    local position = entity.position
    local screen   = entity.screen
    local size     = entity.size

    -- check if off top screen
    local pass = false
    local offset = 40
    if position:x() < 160 then
        offset = 0
    end

    if position:y() > tiled.getSize(screen.name).height then
        if screen:is("top") then
            if entity.name:is("player") then
                tiled.getMap("bottom"):setCameraTarget(entity)
            end
            screen:set("bottom", function()
                self.world:update(entity, entity.position:x() - offset, 0)
                position:set(position:x() - offset, 0)
                pass = true
            end)
        end
    elseif position:y() + size:height() < 0 then
        if screen:is("bottom") then
            if entity.name:is("player") then
                tiled.getMap("top"):setCameraTarget(entity)
            end
            screen:set("top", function()
                self.world:update(entity, entity.position:x() + offset, 240 - size:height())
                position:set(position:x() + offset, 240 - size:height())
                pass = true
            end)
        end
    end

    return pass
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
