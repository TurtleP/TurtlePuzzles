local music = {}

music.inited  = false
music.current = nil

local path = "assets/music"
local assetPath = path .. "/%s"

function music.init()
    if music.inited then
        error("Cannot re-init module")
    end

    local songs = love.filesystem.getDirectoryItems(path)
    for index = 1, #songs do
        local name = songs[index]:gsub(".ogg", "")

        music[name] = love.audio.newSource(assetPath:format(songs[index]), "stream")
        music[name]:setLooping(true)
    end

    music.inited = true
    return music
end

function music.play(name)
    assert:type(name, "string")
    assert:some(music[name], "Cannot play music '" .. tostring(name) .. "'. Does not exist!")

    if music.current then
        music.current:stop()
    end
    music.current = music[name]
    music[name]:play()
end

function music.stop()
    if music.current then
        music.current:stop()
    end
end

return music
