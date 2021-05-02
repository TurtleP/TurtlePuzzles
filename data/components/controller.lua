local concord = require("libraries.concord")
local core    = require("data.core")

local sound = core.sounds

local PlayerController = concord.component("controller", function(component)
    local move = {"left", "right", "up", "down"}
    for _, value in ipairs(move) do
        component[value] = false
    end

    component.onLadder = false
    component.lastLadder = nil
end)

-- Set @direction (string) to @move (bool)
function PlayerController:move(direction, move)
    assert:type(direction, "string")
    assert:type(move, "boolean")

    self[direction] = move
end

-- check if @direction is in use or not
function PlayerController:moving(direction)
    assert:type(direction, "string")
    assert:type(self[direction], "boolean")

    return self[direction]
end

-- check if on a ladder
function PlayerController:isOnLadder()
    return self.onLadder
end

function PlayerController:getLadder()
    return self.lastLadder
end

function PlayerController:setLadder(object)
    self.lastLadder = object
    self.onLadder = (object ~= nil)
end

--[[
    OLD CODE BELOW --

local function resetClimbingStuff(entity)
    entity.state:unlock()
    entity.velocity:resetGravity()
    entity.velocity:setY(0)
    entity:remove("climbing"):remove("canclimb")
end

local function handleClimbingPosition(entity)
    local ladder = entity.climbing.value
    entity.position.x = ladder.position.x + (ladder.size.width - entity.size.width) * 0.5

    -- keep player between the ladder stuff
    if entity.velocity.y < 0 then
        if entity.position.y + entity.size.height <= ladder.position.y then
            resetClimbingStuff(entity)
        end
    else
        if entity.position.y + entity.size.height >= ladder.position.y + (ladder.size.height - 1) then
            resetClimbingStuff(entity)
        end
    end
end

function Controller:gamepadaxis(entity, axis, value)
    if axis == "leftx" then
        if entity.state:was("climb") then
            return
        end

        if value > 0.5 then
            if not entity.state:was("punch") then
                entity.velocity:setX(__PLAYER_SPEED__)
            end
            entity.state:set("walk")
            entity.state:setDirection(1)
        elseif value < -0.5 then
            if not entity.state:was("punch") then
                entity.velocity:setX(-__PLAYER_SPEED__)
            end
            entity.state:set("walk")
            entity.state:setDirection(-1)
        else
            if not entity.state:was("punch") then
                entity.velocity:setX(0)
            end
            entity.state:set("idle")
        end
    elseif axis == "lefty" then
        if value ~= 0 and entity:has("canclimb") then
            entity:ensure("climbing")
        end

        if entity:has("climbing") and entity.climbing:get() then
            entity.state:set("climb", true)
            handleClimbingPosition(entity)

            -- we're climbing
            if entity.state:was("climb") then
                if value < -0.5 then
                    entity.velocity:setY(-__PLAYER_SPEED__)
                elseif value > 0.5 then
                    entity.velocity:setY(__PLAYER_SPEED__)
                else
                    entity.velocity:setY(0)
                end
            end
        end
    end
end

function Controller:update(dt)
    if __PUNCH_TIMER__ then
        __PUNCH_TIMER__:update(dt)
    end
end

function Controller:gamepadpressed(entity, button)
    if entity.state:was("climb") then
        return
    end

    if button == "a" then
        if entity.velocity.y == 0 then
            entity.state:set("jump", true)
            sound.play("jump")
            entity.velocity.y = -160
        end
    end

    if button == "b" then
        if not entity.state:was("punch") then
            if entity.velocity.x == 0 then
                entity.velocity.x = (100 * entity.state.direction)
            end
            entity.state:set("punch", true)
            sound.play("charge")
            __PUNCH_TIMER__ = timer:new(1, nil, function()
                entity.state:unlock()
                entity.velocity.x = 0
            end)
        end
    end
end
]]
return PlayerController
