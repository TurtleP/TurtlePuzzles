local concord = require("libraries.concord")
local debug = concord.system({pool = {"position", "size"}})

local scale = 1
local function wireframe(zoom, x, y, width, height)
    love.graphics.rectangle("line", x * (scale / zoom), y * (scale / zoom), width * (scale / zoom), height * (scale / zoom))
end

function debug:init()
    self.zoom = 4
end

function debug:draw(screen)
    love.graphics.push()
    love.graphics.origin()

    love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() - love.graphics.getFont():getWidth(love.timer.getFPS()))

    for _, entity in ipairs(self.pool) do
        if entity.screen.name == screen then
            wireframe(self.zoom, entity.position:x(), entity.position:y(), entity.size:width(), entity.size:height())
        end
    end

    love.graphics.pop()
end

return debug
