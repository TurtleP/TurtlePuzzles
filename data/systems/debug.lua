local concord = require("libraries.concord")
local debug = concord.system({pool = {"position", "size"}})

local scale = 1
local function wireframe(zoom, x, y, width, height)
    love.graphics.rectangle("line", x * (scale / zoom), y * (scale / zoom), width * (scale / zoom), height * (scale / zoom))
end

function debug:init()
    self.zoom = 1
end

function debug:draw(screen)
    for _, entity in ipairs(self.pool) do
        if entity.screen.name == screen then
            wireframe(self.zoom, entity.position:x(), entity.position:y(), entity.size:width(), entity.size:height())
        end
    end
end

return debug
