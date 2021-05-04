local concord = require("libraries.concord")

local core    = require("data.core")
local sound   = core.sounds

local tiled   = require("libraries.tiled")

local PlayerControllerSystem = concord.system({pool = {"position", "size", "velocity", "controller"}})

local __PLAYER__       = nil
local __PUNCH_TIMER__  = nil

local __PLAYER_SPEED__      = 75
local __PLAYER_JUMP_SPEED__ = -160

local controller = nil
local state      = nil
local velocity   = nil
local animation  = nil
local size       = nil
local position   = nil
local screen     = nil

function PlayerControllerSystem:init(world)
    self.pool.onEntityAdded = function(_, entity)
        if entity.name:is("player") then
            __PLAYER__ = entity

            controller = __PLAYER__.controller
            state      = __PLAYER__.state
            velocity   = __PLAYER__.velocity
            animation  = __PLAYER__.animation
            size       = __PLAYER__.size
            position   = __PLAYER__.position
            screen     = __PLAYER__.screen
        end
    end
end

function PlayerControllerSystem:dropLadder()
    if controller:isOnLadder() then
        velocity:setY(0)

        controller:getLadder():remove("passive")
        controller:setLadder(nil)
    end

    if velocity.gravity == 0 then
        velocity:resetGravity()
    end
end

function PlayerControllerSystem:checkLadder(ladder)
    if not controller:isOnLadder() then
        local ladderPosition = ladder.position

        -- check ladder bounds or something
        if position:y() + size:height() > ladder.position:y() or
           position:y() < ladder.position:y() then
            -- are we moving on it
            if controller:moving("up") or controller:moving("down") then
                velocity:setGravity(0)
                if not state:is("climb") then
                    state:unlock()
                end
                state:set("climb", true)
                controller:setLadder(ladder)
                ladder:give("passive")
            end
        end
    end
end

function PlayerControllerSystem:update(dt)
    if __PUNCH_TIMER__ then
        __PUNCH_TIMER__:update(dt)
    end

    -- horizontal movements
    if not state:is("punch") then
        local xspeed = 0
        if controller:moving("right") then
            xspeed = __PLAYER_SPEED__
            state:setDirection(1)
        elseif controller:moving("left") then
            xspeed = -__PLAYER_SPEED__
            state:setDirection(-1)
        end
        velocity:setX(xspeed)
    end

    if velocity:stopped() then
        state:set("idle")
    end

    if velocity:getY() == 0 then
        if velocity:getX() ~= 0 then
            state:set("walk", true)
        else
            if state:is("walk") then
                state:unlock()
            end
        end
    end

    -- ladder movements -- check bottom first
    local result = tiled.checkRectangle(__PLAYER__.screen.name, position:x(), position:y(),     size:width(), size:height(), {{"exclude", __PLAYER__}, "tile"})
    if #result == 0 then
        result =   tiled.checkRectangle(__PLAYER__.screen.name, position:x(), position:y() + 1, size:width(), size:height(), {{"exclude", __PLAYER__}, "tile"})
    end

    if #result == 0 then
        self:dropLadder()
    else
        if result[1]:has("climbable") then
            self:checkLadder(result[1])
        end
    end

    local yspeed = 0
    if state:is("climb") then
        local ladder = controller:getLadder()
        if not ladder then
            self:dropLadder()
            state:unlock()
            return
        end
        position:set(ladder.position:x() + (ladder.size:width() - size:width()) * 0.5)

        if controller:moving("up") then
            yspeed = -__PLAYER_SPEED__
        elseif controller:moving("down") then
            yspeed = __PLAYER_SPEED__
        end
        velocity:setY(yspeed)
    end

    if velocity:getY() > 0 and not state:is("climb") then
        if not state:is("jump") then
            state:unlock()
        end
        state:set("jump", true)
    end
end

function PlayerControllerSystem:gamepadaxis(axis, value)
    if axis == "leftx" then

        if value > -0.5 and value < 0.5 then
            controller:move("right", false)
            controller:move("left",  false)
        end

        if state:is("climb") then
            return
        end

        if value > 0.5 then
            controller:move("left",  false)
            controller:move("right", true)
        elseif value < -0.5 then
            controller:move("right", false)
            controller:move("left",  true)
        end
    elseif axis == "lefty" then
        if value < -0.5 then
            controller:move("down", false)
            controller:move("up",   true)
        elseif value > 0.5 then
            controller:move("up",   false)
            controller:move("down", true)
        else
            controller:move("up",   false)
            controller:move("down", false)
        end
    end
end

function PlayerControllerSystem:gamepadpressed(button)
    -- don't allow this on climbing
    if state:is("climb") then
        return
    end

    if button == "a" then
        if velocity.y == 0 then
            -- override walking on jump
            if state:is("walk") then
                state:unlock()
            end
            state:set("jump", true)
            sound.play("jump")
            velocity:setY(__PLAYER_JUMP_SPEED__)
        end
    elseif button == "y" then
        -- override walking on punch
        if state:is("walk") then
            state:unlock()
        end
        state:set("punch", true)
        sound.play("charge")

        velocity:setX(100 * state.direction)

        __PUNCH_TIMER__ = timer:new(1, nil, function()
            state:unlock()
        end)
    elseif button == "x" then
        position:set(position:getX() - 40, -200)
        tiled.getMap("bottom"):setCameraTarget(__PLAYER__)
        screen:set("bottom")
    end
end

return PlayerControllerSystem
