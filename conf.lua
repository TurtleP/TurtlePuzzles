function love.conf(t)
	t.console = true
    t.title = "Turtle"        -- The title of the window the game is in (string)
    t.author = "Tiny Turtle Industries"        -- The author of the game (string)
    t.identity = "Turtle"          -- The name of the save directory (string)
    t.version = "0.8.0"         -- The LÖVE version this game was made for (string)
    t.modules.joystick = false   -- Enable the joystick module (boolean)
    t.modules.physics = false   -- Enable the physics module (boolean)
end