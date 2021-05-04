local concord = require("libraries.concord")

local UISystem = concord.system({pool = {"inventory"}})

local __PLAYER__ = nil
local inventory  = nil

local core = require("data.core")

local textures = core.textures
local fonts    = core.fonts
local sound    = core.sounds

local tween = require("libraries.tween")

function UISystem:init()
    self.pool.onEntityAdded = function(_, entity)
        if entity.name:is("player") then
            __PLAYER__ = entity

            inventory = __PLAYER__.inventory
        end
    end

    self.livesPosition    = -14
    self.livesPositionMax = 8

    self.livesTween = tween.new(1, self, {livesPosition = 8}, "inOutBack")
    self.resetTween = false

    self.livesTimer = timer:new(3, nil, function()
        self.resetTween = true
    end)

    self.paused = false
end

function UISystem:gamepadpressed(button)
    if button == "start" then
        self:pause()
    end
end

function UISystem:pause()
    self.paused = not self.pausedd
end

function UISystem:update(dt)
    if self.resetTween then
        dt = -dt
    end

    self.livesTween:update(dt)
    self.livesTimer:update(dt)
end

function UISystem:draw(screen, depth)
    love.graphics.push()
    love.graphics.origin()

    -- don't draw if not the same screen
    -- can't return or we get too many pushes
    if screen == __PLAYER__.screen.name then
        if screen == "top" then

        end

        -- draw lives
        love.graphics.draw(textures.game.lives, 8, self.livesPosition)
        love.graphics.print(inventory:getLives(), fonts.ui, 8 + textures.game.lives:getWidth() + 8, (self.livesPosition + 2) + (textures.game.key:getHeight() / 2) - fonts.ui:getHeight() / 2)

        -- draw key count
        love.graphics.translate(love.graphics.getWidth() * 0.88, love.graphics.getHeight() * 0.85)

        love.graphics.draw(textures.game.key, 8, 8, math.pi / 4, 1, 1, -4, 4)
        love.graphics.print(inventory:getKeys(), fonts.ui, 8 + textures.game.key:getWidth() + 4, (12 + textures.game.key:getHeight() / 2) - fonts.ui:getHeight() / 2)

        -- render the pause menu
        if self.paused then
            love.graphics.push("all")
            love.graphics.setColor(0, 0, 0, 0.75)
            -- love.graphics.rectangle("fill", )

            love.graphics.pop()
        end
    end
    love.graphics.pop()

    love.graphics.push("all")
    if self.paused then
        love.graphics.setColor(0, 0, 0, 0.45)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
    love.graphics.pop()
end

function UISystem:addKey(amount)
    inventory:addKey(amount)
    sound.play("collect")
end

return UISystem
