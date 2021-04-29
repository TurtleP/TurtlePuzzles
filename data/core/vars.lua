local variables = {}
variables.inited = false

function variables.init()
    if variables.inited then
        error("Cannot re-init module")
    end

    variables.TOP_SCREEN_W = 400
    variables.BOT_SCREEN_W = 320
    variables.SCREEN_H     = 240

    variables.TOP_SCREEN_SIZE = {width = variables.TOP_SCREEN_W, height = variables.SCREEN_H}
    variables.BOT_SCREEN_SIZE = {width = variables.BOT_SCREEN_W, height = variables.SCREEN_H}

    variables.inited = true
    return variables
end

return variables
