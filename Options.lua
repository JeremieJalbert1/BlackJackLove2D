local Option = require("Option")

local Options = {}
Options.__index = Options

function Options.new(player, dealer)
    local self = setmetatable({}, Options)
    local screenWidth = love.graphics.getWidth()
    local optionWidth = 100
    local optionHeight = 50
    local optionSpacing = 20  -- The spacing between each option

    -- Calculate the total width all the options will take
    local totalOptionsWidth = (4 * optionWidth) + ((4 - 1) * optionSpacing)

    -- Calculate the starting X position for the first option to center them
    local startX = (screenWidth - totalOptionsWidth) / 2

    -- Define the Y position for all options
    local optionY = (love.graphics.getHeight() - optionHeight) / 2
    
    self.hit = Option.new("Hit", startX, optionY, optionWidth, optionHeight, function() player:hit(dealer) end)
    self.stay = Option.new("Stay", startX + (optionWidth + optionSpacing) * 1, optionY, optionWidth, optionHeight, function() player:stay(dealer) end)
    self.double = Option.new("Double", startX + (optionWidth + optionSpacing) * 2, optionY, optionWidth, optionHeight, function() player:double(dealer) end)
    self.split = Option.new("Split", startX + (optionWidth + optionSpacing) * 3, optionY, optionWidth, optionHeight, function() player:split(dealer) end)

    return self
end

function Options:update(dt)
    -- empty
end

function Options:setStates(isActive)
    self.hit:setState(isActive)
    self.stay:setState(isActive)
    self.double:setState(isActive)
    self.split:setState(isActive)
end

function Options:draw()
    self.hit:draw()
    self.stay:draw()
    self.double:draw()
    self.split:draw()
end

function Options:mousepressed(x, y, button)
    self.hit:clicked()
    self.stay:clicked()
    self.double:clicked()
    self.split:clicked()
end

return Options