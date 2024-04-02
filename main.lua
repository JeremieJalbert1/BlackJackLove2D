local Game = require("Game")

function love.load()
    math.randomseed(os.time())
    love.window.setMode(1200, 800, {fullscreen = false})
    
    game = Game.new()
    game:dealHand()
end

function love.update(deltaTime)
    game:update(deltaTime)
end

function love.draw()
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    game:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        game:mousepressed(x, y, button, istouch, presses)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    game:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
    game:mousemoved(x, y, dx, dy)
end