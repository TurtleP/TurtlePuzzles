local path = (...):gsub('%.init$', '')
local infoPath = path:gsub("%.", "/")

local function requireRelative(name)
    local success, value = nil, nil

    if love.filesystem.getInfo(infoPath .. "/" .. name .. ".lua") then
        success, value = pcall(require, path .. "." .. name)
    end

    if success then
        return value.init and value:init() or value
    end
    return error("Failed to load '" .. name .. "'! (" .. value .. ")")
end

-- cache textures, audio, etc
local core = {}

local fields = { "fonts", "music", "sounds",
                 "textures", "vars" }

for _, field in ipairs(fields) do
    core[field] = requireRelative(field)
end

return core
