local Game = require("Game")

function love.load()
    math.randomseed(os.time())
    love.window.setMode(1200, 800, {fullscreen = true})
    
    game = Game.new()
end

function love.update(deltaTime)
    game:update(deltaTime)
    if game.quit then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    game:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    game:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    game:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
    game:mousemoved(x, y, dx, dy)
end

function love.keypressed(k)
    if k == 'escape' then
       love.event.quit()
    end
 end