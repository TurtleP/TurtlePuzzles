local Object = require("libraries.classic")
local SaveFile = Object:extend()

local fonts = core.fonts
local textures = core.textures

-- This is similar to love.graphics.rectangle, except that the rectangle has
-- rounded corners. r = radius of the corners, n ~ #points used in the polygon.
local function rounded_rectangle(x, y, w, h, r, n)
    n = n or 20  -- Number of points in the polygon.
    if n % 4 > 0 then n = n + 4 - (n % 4) end  -- Include multiples of 90 degrees.
    local pts, c, d, i = {}, {x + w / 2, y + h / 2}, {w / 2 - r, r - h / 2}, 0

    while i < n do
        local a = i * 2 * math.pi / n
        local p = {r * math.cos(a), r * math.sin(a)}
        for j = 1, 2 do
            table.insert(pts, c[j] + d[j] + p[j])
            if p[j] * d[j] <= 0 and (p[1] * d[2] < p[2] * d[1]) then
            d[j] = d[j] * -1
            i = i - 1
            end
        end
        i = i + 1
    end
    return pts
end

local function getTime(s)
    return string.format("%.2d:%.2d:%.2d", s/(60*60), s/60%60, s%60)
end

function SaveFile:new(id, y, data)
    self.id = id
    self.y = y

    self.width = love.graphics.getWidth("bottom") * 0.85
    self.x = (love.graphics.getWidth("bottom") - self.width) * 0.5

    self.height = 64

    self.data = data
    self.emptyFileString = "New Game"

    self.box = rounded_rectangle(self.x, self.y, self.width, self.height, 8)

    self:init(data)
end

function SaveFile:init(data)
    self.data = data

    if not data then
        return
    end

    self.time = getTime(self.data.time * 1000) -- convert ms to s
    self.location = "Floor " .. self.data.floor .. "-" .. self.data.level
    self.gems = self.data.gems
    self.name = self.data.name
end

function SaveFile:isNew()
    return self.data == nil
end

local padding = 8
function SaveFile:draw()
    love.graphics.setColor(0, 0, 0, 0.85)
    love.graphics.polygon("fill", self.box)

    local color = {1, 1, 1, 1}
    if self.selected then
        love.graphics.setColor(1, 1, 1, math.abs(math.sin(love.timer.getTime() / 0.5)))
        love.graphics.polygon("line", self.box)
    else
        color = {0.5, 0.5, 0.5, 1}
    end

    love.graphics.setColor(color)

    if not self.data then
        love.graphics.print(self.emptyFileString, fonts.fileSelectBig, self.x + (self.width / 2) - fonts.fileSelectBig:getWidth(self.emptyFileString) / 2, self.y + (self.height / 2) - fonts.fileSelectBig:getHeight() / 2)
    else
        love.graphics.draw(textures.menu.saveFiles, textures.menu.saveQuads[self.id], self.x + padding, self.y + (self.height - textures.menu.saveFiles:getHeight()) / 2)

        love.graphics.print(self.time, fonts.fileSelect, self.x + (self.width * 0.85) - fonts.fileSelect:getWidth(self.time), self.y + padding)
        love.graphics.print(self.name, fonts.fileSelect, self.x + (self.width * 0.25), self.y + padding)

        for i = 1, 3 do
            local which = 4
            if self.gems > 0 then
                which = i
            end
            love.graphics.draw(textures.game.gems, textures.game.gemQuads[which], self.x + (self.width * 0.25) + (i - 1) * 14, self.y + (self.height - textures.game.gems:getHeight() - padding))
        end

        love.graphics.print(self.location, fonts.fileSelect, self.x + (self.width * 0.85) - fonts.fileSelect:getWidth(self.location), self.y + (self.height - fonts.fileSelect:getHeight() - padding))
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return SaveFile
