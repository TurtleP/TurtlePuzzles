local sounds = {}
sounds.inited = false

local path = "assets/sounds"
local assetPath = path .. "/%s"

function sounds.init()
    if sounds.inited then
        error("Cannot re-init module")
    end

    local soundFiles = love.filesystem.getDirectoryItems(path)
    for index = 1, #soundFiles do
        local name = soundFiles[index]:gsub(".ogg", "")
        sounds[name] = love.audio.newSource(assetPath:format(soundFiles[index]), "static")
    end

    sounds.inited = true
    return sounds
end

function sounds.play(name)
    assert(name and sounds[name], "Cannot play sound '" .. tostring(name) .. "'. Does not exist!")
    sounds[name]:play()
end

return sounds
