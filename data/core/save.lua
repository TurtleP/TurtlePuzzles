local save = {}

local msgpack = require("libraries.msgpack")
local utf8    = require("utf8")

save.empty = { name = "", time = 0, gems = 0, floor = 0, level = 0 }
save.filename  = "turtle_puzzles"

save.animation = nil

save.data = {}

local vars = core.vars

local function newSaveAnimation()
    local animation = {}

    animation.glyphs = { "0xE020", "0xE021", "0xE022", "0xE023",
                         "0xE024", "0xE025", "0xE026", "0xE027" }

    animation.index = 0
    animation.timer = 0
    animation.loops = 0

    animation.font = love.graphics.newFont(16)

    animation.y = vars.SCREEN_H - animation.font:getHeight()

    function animation:update(dt)
        if self.loops < 3 then
            self.timer = self.timer + 16 * dt
            self.index = math.floor(self.timer % #self.glyphs) + 1

            if self.index == #self.glyphs then
                self.loops = self.loops + 1
                self.timer = 0
            end
            return false
        end
        return true
    end

    function animation:draw(depth)
        love.graphics.setColor(1, 1, 1, 1)

        local text = utf8.char(self.glyphs[self.index])
        local x = (vars.TOP_SCREEN_W - self.font:getWidth(text)) - (2.0 * depth)

        love.graphics.print(text, self.font, x - 2, self.y - 2)
    end

    return animation
end

function save.initFile(index, data)
    local edited = save.empty
    for key, _ in pairs(edited) do
        if data[key] then
            edited[key] = data[key]
        end
    end
    save.apply(index, edited)
end

function save.update(dt)
    if save.animation then
        if save.animation:update(dt) then
            save.animation = nil
        end
    end
end

function save.getData(index)
    return save.data[index]
end

function save.apply(index, data)
    save.data[index] = data
    love.filesystem.write(save.filename, msgpack.pack(save.data))

    save.animation = newSaveAnimation()
end

function save.draw(depth)
    if save.animation then
        save.animation:draw(depth)
    end
end

return save
