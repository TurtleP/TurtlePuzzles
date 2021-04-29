local path = (...):gsub('%.init$', '')

local extensions =
{
    assertx    = require(path .. ".assert"),
    mathx      = require(path .. ".mathx"),
    stringx    = require(path .. ".stringx"),
    tablex     = require(path .. ".tablex"),
    functional = require(path .. ".functional")
}

local aliases =
{
    { "mathx",   "math"   },
    { "tablex",  "table"  },
    { "stringx", "string" },
}

for _, alias in ipairs(aliases) do
    extensions[alias[2]] = extensions[alias[1]]
end

local batteries = {}

function batteries:export()
    --export all key strings globally, if doesn't always exist
    for k, v in pairs(self) do
        if not _G[k] then
            _G[k] = v
        end
    end

    extensions.tablex.overlay(table, extensions.tablex)

    table.overlay(math, extensions.mathx)
    table.overlay(string, extensions.stringx)

    assert = extensions.assertx

    return self
end

return batteries
