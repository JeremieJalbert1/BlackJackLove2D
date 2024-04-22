E = require("Helpers.Luvent")
local Game = require("Game")

function love.load()
    math.randomseed(os.time())
    love.window.setMode(1200, 800, {fullscreen = true})

    game = Game:new()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    game:draw()
    local fps = love.timer.getFPS()
    love.graphics.print("FPS: " .. tostring(fps), 10, 10)
end
