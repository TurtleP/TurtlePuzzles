local menu = {}

local core  = require("data.core")
local save  = require("data.core.save")
local state = require("states")

local textures = core.textures
local music    = core.music
local sound    = core.sounds
local vars     = core.vars

local savefile = require("data.classes.savefile")

local function newCloud(x, y, texture)
    local cloud = {}

    cloud.x = x
    cloud.y = y

    cloud.width = 114

    cloud.texture = texture
    cloud.period = love.math.random(1, 1.5)
    cloud.amplitude = love.math.random(4, 6)

    function cloud:draw()
        love.graphics.draw(self.texture, self.x, self.y + math.sin(love.timer.getTime() * self.period) * self.amplitude)
    end

    return cloud
end

function menu:enter()
    self.backdrops = { left = textures.menu.left, bottom = textures.menu.bottom }

    self.clouds = {}

    local start = love.math.random(5, 15)
    table.insert(self.clouds, newCloud(start, 50, textures.menu.clouds[1]))
    start = start + 114
    table.insert(self.clouds, newCloud(start, 80, textures.menu.clouds[3]))
    start = start + 140
    table.insert(self.clouds, newCloud(start, 40, textures.menu.clouds[2]))
    start = start + 69
    table.insert(self.clouds, newCloud(start, 90, textures.menu.clouds[4]))

    self.saveFiles = {}
    for i = 1, 3 do
        self.saveFiles[i] = savefile(i, 16 + (i - 1) * 72, save.getData(i))
    end
    self.saveFiles[1].selected = true
    self.selection = 1

    music.play("title")

    self.fade = 0
    self.inputName = false
    self.startGame = false
end

function menu:update(dt)
    if self.startGame then
        self.fade = math.min(self.fade + dt / 0.8, 1)
        if self.fade == 1 then
            state.switch("game", "test")
        end
    end
end

function menu:textinput(text)
    if self.inputName then
        if #text > 0 then
            save.initFile(self.selection, {name = text})
            self.saveFiles[self.selection]:init(save.getData(self.selection))
            self.inputName = false
        end
    end
end

function menu:drawTop(depth)
    love.graphics.draw(self.backdrops.left)

    for _, cloud in ipairs(self.clouds) do
        cloud:draw()
    end

    love.graphics.draw(textures.menu.title, textures.centerX(textures.menu.title, vars.TOP_SCREEN_W) - (6.0 * depth), textures.centerY(textures.menu.title, vars.SCREEN_H))

    love.graphics.setColor(0, 0, 0, self.fade)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function menu:drawBottom()
    love.graphics.draw(self.backdrops.bottom)

    for _, saveFile in ipairs(self.saveFiles) do
        saveFile:draw()
    end

    love.graphics.setColor(0, 0, 0, self.fade)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function menu:gamepadpressed(_, button)
    if self.startGame or self.inputName then
        return
    end

    if button == "dpdown" or button == "dpup" then
        self.saveFiles[self.selection].selected = false
        if button == "dpdown" then
            if self.selection < #self.saveFiles then
                sound.play("select")
            end
            self.selection = math.min(self.selection + 1, #self.saveFiles)
        elseif button == "dpup" then
            if self.selection > 1 then
                sound.play("select")
            end
            self.selection = math.max(self.selection - 1, 1)
        end
        self.saveFiles[self.selection].selected = true
    elseif button == "a" then
        if self.saveFiles[self.selection]:isNew() then
            self.inputName = true -- this blocks on 3ds
            return love.keyboard.setTextInput({maxLength = 8})
        end
        self.startGame = true
    end
end

function menu:leave()
    self.backdrops = nil
    self.clouds = nil
    self.saveFiles = nil

    music.stop()
end

return menu
